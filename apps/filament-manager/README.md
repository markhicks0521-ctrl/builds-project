*Living document — updated each session*

> Single source of truth. Do not create versioned copies — update this file in place at the end of each session.

# Filament Manager

**Status:** Early development. `database.py` built and tested.

**Learning project:** Mark is writing all the Python code himself, working through it line by line to understand it. Claude Code is not generating application code.

## Stack

- SQLite for storage (`filament.db`)
- Flet for the GUI (planned, `main.py`)

## `database.py`

| Function | Purpose |
|---|---|
| `get_connection()` | Opens the SQLite connection |
| `init_db()` | Creates the `spools` table |
| `add_spool()` | Inserts a new spool row — parameterized query with `?` placeholders to avoid SQL injection |

**`spools` table:** `id`, `brand`, `material`, `color`, `total_weight_g`, `remaining_weight_g`

**Tested:** ran `init_db()` to create `filament.db`, then from the Python REPL imported the module, called `add_spool("Bambu", "PLA", "Black", 1000, 1000)`, and confirmed the row was written by querying it back with `cursor.execute("SELECT * FROM spools")` / `fetchall()` — returned `[(1, 'Bambu', 'PLA', 'Black', 1000.0, 1000.0)]`.

## Next steps

1. Add `get_all_spools()`, `update_spool()`, and `delete_spool()` to `database.py`.
2. Build the Flet GUI in `main.py`.
3. Commit and push to GitHub.
