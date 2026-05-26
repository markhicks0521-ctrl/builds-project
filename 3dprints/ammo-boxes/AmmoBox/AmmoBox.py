import adsk.core, adsk.fusion, traceback

def run(context):
    ui = None
    try:
        app = adsk.core.Application.get()
        ui = app.userInterface
        design = app.activeProduct
        rootComp = design.rootComponent
        sketches = rootComp.sketches
        extrudes = rootComp.features.extrudeFeatures
        combines = rootComp.features.combineFeatures

        # All dimensions in cm (Fusion uses cm internally)
        # Box: 6.35 x 12.1 x 2.4 cm
        # Wall: 0.3cm, Floor: 0.2cm
        # Holes: 0.95cm diameter, 5 cols x 10 rows
        # Cell: 1.15cm
        # Lid: 6.35 x 12.1 x 0.3cm, fits inside walls

        box_w = 6.35
        box_l = 12.1
        box_h = 2.4
        wall = 0.3
        floor_h = 0.2
        hole_d = 0.95
        cell = 1.15
        lid_t = 0.3
        lip = 0.2

        occs = rootComp.occurrences
        trayOcc = occs.addNewComponent(adsk.core.Matrix3D.create())
        trayComp = trayOcc.component
        trayComp.name = "AmmoTray"

        # Create tray outer box
        sk = trayComp.sketches.add(trayComp.xYConstructionPlane)
        rect = sk.sketchCurves.sketchLines.addTwoPointRectangle(
            adsk.core.Point3D.create(0, 0, 0),
            adsk.core.Point3D.create(box_w, box_l, 0))
        prof = sk.profiles.item(0)
        ext_input = trayComp.features.extrudeFeatures.createInput(prof, adsk.fusion.FeatureOperations.NewBodyFeatureOperation)
        ext_input.setDistanceExtent(False, adsk.core.ValueInput.createByReal(box_h))
        trayBody = trayComp.features.extrudeFeatures.add(ext_input).bodies.item(0)
        trayBody.name = "TrayOuter"

        # Cut holes - 5 cols x 10 rows
        sk2 = trayComp.sketches.add(trayComp.xYConstructionPlane)
        for c in range(5):
            for r in range(10):
                cx = wall + c*cell + cell/2
                cy = wall + r*cell + cell/2
                sk2.sketchCurves.sketchCircles.addByCenterRadius(
                    adsk.core.Point3D.create(cx, cy, 0),
                    hole_d/2)

        for i in range(50):
            prof = sk2.profiles.item(i)
            ext_input = trayComp.features.extrudeFeatures.createInput(prof, adsk.fusion.FeatureOperations.CutFeatureOperation)
            ext_input.setDistanceExtent(False, adsk.core.ValueInput.createByReal(box_h - floor_h))
            ext_input.startExtent = adsk.fusion.OffsetStartDefinition.create(adsk.core.ValueInput.createByReal(floor_h))
            trayComp.features.extrudeFeatures.add(ext_input)

        # Cut lip grooves on long walls for lid
        sk3 = trayComp.sketches.add(trayComp.xYConstructionPlane)
        # Left groove
        sk3.sketchCurves.sketchLines.addTwoPointRectangle(
            adsk.core.Point3D.create(0, 0, 0),
            adsk.core.Point3D.create(wall, box_l, 0))
        # Right groove
        sk3.sketchCurves.sketchLines.addTwoPointRectangle(
            adsk.core.Point3D.create(box_w - wall, 0, 0),
            adsk.core.Point3D.create(box_w, box_l, 0))
        # Back groove
        sk3.sketchCurves.sketchLines.addTwoPointRectangle(
            adsk.core.Point3D.create(0, 0, 0),
            adsk.core.Point3D.create(box_w, wall, 0))

        for i in range(3):
            prof = sk3.profiles.item(i)
            ext_input = trayComp.features.extrudeFeatures.createInput(prof, adsk.fusion.FeatureOperations.CutFeatureOperation)
            ext_input.setDistanceExtent(False, adsk.core.ValueInput.createByReal(lid_t + 0.05))
            ext_input.startExtent = adsk.fusion.OffsetStartDefinition.create(adsk.core.ValueInput.createByReal(box_h - lid_t - 0.05))
            trayComp.features.extrudeFeatures.add(ext_input)

        ui.messageBox("AmmoBox tray created successfully!")

    except:
        if ui:
            ui.messageBox("Failed:\n{}".format(traceback.format_exc()))
