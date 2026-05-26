# Build Log — Hicks Build Lab

## Instructions for Claude Code

At the end of every session, update this file with: date, what was built or changed, files created or modified, any commits made, and any notes or issues. Append new sessions at the top under the Instructions section so the most recent is always first.

---

## 2026-05-25 — Ammo Box — Clean rewrite: verified geometry, flush sliding lid

**Files:** `3dprints/ammo-boxes/9mm_50rd_box.scad`

**Commits this session:**
- `Clean rewrite — verified geometry, flush sliding lid`

**What changed:**
- Full clean rewrite. Consolidated parameters: `hole_depth=20`, `tray_h=22`, `rail_h=4`, `lip=2`, `lid_t=3`, `cl=0.4` (clearance).
- Tray: main body 61.5×119×22mm, 50 holes from z=floor_t (2mm) to z=22mm. Four U-rails (2mm tall, 4mm high) around all sides at z=22. Four inward lips (2mm wide × 3mm tall) at top of rails, all four sides. Detent divot on open end inside face.
- Lid: flat plate 61.5×119×3mm with four-edge notches (wall+lip+cl = 4.4mm) leaving a tongue that fits inside the rails. Detent bump on open end face.
- Lid slides in from the open short end (y=119 side).
- Parameters cleaned up — removed ch_depth, ch_h, shelf_t, round_depth aliases.

**Design state:**
- Ready to export tray STL and test print lid fit
- Clearance cl=0.4mm — may need tuning after first print

---

## 2026-05-25 — Ammo Box — Fix: solid floor, raised walls for lid recess

**Files:** `3dprints/ammo-boxes/9mm_50rd_box.scad`

**Commits this session:**
- `Fix tray — solid floor, raised walls for lid recess`

**What changed:**
- Holes now start at `z = floor_t = 2mm` (were starting at z=0, punching through the floor). Height = `round_depth + 0.02 = 20mm`. Solid 2mm floor is intact.
- Added `lid_t = 3` parameter. `tray_h` updated to `floor_t + round_depth + shelf_t + lid_t + 0.3 = 27.3mm`. Top 5.3mm of walls (shelf_t + lid_t + 0.3) form the raised lip the lid slots into. Lid channel stays at the very top of those walls.
- Hole zone: z=2 to z=22 (20mm). Raised lip zone: z=22 to z=27.3 (5.3mm). Lid channel: z=24.3 to z=27.3 (3mm, inside face of long walls).

---

## 2026-05-25 — Ammo Box — Tray Redesign: solid body, full-height holes, lid channel

**Files:** `3dprints/ammo-boxes/9mm_50rd_box.scad`

**Commits this session:**
- `Tray redesign — solid with full height holes, lid channel added`

**What changed:**
- Tray is now a fully solid block — hollow interior cutout removed entirely. Eliminates all bridging; prints reliably.
- 50 holes now run the full tray height (24mm), top to bottom. No shelf layer, no hollow pocket.
- Lid channel added: 3mm tall × 1.5mm deep, cut into the inside face of both long walls (X-axis walls), at z = tray_h−3 to z = tray_h. Channel runs full tray_l length. This is where the lid tongue will slide in from the long side.
- Side-by-side preview render re-enabled (tray + lid).
- All parameters unchanged: hole_d=9.5, wall=2, floor_t=2, shelf_t=2, round_depth=20, tray dims 61.5×119×24mm.

**Design decisions:**
- Full-height holes: since there is no hollow cavity, the vertical walls between holes provide all structural strength. No bridging at any layer.
- Channel depth 1.5mm into 2mm wall: 0.5mm remaining outer skin — intentional, this is the lid-retention groove; wall integrity comes from the solid body, not the wall skin above the channel.

**Next session:**
- Check test print (if sent), verify round fit
- Design lid tongue to match channel (3mm tall × 1.5mm wide projection on lid edges)
- Add detent and hard stop to lid tongue/channel system
- Consider debossed lid graphics

---

## 2026-05-24 — Ammo Box — 9mm 50rd Tray Design and Test Print

**Files:** `3dprints/ammo-boxes/9mm_50rd_box.scad`, `3dprints/ammo-boxes/9mm_50rd_tray.stl` (exported for print)

**Commits this session:**
- `Add 9mm 50rd parametric ammo box — initial design`
- `Fix ammo tray — solid floor, rim-hang holes, lid detent and hard stop`
- `Step 1 — clean base geometry for test print`
- `Fix tray hollow — preserve shelf for rim-hang holes`
- `Session log — 9mm ammo box day 1, tray test print sent`

