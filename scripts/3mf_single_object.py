#!/usr/bin/env python3
"""
Restructure a Fusion 360-exported 3MF into a single multi-part object.

WHY THIS EXISTS
---------------
Fusion's `exportManager.createC3MFExportOptions(root, path)` writes a multi-body
design as N *independent* top-level objects -- one <object> plus one
<build><item> per BRepBody.

Every build item is an independent model as far as a slicer is concerned. Bambu
Studio (and PrusaSlicer / OrcaSlicer, same lineage) places each one on the plate
individually, which includes dropping it to the bed so its min Z becomes 0. Any
body that did not already start at Z=0 gets yanked out of position and scattered
flat around the plate.

The usual symptom is alarming: a heap of duplicated-looking junk geometry lying
on the bed next to the real model. The mesh data is actually fine and completely
unmodified -- only the *placement* is wrong, and only at load time. Before
assuming a model is broken, unzip the 3mf and check part positions.

THE FIX
-------
Rewrap the N objects as <components> of ONE object, referenced by a single build
item. That is the standard 3MF multi-part representation, so the parts keep their
relative positions and load as one object with N named parts -- which is also
exactly what you want for assigning per-part filaments in a multi-color print.

Mesh data is never touched; only <build> and one added wrapper <object>.

USAGE
-----
    python 3mf_single_object.py model.3mf                    # in place, keeps .bak
    python 3mf_single_object.py model.3mf -o fixed.3mf       # write elsewhere
    python 3mf_single_object.py model.3mf --name "My Part"   # name the object
    python 3mf_single_object.py model.3mf --verify           # check meshes intact

Idempotent: running it on an already-restructured file is a no-op.

Verified against "HC - 12oz - Can Koozie" (59 bodies: 1 koozie + 16 text + 42
lips) exported from Fusion 360. See 3dprints/koozie/README.md.
"""

import argparse
import os
import shutil
import sys
import uuid
import zipfile
import xml.etree.ElementTree as ET

CORE = "http://schemas.microsoft.com/3dmanufacturing/core/2015/02"
MATERIAL = "http://schemas.microsoft.com/3dmanufacturing/material/2015/02"
PRODUCTION = "http://schemas.microsoft.com/3dmanufacturing/production/2015/06"
BEAMLATTICE = "http://schemas.microsoft.com/3dmanufacturing/beamlattice/2017/02"
SLICE = "http://schemas.microsoft.com/3dmanufacturing/slice/2015/07"
SECURE = "http://schemas.microsoft.com/3dmanufacturing/securecontent/2019/04"

C = "{%s}" % CORE
P = "{%s}" % PRODUCTION

MODEL_PATH = "3D/3dmodel.model"


def _register_namespaces():
    """Keep the original prefixes so the rewritten XML stays readable."""
    for prefix, uri in [
        ("", CORE), ("m", MATERIAL), ("p", PRODUCTION),
        ("b", BEAMLATTICE), ("s", SLICE), ("sc", SECURE),
    ]:
        ET.register_namespace(prefix, uri)


def _mesh_summary(root):
    """Map object id -> (name, vertex count, triangle count) for verification."""
    out = {}
    for obj in root.find(C + "resources").findall(C + "object"):
        mesh = obj.find(C + "mesh")
        if mesh is None:
            continue
        verts = mesh.find(C + "vertices")
        tris = mesh.find(C + "triangles")
        out[obj.get("id")] = (
            obj.get("name") or "",
            len(verts.findall(C + "vertex")) if verts is not None else 0,
            len(tris.findall(C + "triangle")) if tris is not None else 0,
        )
    return out


