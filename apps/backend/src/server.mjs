import { createServer } from 'node:http';
import { existsSync, createReadStream } from 'node:fs';
import { extname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { db } from './db.mjs';
import { registerAvailabilityRoutes } from './features/availability/availability.routes.mjs';
import { registerReservationRoutes } from './features/reservations/reservations.routes.mjs';

const root = resolve(fileURLToPath(new URL('../../..', import.meta.url)));
const frontend = resolve(root, 'apps/frontend/dist/frontend/browser');
const routes = [];
const router = {
  get(path, handler) { routes.push({ method: 'GET', path, handler }); },
  post(path, handler) { routes.push({ method: 'POST', path, handler }); }
};

function match(pattern, actual) {
  const names = [];
  const regex = new RegExp(`^${pattern.replace(/:[^/]+/g, (part) => { names.push(part.slice(1)); return '([^/]+)'; })}$`);
  const result = actual.match(regex);
  return result ? Object.fromEntries(names.map((name, index) => [name, result[index + 1]])) : null;
}

function responseFor(res) {
  return {
    status(code) { res.statusCode = code; return this; },
    json(value) { res.setHeader('Content-Type', 'application/json'); res.end(JSON.stringify(value)); },
    error(code, message) { res.statusCode = code; this.json({ error: message }); }
  };
}

async function readBody(req) {
  if (req.method !== 'POST') return undefined;
  let raw = ''; for await (const chunk of req) raw += chunk;
  return raw ? JSON.parse(raw) : {};
}

registerAvailabilityRoutes(router);
registerReservationRoutes(router);

const server = createServer(async (req, res) => {
  res.setHeader('Access-Control-Allow-Origin', 'http://localhost:4200');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
  res.setHeader('Access-Control-Allow-Methods', 'GET,POST,OPTIONS');
  if (req.method === 'OPTIONS') return res.end();
  const url = new URL(req.url, 'http://localhost');
  if (req.method === 'GET' && url.pathname === '/api/health') return responseFor(res).json({ status: 'ok' });
  const route = routes.find((item) => item.method === req.method && match(item.path, url.pathname));
  if (route) {
    try { req.params = match(route.path, url.pathname); req.body = await readBody(req); return await route.handler(req, responseFor(res)); }
    catch (error) { console.error(error); return responseFor(res).error(500, 'Error interno'); }
  }
  if (req.method === 'GET' && existsSync(frontend)) {
    const requested = url.pathname === '/' ? '/index.html' : url.pathname;
    const file = resolve(frontend, `.${requested}`);
    const safe = file.startsWith(frontend) && existsSync(file) ? file : resolve(frontend, 'index.html');
    res.setHeader('Content-Type', { '.js': 'text/javascript', '.css': 'text/css', '.html': 'text/html' }[extname(safe)] ?? 'application/octet-stream');
    return createReadStream(safe).pipe(res);
  }
  responseFor(res).error(404, 'Not found');
});

server.listen(3000, () => console.log('Backend listening on http://localhost:3000'));
