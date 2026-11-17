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

- Arranque recomendado y aislado (cualquier sistema, con o sin Node instalado): en Windows `.\bootstrap.ps1` y `.\start.ps1`; en Linux/WSL/macOS `bash ./bootstrap.sh` y `bash ./start.sh`. Usan siempre el Node portable de `tools/` (nunca el del sistema), la caché de npm en `.npm-cache/` y dejan todo dentro de la carpeta del proyecto: borrarla deja el equipo como estaba.
- Alternativa con tu propio Node ≥22.13 (no aislada: la caché de npm es la global): `npm install` (instala también Angular), `npm run setup` y `npm run dev`.
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

1. `/intent`
2. `/spec`
3. `/plan`
4. `/build`
5. `/document`
6. `/finish`

Las skills están en `.claude/skills/<nombre>/SKILL.md`. Si tu agente no las carga solo, lee ese fichero y sigue sus pasos.
`/spec` advierte de que hacer un mock del servicio en Claude Design (herramienta `Artifact`) es muy necesario para obtener buenos resultados, y recomienda hacerlo antes de seguir.
Cada fase deja su resultado en ficheros del repositorio: `docs/intent.md` (`/intent`), `docs/spec.md` y `docs/business-rules.md` (`/spec`), `docs/plan.md` (`/plan`),
el código y sus tests (`/build`), las páginas de `docs/` y el `README.md` (`/document`) y el informe final (`/finish`).
Todo es local: no se crean tickets, páginas ni pull requests en ningún servicio externo (Jira, Confluence, Bitbucket u otros)
y `/build` y `/finish` no hacen commit ni push sin que el usuario lo pida.

## Reglas

- La persistencia debe ser real; no usar solo memoria o `localStorage`.
- No implementar correo real: registrar las notificaciones localmente.
- Mantener la aplicación arrancable con `npm run dev`.
- Mantener compatibilidad con Node 22.13 LTS o superior.
- Añadir o actualizar tests para las reglas de reserva.
