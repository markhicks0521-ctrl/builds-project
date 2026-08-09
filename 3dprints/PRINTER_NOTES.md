*Living document — updated each session*

> Single source of truth. Do not create versioned copies — update this file in place at the end of each session.

# Printer & Slicer Notes

Cross-project printer and slicer knowledge that isn't specific to any one model. Model-specific geometry, licensing, and print history stay in that model's own README.

Most findings below came from the Highland Cow soap holder — see [`3dprints/highland-cow/README.md`](highland-cow/README.md) for that model's print history and the saved U1 project file.

---

## Bambu H2C — PETG interface supports (PLA body + PETG contact layer)

**Why:** PLA-on-PLA supports need an air gap (~0.2mm) to release, and that gap is what causes droop and stringing on the down-facing surface. PETG doesn't bond to PLA, so a PETG **interface** (contact) layer can sit at a **zero gap** — the support surface is a solid sheet directly against the part, and it still peels off clean. Only the interface needs to be PETG; the support trunk stays PLA, so material and time cost stay bounded.

**When:** visible / front-facing down surfaces where droop would show. Skip it if you're behind schedule on a batch run — see the time cost below.

### Bambu Studio settings

| Setting | Value | Notes |
|---|---|---|
| Support/Raft Base | explicit PLA color — **not** "Default" | "Default" lets the slicer pick; must be pinned to the PLA toolhead |
| Avoid interface filament for base | **enabled** | without it PETG bleeds into the trunk layers |
| Support/Raft Interface | PETG | |
| Top Z distance | **0mm** | |
| Bottom Z distance | **0mm** | both matter — a 0.24mm bottom Z distance caused a mid-print PETG interface failure and visible droop on a Highland cow model's hair tufts |
| Top Interface Layers | **2–3** (not 4) | 4 layers built a thick block that sheared off mid-print |
| Interface pattern | Rectilinear | |
| Top Interface Spacing | **0mm** | solid contact sheet |
| Support Interface Expansion | **1.0–1.5mm** | caps/wraps the PETG over the PLA tip edges so the nozzle can't knock it loose sideways |
| Z-hop on tool change | enabled | |

**Vortek / flush volume:** the H2C uses dedicated nozzles per toolhead, so there's no shared-nozzle cross-contamination and flush volume between toolheads can be minimal or 0. **Keep the prime tower enabled anyway** — the idle PETG nozzle needs to stay primed and pressurized before it lays the interface layer.

**Time cost:** PETG interface supports added roughly **6+ hours to an 18.5hr print** — per-layer toolhead swaps plus reduced interface print speeds. Worth it for visible/front-facing surfaces; not worth it on a batch run that's behind schedule.

### Known failure mode

PETG interface layers can **shear off mid-print on tall, thin tree support tips** — the nozzle drags across the zero-gap cold PETG cap and knocks it free. Mitigations: Support Interface Expansion 1.0–1.5mm (wraps the cap over the tip edge) and fewer interface layers (2–3, not 4).

---

## Snapmaker U1 (Snapmaker Orca) — PLA-on-PLA support settings

Skipping the PETG interface makes sense when you're behind on batch production and the down-facing surfaces aren't the money shot. Settings below were used successfully on the Highland Cow soap holder.

| Setting | Value |
|---|---|
| Enable support | ON |
| Style | Tree Organic |
| Interface pattern | Rectilinear |
| Normal support expansion | 0.8–1.0mm |
| Top Z distance | 0.2mm |
| Bottom Z distance | 0.2mm |
| Top interface layers | 2 |
| Top interface spacing | **0.5mm** |

Top interface spacing is **not** 0mm here — 0mm is only for dissimilar-material zero-gap interfaces (see the H2C PETG section). Same-material PLA needs the gap or the interface fuses to the part.

**Multimaterial tab:** uncheck **"Flush into objects' support"** on multi-color prints, or dark filament bleeds into light support structures.

### First-layer quality — Bambu-brand PLA through Snapmaker Orca

Non-Bambu slicer + non-Bambu hardware means the Bambu-tuned defaults (especially flow ratio) are wrong. Re-tune rather than trusting stock.

| Setting | Value |
|---|---|
| First layer line width | 0.5mm |
| First layer height | 0.2–0.24mm |
| First layer speed | 30–50mm/s |
| Cooling fan, first 1–2 layers | off |
| Flow Ratio | **0.95–0.96** (down from stock ~0.98–1.0) |
| Outer wall line width | 0.45mm |
| Outer wall speed | 100–120mm/s |

Flow ratio was the fix for over-extrusion "plowing" — raised rough ridges in the first layer. The outer wall changes are for hiding layer lines on curved surfaces.

**Physical checks:** clean the bed with IPA or Dawn dish soap; re-run auto bed leveling *after* heat-soaking the bed at 60–65°C for 3–5 min.

### Saving a dialed-in setup

**File → Save Project As (.3mf)** captures model position, all process settings, filament settings (including the custom flow ratio), and toolhead/color assignments in one file. Reopening it restores the exact working configuration. This is the way to preserve a tuned setup per model.

---

## Infill pattern notes (Bambu H2C)

**Grid — avoid on tall/fast prints.** Grid's lines self-intersect on the same layer, creating hard collision points the nozzle repeatedly drags across; combined with thermal stress at the crossover points weakening first-layer grip, this sheared parts loose from the build plate on tall prints at high speed.

**Gyroid** avoids same-layer self-intersection, but is **slower** than Grid at equal or less material — it's continuously curving, so the toolhead is in constant accel/decel and never reaches top speed the way Grid's straight-line moves do.

**Adaptive Cubic — best for decorative (non-structural) prints.** Concentrates density near top shells and where it's actually needed, sparse elsewhere; paths don't intersect (no collision risk); fastest in practice. On the Highland Cow soap holder:

| Change | Time |
|---|---|
| Grid (baseline) | 17h01m |
| → Adaptive Cubic 15% | −45min |
| → Adaptive Cubic 10% | −40min more (15h32m total) |

No build-plate adhesion issues at either density.

**Recommendation:** default to **Adaptive Cubic at 10%** for decorative/non-structural prints on the H2C. Reserve Grid for parts that need maximum stiffness, and keep those prints shorter/slower to avoid plate knock-off.
