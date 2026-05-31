"""
db.py — Database connection management
"""
import os
import mysql.connector
from dotenv import load_dotenv

load_dotenv()

def get_db():
    """FastAPI dependency — yields a DB connection per request."""
    conn = mysql.connector.connect(
        host=os.getenv("DB_HOST", "localhost"),
        port=int(os.getenv("DB_PORT", 3306)),
        database=os.getenv("DB_NAME", "ecms"),
        user=os.getenv("DB_USER", "root"),
        password=os.getenv("DB_PASSWORD", ""),
        autocommit=True,
    )
    try:
        yield conn
    finally:
        conn.close()
