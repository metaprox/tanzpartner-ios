import test from 'node:test';
import assert from 'node:assert/strict';
import { mkdtemp, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join } from 'node:path';

test('SQLite initialisiert, speichert dauerhaft und meldet Fehler', async () => {
  const dir = await mkdtemp(join(tmpdir(), 'tanz-db-'));
  process.env.TANZ_DB_PATH = join(dir, 'test.sqlite');
  const store = await import('./db.js');
  const run = (db, sql, args = []) => new Promise((resolve, reject) => db.run(sql, args, err => err ? reject(err) : resolve()));
  const get = (db, sql) => new Promise((resolve, reject) => db.get(sql, (err, row) => err ? reject(err) : resolve(row)));
  try {
    let db = await store.waitDbReady();
    assert.equal((await get(db, 'PRAGMA foreign_keys')).foreign_keys, 1);
    await run(db, `INSERT INTO profiles (number,name,city,style,role,level,goal,time,bio) VALUES (?,?,?,?,?,?,?,?,?)`, ['TEST-SQL','Fiktiver SQL-Test','Norden','Discofox','Beides','Anfang','Üben','Abends','Nur Testdaten']);
    await store.closeDb();
    db = await store.waitDbReady();
    assert.equal((await get(db, 'SELECT name FROM profiles')).name, 'Fiktiver SQL-Test');
    await assert.rejects(run(db, "UPDATE profiles SET status='ungueltig'"), /CHECK/);
    await assert.rejects(run(db, "INSERT INTO moderation_queue(profile_id,status) VALUES(999,'pending')"), /FOREIGN KEY/);
  } finally {
    await store.closeDb();
    await rm(dir, { recursive: true, force: true });
    delete process.env.TANZ_DB_PATH;
  }
});