def restructure(model_xml, group_name):
    """Rewrite the model XML so all build items become parts of one object.

    Returns (new_xml_bytes, message). new_xml_bytes is None if nothing to do.
    """
    root = ET.fromstring(model_xml)
    resources = root.find(C + "resources")
    build = root.find(C + "build")
    if resources is None or build is None:
        raise ValueError("3mf model XML has no <resources> or <build> section")

    items = build.findall(C + "item")
    if not items:
        raise ValueError("3mf model XML has no build items")

    objects = {o.get("id"): o for o in resources.findall(C + "object")}

    if len(items) == 1:
        target = objects.get(items[0].get("objectid"))
        if target is not None and target.find(C + "components") is not None:
            n = len(target.find(C + "components").findall(C + "component"))
            return None, "already a single multi-part object (%d parts) -- no change" % n
        return None, "only one build item and it is a plain mesh -- nothing to group"

    # Preserve each item's transform on the corresponding component so parts
    # that Fusion placed with an offset keep it.
    referenced = [(it.get("objectid"), it.get("transform")) for it in items]
    missing = [oid for oid, _ in referenced if oid not in objects]
    if missing:
        raise ValueError("build references undefined object ids: %s" % missing)

    new_id = max(int(o.get("id")) for o in objects.values()) + 2

    wrapper = ET.SubElement(resources, C + "object")
    wrapper.set("id", str(new_id))
    wrapper.set("name", group_name)
    wrapper.set("type", "model")
    wrapper.set(P + "UUID", str(uuid.uuid4()))

    components = ET.SubElement(wrapper, C + "components")
    for oid, transform in referenced:
        comp = ET.SubElement(components, C + "component")
        comp.set("objectid", oid)
        if transform:
            comp.set("transform", transform)
        comp.set(P + "UUID", str(uuid.uuid4()))

    for item in items:
        build.remove(item)
    item = ET.SubElement(build, C + "item")
    item.set("objectid", str(new_id))
    item.set(P + "UUID", str(uuid.uuid4()))
    item.set("printable", "1")

    xml = b'<?xml version="1.0" encoding="utf-8"?>\n' + ET.tostring(root, encoding="utf-8")
    return xml, "grouped %d build items into object id=%d (%r)" % (
        len(referenced), new_id, group_name)


def process(src, dst, group_name, verify, backup):
    if not zipfile.is_zipfile(src):
        raise ValueError("not a 3mf: %s is not a zip archive" % src)

    with zipfile.ZipFile(src) as z:
        names = z.namelist()
        if MODEL_PATH not in names:
            raise ValueError("not a 3mf: %s missing from archive" % MODEL_PATH)
        blobs = {n: z.read(n) for n in names}

    before = _mesh_summary(ET.fromstring(blobs[MODEL_PATH])) if verify else None

    new_xml, message = restructure(blobs[MODEL_PATH], group_name)
    print(message)
    if new_xml is None:
        return False

    blobs[MODEL_PATH] = new_xml

    if verify:
        after = _mesh_summary(ET.fromstring(new_xml))
        if before != after:
            raise AssertionError("mesh data changed during restructure -- aborting")
        print("verified: %d meshes intact, vertex and triangle counts unchanged"
              % len(after))

    # Only now that the work has succeeded is a backup worth taking -- this
    # keeps failed and no-op runs from littering .bak files.
    if backup:
        shutil.copy2(src, backup)
        print("backup: %s" % backup)

    tmp = dst + ".tmp"
    with zipfile.ZipFile(tmp, "w", zipfile.ZIP_DEFLATED) as z:
        for n in names:
            z.writestr(n, blobs[n])
    os.replace(tmp, dst)
    print("wrote %s" % dst)
    return True


def main(argv=None):
    parser = argparse.ArgumentParser(
        description="Restructure a Fusion-exported 3MF into one multi-part object "
                    "so slicers stop scattering the parts across the bed.")
    parser.add_argument("input", help="path to the .3mf file")
    parser.add_argument("-o", "--output",
                        help="output path (default: rewrite input in place)")
    parser.add_argument("-n", "--name",
                        help="name for the grouped object "
                             "(default: input filename without extension)")
    parser.add_argument("--verify", action="store_true",
                        help="assert mesh data is unchanged before writing")
    parser.add_argument("--no-backup", action="store_true",
                        help="skip the .bak copy when rewriting in place")
    args = parser.parse_args(argv)

    src = args.input
    if not os.path.isfile(src):
        parser.error("no such file: %s" % src)

    dst = args.output or src
    name = args.name or os.path.splitext(os.path.basename(src))[0]

    _register_namespaces()

    backup = src + ".bak" if (dst == src and not args.no_backup) else None

    try:
        process(src, dst, name, args.verify, backup)
    except Exception as exc:
        print("ERROR: %s" % exc, file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
