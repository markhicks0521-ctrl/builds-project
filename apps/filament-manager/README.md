*Living document — updated each session*

> Single source of truth. Do not create versioned copies — update this file in place at the end of each session.

# Filament Manager

**Status:** `database.py` CRUD is complete and tested. GUI has a working Add Spool form with a live-updating list.

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
| `get_all_spools()` | Reads all spool rows |
| `update_remaining_weight(spool_id, new_weight)` | Updates one spool's remaining weight — `WHERE` clause targets a single row |
| `delete_spool(spool_id)` | Deletes one spool row — `WHERE` clause targets a single row |

**`spools` table:** `id`, `brand`, `material`, `color`, `total_weight_g`, `remaining_weight_g`

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

## Next steps

1. Add Update (remaining weight) and Delete buttons to each row in the spool list, wired to `update_remaining_weight()` and `delete_spool()`.
2. Commit and push.
