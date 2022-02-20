import sqlite3

def db_connect(db, query):
    con = sqlite3.connect("animal.db")
    cur = con.cursor()
    cur.execute(query)
    result = cur.fetchall()
    con.close()
    return result
