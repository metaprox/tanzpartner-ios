// Nur für Node.js. Browser greifen später über eine Server-API zu.
import sqlite3 from 'sqlite3';
import { fileURLToPath } from 'node:url';

export const databasePath = process.env.TANZ_DB_PATH || fileURLToPath(new URL('./data.sqlite', import.meta.url));
let db = null;
let ready = null;
let closing = null;

export function getDb() {
  if (closing) throw new Error('Datenbank wird gerade geschlossen');
  if (!db) {
    ready = new Promise((resolve, reject) => {
      db = new sqlite3.Database(databasePath, err => {
        if (err) return reject(err);
        db.exec(`PRAGMA foreign_keys = ON;

          CREATE TABLE IF NOT EXISTS profiles (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            number TEXT UNIQUE NOT NULL,
            name TEXT NOT NULL,
            city TEXT NOT NULL,
            style TEXT NOT NULL,
            role TEXT NOT NULL,
            level TEXT NOT NULL,
            goal TEXT NOT NULL,
            time TEXT NOT NULL,
            bio TEXT NOT NULL,
            status TEXT DEFAULT 'pending' CHECK(status IN ('pending', 'approved', 'paused', 'returned')),
            token TEXT UNIQUE,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
          );

          CREATE TABLE IF NOT EXISTS moderation_queue (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            profile_id INTEGER NOT NULL,
            status TEXT NOT NULL CHECK(status IN ('pending', 'approved', 'paused', 'returned')),
            note TEXT,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (profile_id) REFERENCES profiles(id)
          );

          CREATE INDEX IF NOT EXISTS idx_profiles_status ON profiles(status);
          CREATE INDEX IF NOT EXISTS idx_profiles_number ON profiles(number);
          CREATE INDEX IF NOT EXISTS idx_profiles_city ON profiles(city);
          CREATE INDEX IF NOT EXISTS idx_profiles_style ON profiles(style);

        `, schemaError => schemaError ? reject(schemaError) : resolve(db));
      });
    });
    // Auch Aufrufer von getDb() ohne waitDbReady() erzeugen keine unbehandelte Ablehnung.
    ready.catch(() => {});
  }
  return db;
}

export function waitDbReady() {
  getDb();
  return ready;
}

export function closeDb() {
  if (closing) return closing;
  if (!db) return Promise.resolve();
  const connection = db;
  closing = (async () => {
    try { await ready; } catch { /* Auch nach Initialisierungsfehlern aufräumen. */ }
    await new Promise((resolve, reject) => connection.close(err => {
      if (err && err.code !== 'SQLITE_MISUSE') reject(err);
      else resolve();
    }));
    db = null;
    ready = null;
  })().finally(() => { closing = null; });
  return closing;
}
