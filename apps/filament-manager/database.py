import sqlite3

DB_FILE = "filament.db"



def get_connection():
    """Open a connection to the SQLite database file."""
    return sqlite3.connect(DB_FILE)
   
def init_db():
    """Create the spools table if it doesn't already exist."""
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS spools (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            brand TEXT NOT NULL,
            material TEXT NOT NULL,
            color TEXT NOT NULL,
            total_weight_g REAL NOT NULL,
            remaining_weight_g REAL NOT NULL
        )
    """)
    conn.commit()
    conn.close()

def add_spool(brand, material, color, total_weight_g, remaining_weight_g):
    """Insert a new spool record into database."""
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("""
        INSERT INTO spools (brand, material, color, total_weight_g, remaining_weight_g)
        VALUES (?, ?, ?, ?, ?)
    """, (brand, material, color, total_weight_g, remaining_weight_g))
    conn.commit()
    conn.close()

def get_all_spools():
    """Retrieve every spool record from the database."""
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM spools")
    rows = cursor.fetchall()
    conn.close()
    return rows

def update_remaining_weight(spool_id, new_remaining_weight_g):
    """Update the remaining weight for a specific spool, identified by its id."""
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("""
        UPDATE spools
        SET remaining_weight_g = ?
        WHERE id = ?
    """, (new_remaining_weight_g, spool_id))
    conn.commit()
    conn.close()

def delete_spool(spool_id):
    """Delete a spool record from the database, identified by its id."""
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM spools WHERE id = ?", (spool_id,))
    conn.commit()
    conn.close()

if __name__ == "__main__":
    init_db()
    print("Database initialized successfully.")

