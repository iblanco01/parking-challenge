# Parking Challenge

Reto de una hora para construir una aplicación de reservas de parking usando IA.

## Requisitos

- Windows con PowerShell, Linux/Ubuntu (incluido WSL) o macOS (Intel o Apple Silicon), y conexión a Internet en el primer arranque.
- No necesita Node instalado previamente, y aunque lo tengas no lo usa: `bootstrap.ps1` / `bootstrap.sh` descargan siempre un Node portable (con verificación SHA256) en `tools/`. En Linux/macOS necesitan `curl` y `tar`.
- No necesita Docker, PostgreSQL ni instalaciones globales.

## Arranque

Windows (PowerShell):

```powershell
.\bootstrap.ps1
.\start.ps1
```

Linux, WSL o macOS (bash/zsh):

```bash
bash ./bootstrap.sh
bash ./start.sh
```

Alternativa con tu propio Node 22.13 LTS o superior, en cualquier sistema (no aislada: usa la caché global de npm; `npm install` instala además las dependencias de Angular):

```bash
npm install
npm run setup
npm run dev
```

### Notas para WSL

- Clona el repositorio **dentro del sistema de ficheros de Linux** (por ejemplo `~/parking-challenge`), no en `/mnt/c/...`: es mucho más rápido y evita problemas con `node_modules`.
- No compartas la carpeta con una instalación de Windows: `node_modules/` y `tools/` contienen binarios de cada sistema. Si cambias de sistema sobre la misma carpeta, borra `node_modules/` y `apps/frontend/node_modules/` y repite el arranque.
- Se ignora el `node` de Windows visible desde WSL (`/mnt/...`).

- Frontend: http://localhost:4200
- Backend: http://localhost:3000
- Health check: http://localhost:3000/api/health

El backend usa `node:sqlite`, incluido en Node.js. La base de datos persistente queda en `data/parking.sqlite`, inicialmente vacía para que el equipo defina el modelo durante `/spec` y `/plan`.

## Flujo recomendado para el equipo

1. Leer `AGENTS.md` y `docs/challenge.md`.
2. Ejecutar `/spec`.
3. Ejecutar `/plan`.
4. Ejecutar `/build`.
5. Ejecutar `/document`.
6. Ejecutar `/finish`.

## Tests

```bash
npm test
```

Ejecuta los `*.spec.mjs` del backend con `node:test`. Sin funcionalidades aún, no hay tests.

## Producción local

```bash
npm run build
npm start
```

En este modo Node sirve la API y el frontend compilado desde http://localhost:3000.
