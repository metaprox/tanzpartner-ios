// Verbindung zur Projektdatei prüfen; keine Profildaten ausgeben oder verändern.
import { waitDbReady, closeDb } from './db.js';
try {
  const db = await waitDbReady();
  await new Promise((resolve, reject) => db.get('SELECT COUNT(*) AS count FROM profiles', (err, row) => {
    if (err) return reject(err);
    console.log(`SQLite verbunden; Profiltabelle lesbar (${row.count} Datensätze).`);
    resolve();
  }));
} catch (error) {
  console.error('SQLite-Verbindung fehlgeschlagen:', error.message);
  process.exitCode = 1;
} finally {
  await closeDb();
}
