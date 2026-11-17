import { existsSync, mkdirSync } from 'node:fs';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { DatabaseSync } from 'node:sqlite';

const root = resolve(dirname(fileURLToPath(import.meta.url)), '../../..');
const dbPath = resolve(root, 'data/parking.sqlite');
mkdirSync(dirname(dbPath), { recursive: true });
if (!existsSync(dbPath)) throw new Error('Database not initialized. Run: npm run setup');
export const db = new DatabaseSync(dbPath);
// Ajustes por conexión: SQLite no los persiste en el fichero (salvo WAL).
db.exec('PRAGMA foreign_keys = ON; PRAGMA busy_timeout = 5000;');
