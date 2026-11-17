# Parking Challenge

Construir una aplicación web para reservar plazas de parking de la empresa.

## Stack fijado

- Angular para el frontend.
- Node.js estándar para el backend HTTP.
- `node:http` para rutas y servidor.
- `node:sqlite` para persistencia.
- TypeScript solo en Angular; el backend usa JavaScript ESM para reducir dependencias.

## Arranque (para cualquier IA o persona)

Funciona en Windows (PowerShell), Linux/WSL y macOS. Detalle completo en `README.md`.

- Sin Node ≥22.13 instalado: en Windows `.\bootstrap.ps1` y `.\start.ps1`; en Linux/WSL/macOS `bash ./bootstrap.sh` y `bash ./start.sh`. Descargan Node portable en `tools/`, instalan todas las dependencias y crean la base.
- Con Node ≥22.13 (cualquier sistema): `npm install` (instala también Angular), `npm run setup` y `npm run dev`.
- En WSL, trabajar dentro del sistema de ficheros de Linux (no en `/mnt/c`) y no compartir `node_modules/` con Windows.
- Los scripts npm no deben usar `npm.cmd` ni comandos específicos de un sistema.
- Resultado esperado: frontend en http://localhost:4200, backend en http://localhost:3000 y `GET /api/health` → `{"status":"ok"}`.
- `npm run setup` borra y recrea `data/parking.sqlite`: úsalo solo para empezar de cero.
- Modo producción local: `npm run build` y `npm start` (todo en http://localhost:3000).

## Arquitectura

Usar vertical slices. Cada funcionalidad nueva debe contener sus rutas, reglas y tests juntos. El repositorio inicial no debe incluir funcionalidades de reserva implementadas.

```text
apps/backend/src/features/<feature>/
├── <feature>.routes.mjs
├── <feature>.service.mjs
└── <feature>.spec.mjs
```

Los tests del backend usan `node:test` y se ejecutan con `npm test` (busca `apps/backend/src/**/*.spec.mjs`). El servidor expone `router.get/post/put/patch/delete`.

No introducir arquitectura hexagonal, repositorios genéricos, capas globales ni CQRS salvo que `/spec` lo justifique explícitamente.

## Flujo obligatorio

1. `/spec`
2. `/plan`
3. `/build`
4. `/document`
5. `/finish`

## Reglas

- La persistencia debe ser real; no usar solo memoria o `localStorage`.
- No implementar correo real: registrar las notificaciones localmente.
- Mantener la aplicación arrancable con `npm run dev`.
- Mantener compatibilidad con Node 22.13 LTS o superior.
- Añadir o actualizar tests para las reglas de reserva.
