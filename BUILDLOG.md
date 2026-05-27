# Build Log — Hicks Build Lab

*Living document — updated each session*

> Single source of truth. Do not create versioned copies — update this file in place at the end of each session.

## Instructions for Claude Code

At the end of every session, edit this file in place — add, remove, or reword lines as needed to keep it accurate and current. Do not append new dated sections. Do not create versioned copies. This is a single living document.

---

## Ammo Box — 9mm 50rd

**Files:**
- `3dprints/ammo-boxes/9mm_50rd_box.scad` — main OpenSCAD file
- `3dprints/ammo-boxes/AmmoBox/AmmoBox.py` — Fusion 360 Python script (partial tray only, lid not complete)
- `3dprints/ammo-boxes/9mm_50rd_tray.stl` — exported STL (may not reflect latest scad state)

**Current tray geometry:**
- Outer dims: 63.5×121×28mm. 3mm walls, 2mm floor.
- Solid construction — hole block (57.5×115×20mm) sits on floor between walls; 50 holes subtracted through it. No bridging.
- 50 holes: 9.5mm dia, 5×10 grid, rounds sit tip-down hanging by case rim (rim=9.96mm > hole_d=9.5mm, rim catches on block surface).
- Three full-height walls (28mm): left, right, back. Open end at y=121 has no wall — lid entry point.
- Three inward lips at top of walls (left, right, back).
- Detent divot on inside of back wall at z=12 (mid-height of hole block).

**Current lid approach:**
- Simple flat plate (57.5×115×3mm). Pull tab on open end (y=121 side). Detent bump on closed end face.
- Lid drops in from above and slides toward back wall. Contained on three sides by tray walls.
- Lid sits on top of hole block at z=22.

**What's working:**
- Tray body prints cleanly — solid block construction eliminates all bridging.
- Hole grid correct — all 50 rounds seat properly by rim.
- Three-wall containment is the simplest viable lid retention model.
- Test print of tray body sent to Bambu P2S (earlier iteration with bridging failed; current solid-block approach resolves that).

**What's next:**
- Lid retention needs refinement — current flat plate doesn't lock reliably. Detent position and geometry need tuning.
- Once lid is functionally complete: add debossed graphics to lid top (bullet silhouette, 9MM, 50 RDS).
- Export final tray and lid STLs for print.

---

## 2026-05-24 — Initial Setup

**Built:** Project folder structure (`3dprints/`, `websites/`, `apps/`, `scripts/`), `README.md`

**Files created:** `README.md`, `3dprints/.gitkeep`, `websites/.gitkeep`, `apps/.gitkeep`, `scripts/.gitkeep`

**Committed:** `Initial setup — Hicks Build Lab`

**Notes:** `.claude` folder was initially placed at Nextcloud root level, moved to `builds-project` root where it belongs. GitHub remote added manually via PowerShell (gh CLI not installed on this machine). Pushed to https://github.com/markhicks0521-ctrl/builds-project
