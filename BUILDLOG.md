# Build Log — Hicks Build Lab

## Instructions for Claude Code

At the end of every session, update this file with: date, what was built or changed, files created or modified, any commits made, and any notes or issues. Append new sessions at the top under the Instructions section so the most recent is always first.

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
