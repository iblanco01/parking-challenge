import { mkdirSync, rmSync } from 'node:fs';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { DatabaseSync } from 'node:sqlite';

const root = resolve(dirname(fileURLToPath(import.meta.url)), '../../..');
const dataDir = resolve(root, 'data');
const dbPath = resolve(dataDir, 'parking.sqlite');
mkdirSync(dataDir, { recursive: true });
rmSync(dbPath, { force: true });
const db = new DatabaseSync(dbPath);
db.exec(`
  PRAGMA journal_mode = WAL;
  CREATE TABLE parking_days (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date TEXT NOT NULL UNIQUE,
    weekday TEXT NOT NULL,
    capacity INTEGER NOT NULL,
    enabled INTEGER NOT NULL DEFAULT 1,
    additional_info TEXT
  );
  CREATE TABLE reservations (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    parking_day_id INTEGER NOT NULL,
    full_name TEXT NOT NULL,
    email TEXT NOT NULL,
    note TEXT,
    status TEXT NOT NULL DEFAULT 'CONFIRMED',
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (parking_day_id) REFERENCES parking_days(id)
  );
  CREATE TABLE notifications (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    email TEXT NOT NULL,
    subject TEXT NOT NULL,
    body TEXT NOT NULL,
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
  );
`);
const insert = db.prepare('INSERT INTO parking_days (date, weekday, capacity, enabled, additional_info) VALUES (?, ?, ?, ?, ?)');
[
  ['2026-11-16', 'Lunes', 20, 1, 'Parking del edificio Amura'],
  ['2026-11-17', 'Martes', 20, 0, 'No habilitado'],
  ['2026-11-18', 'Miércoles', 5, 1, 'Día con capacidad reducida'],
  ['2026-11-19', 'Jueves', 20, 1, 'Parking del edificio Amura'],
  ['2026-11-20', 'Viernes', 20, 0, 'No habilitado']
].forEach((day) => insert.run(...day));
db.close();
console.log(`Database created at ${dbPath}`);
