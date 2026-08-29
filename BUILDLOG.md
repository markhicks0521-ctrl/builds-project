# Build Log — Hicks Build Lab

*Living document — updated each session*

> Single source of truth. Do not create versioned copies — update this file in place at the end of each session.

## Instructions for Claude Code

At the end of every session, edit this file in place — add, remove, or reword lines as needed to keep it accurate and current. Do not append new dated sections. Do not create versioned copies. This is a single living document.

---

## Reference docs

- [`3dprints/PRINTER_NOTES.md`](3dprints/PRINTER_NOTES.md) — cross-project printer/slicer knowledge: H2C PETG interface supports, U1 PLA support + first-layer tuning, infill pattern choices.

---

## HicksCreations iOS App

**Status:** iOS development on hold until Xcode Mac user is set up.

**Migration:** App migrated from Mac via thumb drive, added to `apps/HicksCreations/`. Old `.git` and `xcuserdata` folders excluded. `DEVLOG.md` and `CLAUDE.md` reformatted to living document format.

**What it is:** Swift/Shopify storefront client with teal and leopard theme. Integrated with Shopify Storefront GraphQL API.

**Known issues carried over:**
- Tab bar blurry
- Shop screen missing product images
- Product detail layout broken
- Cart cards unreadable
- Candy mix options incomplete (Chamoy & Tajin handle unknown)

---

## Filament Manager

**Status:** Early development. Started 2026-08-28. Hand-written Python learning project — Claude Code is not writing the application code. Full detail in [`apps/filament-manager/README.md`](apps/filament-manager/README.md).

`database.py` built and tested: `get_connection()`, `init_db()` (creates the `spools` table — id, brand, material, color, total_weight_g, remaining_weight_g), and `add_spool()` (parameterized `?` inserts). Verified end to end — `init_db()` created `filament.db`, then `add_spool("Bambu", "PLA", "Black", 1000, 1000)` from the REPL, row read back as `[(1, 'Bambu', 'PLA', 'Black', 1000.0, 1000.0)]`.

**Next:** add `get_all_spools()`, `update_spool()`, `delete_spool()` to `database.py`; build the Flet GUI in `main.py`; then commit and push to GitHub.

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
- 2x2 test piece sent to Bambu H2C. Awaiting caliper measurements to verify fit.
- hole_d=9.5mm is based on standard 9mm spec (case body 9.65mm, rim 9.96mm) — not yet verified with calipers.

**What's next:**
- Measure actual round with calipers tomorrow. Check rim seating on printed piece.
- Adjust hole_d if needed and reprint until fit is confirmed.
- Once hole fit is verified, build full 5×10 tray with solid floor, then design sliding lid.

