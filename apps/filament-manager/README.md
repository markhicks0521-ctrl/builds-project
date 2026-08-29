*Living document — updated each session*

> Single source of truth. Do not create versioned copies — update this file in place at the end of each session.

# Filament Manager

**Status:** `database.py` CRUD is complete and tested. GUI work started in `main.py`.

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

Set up a Python virtual environment (`venv/`) in the project folder and installed Flet inside it. `main.py` imports `flet` and `database`, defines a `main(page)` function that calls `get_all_spools()`, loops over the results, and displays each spool as a `Text` widget via an f-string. Ran successfully — a native window titled "Filament Manager" opened showing live data from `filament.db` ("Bambu - PLA - BLACK").

## Next steps

1. Build an "Add Spool" form in the GUI (text input fields + a button) that calls `add_spool()`, replacing REPL-based inserts.
2. Commit and push.