**What was built:**
- `9mm_50rd_box.scad` — fully parametric ammo tray with 5×10 grid (50 rounds), 9.5mm rim-hang holes, solid floor, 2mm shelf. Rounds sit tip-down hanging by the case rim.
- Multiple design iterations: fixed hollow interior bug that was hiding the hole grid, settled on clean 38-line base geometry.
- `9mm_50rd_tray.stl` exported for test print on Bambu P2S in PLA.

**Design decisions:**
- `hole_d = 9.5mm` — sits between case body (~9.65mm) and rim (9.96mm) so rim catches on shelf edge
- `shelf_t = 2mm`, `floor_t = 2mm`, `wall = 2mm`, `round_depth = 20mm`
- Tray dimensions: 57.5 × 115 × 24mm
- Sliding lid system designed but not yet built — Step 2 after test print confirms fit
- Lid plan: flush sliding like a .22 LR factory box, channel cut into inside top of tray walls, slides in from long side, detent + hard stop closure

**Next session:**
- Check test print, verify 9mm round fit in holes
- Adjust `hole_d` if needed
- Build sliding lid with channel, tongue, detent and hard stop
- Add debossed lid graphics (bullet silhouette, 9MM, 50 RDS)

---

## 2026-05-24 — Ammo Box Step 1: clean base geometry for test print

**Modified:** `3dprints/ammo-boxes/9mm_50rd_box.scad`

**Committed:** `Step 1 — clean base geometry for test print`

**Notes:** Full rewrite, stripped to bare minimum. Tray: solid box, hollowed interior above floor, 50 rim-hang holes through shelf only. Lid: flat 3mm plate, no features. Previous over-engineered version (detents, hard stop, rail grooves, deboss) scrapped in favour of test-print-first approach.

---

## 2026-05-24 — Ammo Box Redesign: solid floor, rim-hang, lid retention

**Modified:** `3dprints/ammo-boxes/9mm_50rd_box.scad`

**Committed:** `Fix ammo tray — solid floor, rim-hang holes, lid detent and hard stop`

**Changes:**
- `hole_d` fixed at 9.5 mm (was derived). Case rim 9.96 mm > hole so round drops tip-down and hangs by rim on shelf edge.
- Floor is now fully solid. Added `shelf_t = 2` parameter; holes punch through shelf only (top 2 mm of tray body).
- `tray_h` updated to `floor_t + round_depth + shelf_t = 24 mm`.
- Lid hard stop: 2 mm tall × 2 mm deep tab across full cavity width at inside of closed end — prevents lid sliding completely off.
- Lid detent: 1.5 mm radius hemisphere bumps on inner long-side walls near closed end (`detent_from_end = 5 mm`). Matching 1.6 mm radius / 0.5 mm deep divots on outer faces of tray lip long walls at same position.
- Tray outer dims now approx 61.5 × 119 × 24 mm + 4 mm lip (smaller footprint due to reduced hole_d).

---

## 2026-05-24 — 9mm Ammo Box (OpenSCAD)

**Built:** Fully parametric 9mm 50-round ammo box with sliding tray-style lid

**Files created:** `3dprints/ammo-boxes/9mm_50rd_box.scad`

**Committed:** `Add 9mm 50rd parametric ammo box — initial design`

**Notes:** Two modules — `ammo_tray()` (5×10 grid, push-out floor holes, raised lip collar) and `ammo_lid()` (sliding fit over lip, ceiling rail grooves, debossed bullet silhouette + "9MM" / "50 RDS" labels on top face). Preview renders both side by side. Tray outer dims approx 66×128×22mm + 4mm lip. All parameters at top of file for easy tuning.

---

## 2026-05-24 — Initial Setup

**Built:** Project folder structure (`3dprints/`, `websites/`, `apps/`, `scripts/`), `README.md`

**Files created:** `README.md`, `3dprints/.gitkeep`, `websites/.gitkeep`, `apps/.gitkeep`, `scripts/.gitkeep`

**Committed:** `Initial setup — Hicks Build Lab`

**Notes:** `.claude` folder was initially placed at Nextcloud root level, moved to `builds-project` root where it belongs. GitHub remote added manually via PowerShell (gh CLI not installed on this machine). Pushed to https://github.com/markhicks0521-ctrl/builds-project
