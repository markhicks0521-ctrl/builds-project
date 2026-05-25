# Build Log — Hicks Build Lab

## Instructions for Claude Code

At the end of every session, update this file with: date, what was built or changed, files created or modified, any commits made, and any notes or issues. Append new sessions at the top under the Instructions section so the most recent is always first.

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
