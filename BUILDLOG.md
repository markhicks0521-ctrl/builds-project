# Build Log — Hicks Build Lab

*Living document — updated each session*

> Single source of truth. Do not create versioned copies — update this file in place at the end of each session.

## Instructions for Claude Code

At the end of every session, edit this file in place — add, remove, or reword lines as needed to keep it accurate and current. Do not append new dated sections. Do not create versioned copies. This is a single living document.

---

## Ammo Box — 9mm 50rd

**Status:** Fresh start — all previous scad/stl/Fusion360 files deleted. Starting from a fit-verification test piece before building the full tray.

**Files:**
- `3dprints/ammo-boxes/9mm_test_piece.scad` — 2x2 hole test piece, print and verify round fit before building full tray

**Test piece geometry:**
- 2×2 grid, 4 holes total. Outer dims: 26×26×22mm (cols×spacing + 2×wall).
- hole_d=9.5mm, wall=3mm, floor_t=2mm, depth=22mm, spacing=11.5mm center-to-center.
- Holes run full depth from floor_t to top — no bridging. Rounds sit tip-down; rim (9.96mm) catches on top edge of hole.
- Parametric: all key dims are variables at top of file for easy tuning after print.

**Print status:**
- Sliced and sent to Bambu H2C. Printing now.
- hole_d=9.5mm is based on standard 9mm spec (case body 9.65mm, rim 9.96mm) — not yet verified with calipers.

**What's next:**
- Measure actual round with calipers. Check rim seating on printed piece.
- Adjust hole_d if needed and reprint until fit is confirmed.
- Once hole fit is verified, build full 5×10 tray with solid floor, then design sliding lid.

---

## 2026-05-24 — Initial Setup

**Built:** Project folder structure (`3dprints/`, `websites/`, `apps/`, `scripts/`), `README.md`

**Files created:** `README.md`, `3dprints/.gitkeep`, `websites/.gitkeep`, `apps/.gitkeep`, `scripts/.gitkeep`

**Committed:** `Initial setup — Hicks Build Lab`

**Notes:** `.claude` folder was initially placed at Nextcloud root level, moved to `builds-project` root where it belongs. GitHub remote added manually via PowerShell (gh CLI not installed on this machine). Pushed to https://github.com/markhicks0521-ctrl/builds-project
