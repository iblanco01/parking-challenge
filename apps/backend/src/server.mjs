import { createServer } from 'node:http';
import { statSync, createReadStream } from 'node:fs';
import { extname, resolve, sep } from 'node:path';
import { fileURLToPath } from 'node:url';
import { db } from './db.mjs';

const port = Number(process.env.PORT) || 3000;
const root = resolve(fileURLToPath(new URL('../../..', import.meta.url)));
const frontend = resolve(root, 'apps/frontend/dist/frontend/browser');
const routes = [];
const router = {
  get(path, handler) { routes.push({ method: 'GET', path, handler }); },
  post(path, handler) { routes.push({ method: 'POST', path, handler }); },
  put(path, handler) { routes.push({ method: 'PUT', path, handler }); },
  patch(path, handler) { routes.push({ method: 'PATCH', path, handler }); },
  delete(path, handler) { routes.push({ method: 'DELETE', path, handler }); }
};

const methodsWithBody = new Set(['POST', 'PUT', 'PATCH']);

function isFile(path) {
  try { return statSync(path).isFile(); } catch { return false; }
}

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

class BadRequestError extends Error {}

async function readBody(req) {
  if (!methodsWithBody.has(req.method)) return undefined;
  let raw = ''; for await (const chunk of req) raw += chunk;
  try { return raw ? JSON.parse(raw) : {}; }
  catch { throw new BadRequestError('JSON inválido'); }
}

const server = createServer(async (req, res) => {
  res.setHeader('Access-Control-Allow-Origin', 'http://localhost:4200');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
  res.setHeader('Access-Control-Allow-Methods', 'GET,POST,PUT,PATCH,DELETE,OPTIONS');
  if (req.method === 'OPTIONS') { res.statusCode = 204; return res.end(); }
  const url = new URL(req.url, 'http://localhost');
  if (req.method === 'GET' && url.pathname === '/api/health') return responseFor(res).json({ status: 'ok' });
  const route = routes.find((item) => item.method === req.method && match(item.path, url.pathname));
  if (route) {
    try { req.params = match(route.path, url.pathname); req.body = await readBody(req); return await route.handler(req, responseFor(res)); }
    catch (error) {
      if (error instanceof BadRequestError) return responseFor(res).error(400, error.message);
      console.error(error); return responseFor(res).error(500, 'Error interno');
    }
  }
  const index = resolve(frontend, 'index.html');
  if (req.method === 'GET' && !url.pathname.startsWith('/api/') && isFile(index)) {
    const requested = url.pathname === '/' ? '/index.html' : url.pathname;
    const file = resolve(frontend, `.${requested}`);
    const safe = file.startsWith(frontend + sep) && isFile(file) ? file : index;
    res.setHeader('Content-Type', { '.js': 'text/javascript', '.css': 'text/css', '.html': 'text/html' }[extname(safe)] ?? 'application/octet-stream');
    const stream = createReadStream(safe);
    stream.on('error', (error) => { console.error(error); res.destroy(); });
    return stream.pipe(res);
  }
  responseFor(res).error(404, 'Not found');
});

server.listen(port, () => console.log(`Backend listening on http://localhost:${port}`));
