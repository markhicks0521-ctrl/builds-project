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

**Status:** **Milestone (2026-08-29) — full CRUD working end to end through the GUI**, no REPL needed for day-to-day use. Started 2026-08-28. Hand-written Python learning project — Claude Code is not writing the application code. Full detail in [`apps/filament-manager/README.md`](apps/filament-manager/README.md).

`database.py`'s full CRUD set is complete and tested: `get_connection()`, `init_db()` (creates the `spools` table — id, brand, material, color, total_weight_g, remaining_weight_g), `add_spool()`, `get_all_spools()`, `update_remaining_weight(spool_id, new_weight)`, and `delete_spool(spool_id)` (the latter two use `WHERE` clauses to target one row).

`main.py`: Add Spool form (`TextField`s + `ElevatedButton` → `add_spool()`), and each row in the live spool list now has its own "New weight" field, Update button, and Delete button, wired to `update_remaining_weight()`/`delete_spool()` — all four CRUD ops now driven from the GUI. Update/Delete use Python closures (`make_delete_handler(sid)`, `make_update_handler(sid, field)`) created once per row in the refresh loop, so each button independently remembers its own spool's id. Verified with multi-row testing — updating/deleting one spool leaves all other rows untouched.

Two more bugs self-diagnosed and fixed by Mark via LSP errors: an Update field/button built but never added to the row's controls (same category as an earlier "widget never added to the page" bug, caught faster this time), and a stray paren inside a variable name (`new_weight_input` → `new)weight_input`) that cascaded into ~13 lines of syntax errors, correctly recognized as one small root cause. Mark says closures aren't fully clicking conceptually yet despite two correct implementations — expected, revisit/reinforce in future sessions rather than assuming it's settled.

**Next (not yet decided):** clean up Flet deprecation warnings (`ft.app()` → `ft.run()`, `ElevatedButton` → `Button`), add input validation for non-numeric weights, visual polish, or call this v1 complete and move phases.

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

