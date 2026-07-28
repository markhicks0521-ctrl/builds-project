# H2D TPU (top) Spool Holder

**Source:** [MakerWorld — model 1637712](https://makerworld.com/en/models/1637712-h2d-tpu-top-spool-holder), free download

**Designer:** Rossero

**License:** Standard Digital File License (MakerWorld). Free for personal use/printing. Commercial use requires joining the designer's membership. Do not redistribute, re-host, or share the digital file itself elsewhere.

**Purpose:** Top-mounted, direct-feed spool holder for the H2C. Lets TPU filament bypass the AMS and feed straight into the extruder, reducing feed resistance that causes grinding/jamming with soft TPU filament.

## Files
- `H2D_TPU_top_spool_holder.3mf` — downloaded model/print file from MakerWorld
- `FilamentSpool_Adapter_SnpU1.stl` — filament spool adapter for the Snapmaker U1. Dimensions approximately 138.87 x 138.87 x 75mm.
- `FilamentSpool_Adapter_SnpU1.gcode` — sliced output for the U1 (0.4mm nozzle, 0.20mm standard process, Snapmaker PLA), generated via the OrcaSlicer CLI command below.

## Slicing via OrcaSlicer CLI

`orca-slicer.exe` (`C:\Program Files\OrcaSlicer\orca-slicer.exe`) has no `--help`/`-h` output, but its CLI flags are real and validated — `--load-settings`/`--load-filaments` require **full paths to the profile `.json` files**, not preset display names.

Profiles live under `C:\Users\markh\AppData\Roaming\OrcaSlicer\system\Snapmaker\{machine,process,filament}\`. Used for this file:
- Machine: `Snapmaker U1 (0.4 nozzle).json`
- Process: `0.20 Standard @Snapmaker U1 (0.4 nozzle).json`
- Filament: `Snapmaker PLA @U1.json`

Working command (run from the repo root):
```
orca-slicer.exe --load-settings "C:\Users\markh\AppData\Roaming\OrcaSlicer\system\Snapmaker\machine\Snapmaker U1 (0.4 nozzle).json;C:\Users\markh\AppData\Roaming\OrcaSlicer\system\Snapmaker\process\0.20 Standard @Snapmaker U1 (0.4 nozzle).json" --load-filaments "C:\Users\markh\AppData\Roaming\OrcaSlicer\system\Snapmaker\filament\Snapmaker PLA @U1.json" --slice 1 --outputdir "3dprints/spool-holder/" "3dprints/spool-holder/FilamentSpool_Adapter_SnpU1.stl"
```

**Gotcha:** `--load-settings` takes `machine_path;process_path` joined with a literal semicolon in one quoted argument. If invoking from PowerShell via `Start-Process -ArgumentList <array>`, passing the args as separate array elements mangles paths containing spaces/parens/semicolons (silently reorders/splits them). Build one fully-quoted command-line string instead and pass it as a single `-ArgumentList` value.

Output is written as `plate_1.gcode` by default (OrcaSlicer's generic plate name) — rename it after slicing to match the source file.
