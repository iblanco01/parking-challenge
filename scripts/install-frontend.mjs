// Instala las dependencias de Angular. Lo ejecuta el postinstall de la raíz.
//
// Se lanza npm con cwd en apps/frontend en lugar de `npm --prefix apps/frontend install`:
// con ciertas configuraciones de npm (p. ej. un `prefix` en el .npmrc de usuario), `--prefix`
// hace que npm instale el proyecto raíz dentro del frontend, lo que vuelve a lanzar este
// postinstall en bucle y modifica apps/frontend/package.json.
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';

// Freno contra bucles: si ya estamos dentro de esta instalación, no hacer nada.
if (process.env.PARKING_INSTALLING_FRONTEND) process.exit(0);

const cwd = fileURLToPath(new URL('../apps/frontend/', import.meta.url));
const env = { ...process.env, PARKING_INSTALLING_FRONTEND: '1' };
const npmCli = process.env.npm_execpath;

const result = npmCli
  ? spawnSync(process.execPath, [npmCli, 'install'], { cwd, env, stdio: 'inherit' })
  : spawnSync(process.platform === 'win32' ? 'npm.cmd' : 'npm', ['install'], {
      cwd, env, stdio: 'inherit', shell: process.platform === 'win32'
    });

if (result.error) console.error(result.error);
process.exit(result.status ?? 1);
