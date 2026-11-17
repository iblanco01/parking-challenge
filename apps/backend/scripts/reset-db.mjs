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
`);
db.close();
console.log(`Database created at ${dbPath}`);
