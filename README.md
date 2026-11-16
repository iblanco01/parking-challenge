# Parking Challenge

Reto de una hora para construir una aplicación de reservas de parking usando IA.

## Requisitos

- Windows con PowerShell y conexión a Internet en el primer arranque.
- No necesita Node instalado previamente: `bootstrap.ps1` descarga una versión portable si hace falta.
- No necesita Docker, PostgreSQL ni instalaciones globales.

## Arranque

```powershell
.\bootstrap.ps1
.\start.ps1
```

Si Node 22.13 LTS o superior ya está instalado, también puedes usar:

```powershell
npm install
npm run setup
npm run dev
```

- Frontend: http://localhost:4200
- Backend: http://localhost:3000
- Health check: http://localhost:3000/api/health

El backend usa `node:sqlite`, incluido en Node.js. La base de datos persistente queda en `data/parking.sqlite`.

## Flujo recomendado para el equipo

1. Leer `AGENTS.md` y `docs/challenge.md`.
2. Ejecutar `/spec`.
3. Ejecutar `/plan`.
4. Ejecutar `/build`.
5. Ejecutar `/document`.
6. Ejecutar `/finish`.

## Producción local

```powershell
npm run build
npm start
```

En este modo Node sirve la API y el frontend compilado desde http://localhost:3000.
