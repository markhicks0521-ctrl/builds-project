*Living document — updated each session*

> Single source of truth. Do not create versioned copies — update this file in place at the end of each session.

# 12oz Can Koozie

**Designed in:** Autodesk Fusion 360, via the Fusion MCP connector

**Fusion file:** "HC - 12oz - Can Koozie" (Fusion cloud storage — repo holds exported STL/3MF only)

## Current geometry

Dialed in against a physical reference koozie measurement.

- Outer diameter: 76.3mm
- Inner diameter: 66.4mm — verified via printed test rings, iterated 66.2 → 66.25 → 66.35 → **66.4mm** for correct snug fit
- Height: 109.7mm
- Wall thickness: ~4.95mm
- Finger-access hole: 25mm diameter, fully rounded (no flat edge)
- Top rim: fully rounded roundover sweeping directly from outer wall to inner wall — no flat top surface remaining (radius = full wall thickness, 4.95mm)
- Bottom edge: softer roundover, half the top's radius (2.475mm)
- Material target: rigid PLA, solid wall (not flexible/TPU)

## Decorative elements

Built for multi-color printing, **not** painted.

**Text — "Hicks Creations"**, engraved, 1.4cm font, Englebert (Google Font, installed as a system font so Fusion can reference it). Wraps the front across two separate height rows:

| Row | Height |
|---|---|
| "Hicks" | z 63 – 77.4mm |
| "Creations" | z 37.5 – 52.3mm |

Both rows span roughly **316° – 55°** around the front (vertex-measured; the working figure of ~312–49° used earlier in design is slightly narrow — use the measured span when checking clearance for new decorations).

**21 lip / kiss-mark decorations** scattered across 4 height bands at varied angles:

| Band | Height | Tilt | Count | Angles |
|---|---|---|---|---|
| Low | ~10mm | level | 5 | 0, 72, 144, 216, 288 |
| BandA | ~27mm | +20° | 5 | 36, 108, 180, 252, 324 |
| Mid | ~54mm | −20° | 3 | 96, 176, 256 |
| Mid | ~60mm | level | 3 | 136, 216, 296 |
| Top | ~85mm | −20° | 5 | 30, 102, 174, 246, 318 |

Placement rules: minimum 70°+ gap within each band, and no angle shared between vertically adjacent bands — this is what prevents lips stacking into vertical columns, which was the main visual defect through several iterations.

**Lip source:** `kiss-mark-svgrepo-com` SVG (CC0 license, confirmed via SVG Repo), imported through Fusion's `SVGImportOptions`. **Not** hand-coded splines — early attempts at hand-plotted lip shapes produced unrecognizable blobs and were abandoned (see technique notes).

## Multi-body color separation (no painting required)

| Body group | Pieces | Filament |
|---|---|---|
| `KoozieBody` | 1 | black |
| `TextBody_*` | 16 | pink |
| `LipBody_*` | 42 | red |

**Total: 59 bodies.**

**Technique:** duplicate the body BEFORE cutting decorations (`copyToComponent`), cut the decorations into the working body, then boolean-subtract (`Combine`, `CutFeatureOperation`, `isKeepToolBodies=True`) the duplicate minus the final cut body. The result is the decoration material as independent solid bodies that exactly fill the recesses.

Note: the Combine consumes the original `KoozieBody` and emits the koozie as the *remainder* body despite `isKeepToolBodies=True`. Geometrically identical — just rename it back afterward.

---

# Key technique notes for future sessions

## Fusion MCP connector reliability findings

- Fresh SVG import + Emboss wrap directly onto **axis-rotated planes** (non-front angles) is **UNRELIABLE** — frequently produces silently broken geometry (top/bottom profile halves drift apart) even when Fusion's `healthState` API reports the feature as healthy. **`healthState` alone is NOT sufficient verification.**
- **RELIABLE method:** fresh SVG import + emboss works consistently on the **front plane only** (offset from `root.yZConstructionPlane`). Once verified clean there, propagate via `CircularPatternFeatures` (around `root.zConstructionAxis`) for angle variation and `RectangularPatternFeatures` (along `root.zConstructionAxis`) for height variation — both are 100% reliable, since they rigidly transform already-computed geometry rather than re-deriving via wrap.
- **BEST method, discovered late in this project:** skip fresh SVG imports entirely. Copy proven-good seed sketch curves (`Sketch.copy` into a new sketch on the same front plane, then `Sketch.move`) and translate along the sketch's **local Y axis** to place at ANY arbitrary angle around the cylinder, while keeping the reliable front-plane-style construction. Confirmed arc-length-exact using `d = radians(target_angle) × cylinder_radius` — asked for 36°, got 35.99°; asked for 136°, got 135.99°. More reliable AND more flexible than circular patterning for irregular/non-uniform placement. In-plane rotation of the same copied curves gives tilt.
- Emboss with **multiple profiles in one call** throws "not coplanar" errors unpredictably, even for genuinely coplanar profiles. Work around by embossing one profile at a time in a loop, re-fetching face references fresh each iteration. Always use the loop index, never a hardcoded `item(0)`.
- **Real verification requires MORE than `healthState`:** also verify actual geometry — face count, pocket area/volume consistency across supposedly-identical instances, and measured principal-axis angle for tilt. A broken lip can report `healthState=0` while being visually garbled. The pocket-floor area check is the most sensitive single test: every good lip half lands on one of a small set of exact values, so a broken one shows up instantly as an outlier.
- **Pattern-of-a-pattern:** circular-patterning a rectangular-pattern's output works. The reverse (rectangular-patterning a circular-pattern instance) has failed with `PATTERN_FEATURES_NO_PASTE_INT_EDGES` — though it has also succeeded on retry, so treat it as unreliable rather than impossible.

## 3MF export for multi-color printing

- `design.exportManager.createC3MFExportOptions(root, filepath)` exports multi-body designs as **N independent build items** (one per body) with no positioning transform between them.
- This causes slicers (confirmed with Bambu Studio) to treat each body as a separate standalone object and auto-drop each one to bed level (Z=0) individually. Any body not originally at Z=0 gets visually scattered/flattened onto the print bed — **even though the underlying mesh geometry is completely correct and unmodified.** Symptom looks like duplicated junk geometry in the export; it isn't. Verify by unzipping the 3mf and checking part positions before assuming the model is broken.
- **FIX:** post-process the exported 3mf (it's a zip archive containing `3D/3dmodel.model` XML) to restructure from N independent objects/build-items into **ONE object with N `<components>`**, referenced by a single build item. This is valid standard 3MF multi-part representation and prevents the auto-drop-to-bed scattering. Geometry is untouched — mesh data stays byte-identical.
- The script for this currently exists only in a Claude Code session scratchpad, which is **ephemeral**. It should be committed into this repo as a reusable tool before the next multi-color export, or it will have to be rewritten from scratch.

## Print history

- **2026-08-09** — First multi-color prototype (black/pink/red) sent to printer. Purpose: verify color mapping, overall look, and whether the 66.4mm inner diameter / 109.7mm height / all decorative elements come together correctly in a real print. Result: TBD.
