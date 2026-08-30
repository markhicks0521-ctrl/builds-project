*Living document — updated each session*

> Single source of truth. Do not create versioned copies — update this file in place at the end of each session.

# Filament Manager

**Status:** **Milestone — full CRUD working end to end through the GUI.** No REPL needed for day-to-day use anymore.

**Learning project:** Mark is writing all the Python code himself, working through it line by line to understand it. Claude Code is not generating application code.

## Stack

- SQLite for storage (`filament.db`)
- Flet for the GUI (`main.py`), running in a project-local virtual environment (`venv/`)

## `database.py`

| Function | Purpose |
|---|---|
| `get_connection()` | Opens the SQLite connection |
| `init_db()` | Creates the `spools` table |
| `add_spool()` | Inserts a new spool row — parameterized query with `?` placeholders to avoid SQL injection |
| `get_all_spools()` | Reads all spool rows, ordered by `brand`, then `material` |
| `update_remaining_weight(spool_id, new_weight)` | Updates one spool's remaining weight — `WHERE` clause targets a single row |
| `delete_spool(spool_id)` | Deletes one spool row — `WHERE` clause targets a single row |

**`spools` table:** `id`, `brand`, `material`, `variant`, `color`, `spool_type`, `total_weight_g`, `remaining_weight_g`

**Schema update:** added `variant` (TEXT, optional — e.g. "Basic", "Silk", "Glow", "Tri Color") and `spool_type` (TEXT, NOT NULL — "Spooled" or "Refill"), inserted in the middle of the column order as shown above. `add_spool()` updated to accept and insert both fields in the same order. Since only test data existed, `filament.db` was deleted and recreated fresh rather than migrated — **note for later:** once real data exists, schema changes must use `ALTER TABLE` instead, to avoid data loss.

**Sorting:** `get_all_spools()` now uses `ORDER BY brand, material` instead of an unordered `SELECT`, so the GUI list is always alphabetical by brand then material regardless of insert order. Verified with out-of-order test inserts (Sunlu added before Bambu, Bambu correctly displayed first).

**Tested:** full CRUD cycle run by hand in the Python REPL with real data — add a spool, read it back, update its weight, read it back again, delete it, confirm the table is empty. Mark caught and fixed two of his own typos during this process (a misspelled parameter name, a misspelled function name) using LSP/Ruff/Pyright error messages, without needing them pointed out.

`database.py` is committed and pushed to GitHub.

## `main.py` (GUI)

Set up a Python virtual environment (`venv/`) in the project folder and installed Flet inside it. `main.py` imports `flet` and `database`, defines a `main(page)` function that displays the spool list and now includes a working Add Spool form.

**Add Spool form:** `TextField`s for brand, material, color, and total weight, plus an `ElevatedButton` wired to `database.add_spool()`. Fields clear themselves after a successful add.

**Live spool list:** a Flet `Column` (`spool_list`) holds one row per spool, plus a `refresh_spool_list()` helper that clears and rebuilds the list from `database.get_all_spools()` every time a spool is added. Display format: `"brand - material - color - remaining_weight_g / total_weight_g"`.

**Bugs found and fixed by Mark this session** (via LSP/Ruff/Pyright errors and his own testing, not by being told the answer):
- A missing argument in the `add_spool()` call inside `add_spool_clicked` — `material_input.value` was skipped entirely between brand and color.
- Unclosed parentheses on a `ft.Text(...)`/`.append()` line, which cascaded into misleading errors on unrelated later lines — a repeat of a pattern from the previous session, correctly recognized this time.
- `spool_list` was created and its contents updated correctly, but was never passed to `page.add()` — so nothing rendered even though the underlying logic worked. Diagnosed by comparing working vs. non-working code side by side, and by checking the database directly via the REPL to confirm the data layer was fine and isolate the bug to the display layer.

Also learned that `ft.ElevatedButton`'s label parameter is `content`, not `text` — the LSP flagged the wrong usage, and the fix was found by checking the current official Flet docs (the API has changed across versions).

**Update / Delete (full CRUD milestone):** each row in the spool list now has its own "New weight" `TextField`, an Update button, and a Delete button — the last two CRUD operations, wired to `database.update_remaining_weight()` and `database.delete_spool()`.

The Update/Delete buttons use Python closures: `make_delete_handler(sid)` and `make_update_handler(sid, field)` each return an inner `handler()` function, called once per spool inside the refresh loop, so each button "remembers" its own spool's id (and, for Update, its own weight input field) independently of every other row's buttons. Verified with real multi-row testing — updating one spool's weight or deleting one spool leaves every other row completely untouched, confirming the closures correctly isolate each row's data.

**Two more bugs found and fixed by Mark this session**, both traced through LSP error messages:
- A newly-created `new_weight_input` `TextField` and the Update button were built but never actually added to the row's controls list — LSP flagged it directly ("assigned to but never used"). Same root category as the earlier "created a widget but never added it to the page" bug, caught faster this time.
- A stray parenthesis typo inside a variable name (`new_weight_input` became `new)weight_input`) caused a cascading syntax error across ~13 lines — correctly recognized as "probably one small thing" rather than being overwhelmed by the error count, consistent with a similar bug pattern from earlier in the project.

**Note on closures:** Mark has said closures aren't fully clicking conceptually yet, despite getting them working correctly twice now (delete and update). Expected — this is a "repetition builds understanding" concept, not a one-explanation concept. Worth revisiting/reinforcing in future sessions rather than assuming it's settled.

**Schema/UX update:** the Add Spool form gained a `variant_input` `TextField` and a `spool_type_input` `Dropdown` (`ft.Dropdown`, first use of it in this project) offering a fixed "Spooled"/"Refill" choice, matching the new `variant`/`spool_type` columns. Adding two columns in the middle of the table shifted every tuple index after them — Mark independently identified this and worked through remapping `spool[0]` through `spool[7]` to the new column order himself, updating both the row display string and the update/delete closures.

**Bug fix — comma in weight input:** both weight fields (Add Spool total weight, and the per-row update weight) previously crashed with "could not convert string to float" on a comma-formatted number (e.g. `"2,000"`) — a realistic real-world input. Fixed by calling `.replace(",", "")` on the value before `float()` in both locations.

Mark has started entering his real inventory with the finished form — roughly 52 spools across ~5 brands (materials spanning PLA Basic/Silk/Tri-Color/Dual-Color/Glow, PETG HF/Translucent/CF, ABS, ABS GF, ASA, TPU).

## Next steps (not yet decided)

- Clean up Flet deprecation warnings (`ft.app()` → `ft.run()`, `ElevatedButton` → `Button`).
- Further input validation.
- Visual/UI polish.
- Or: consider this a complete v1 and move to a different phase.
