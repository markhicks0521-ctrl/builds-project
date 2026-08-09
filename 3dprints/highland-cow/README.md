*Living document — updated each session*

> Single source of truth. Do not create versioned copies — update this file in place at the end of each session.

# Highland Cow Soap Holder

**Purpose:** Decorative Bath & Body Works soap holder — Highland cow with front-facing shaggy hair tufts.

**Printers used:** Bambu H2C (multi-color, PETG interface support attempt) and Snapmaker U1 (final production run — PLA-on-PLA, no PETG interface).

## Files

- `U1_Highland_Cow_Fast_PLA.3mf` — dialed-in Snapmaker Orca project file for the U1. Saved via File → Save Project As, so it captures model position, process settings (Adaptive Cubic 10% infill, tuned support settings, flow ratio 0.95–0.96, outer wall tuning), filament settings, and toolhead/color assignments. Reopening this file restores the exact working configuration — no re-tuning needed for future batches.

## Print history

- **H2C attempt** — PETG interface supports used to get clean, droop-free bottom surfaces on the front-facing hair tufts (PLA body, PETG contact layer only). Failed mid-print: a Bottom Z distance of 0.24mm (not 0mm) let a PETG interface cap shear off a support tip, causing a visible droop/hollow spot in the hair, front and center. Print was let finish rather than restarted, since the model was needed for production; the drooped hair tuft was accepted as a cosmetic flaw or is a candidate for post-process fill/sand or heat-gun reshaping. See [`3dprints/PRINTER_NOTES.md`](../PRINTER_NOTES.md) for the corrected H2C PETG interface settings (Bottom Z distance = 0mm, Support Interface Expansion 1.0–1.5mm, 2–3 interface layers not 4) — not yet re-tested on this model.
- **U1 run (successful)** — switched to pure PLA-on-PLA supports on the Snapmaker U1 to keep batch production moving. Printed flawlessly. Settings tuned through iteration: infill changed from Grid (17h01m, caused build-plate adhesion failures on tall sections) → Adaptive Cubic 15% (16h14m) → Adaptive Cubic 10% (15h32m, final choice, no adhesion issues). First-layer roughness ("plowing"/over-extrusion) from running Bambu-brand PLA through Snapmaker Orca's non-Bambu-tuned defaults was fixed by dropping flow ratio to 0.95–0.96 and widening/slowing the outer wall. Full settings tables in [`3dprints/PRINTER_NOTES.md`](../PRINTER_NOTES.md).

## Open item

If the H2C PETG-interface approach is retried on this model (for a version with clean unpainted bottom surfaces on the hair), use the corrected settings in PRINTER_NOTES.md and watch the same front-facing tufts that failed last time.
