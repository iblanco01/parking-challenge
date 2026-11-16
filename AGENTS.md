# Parking Challenge

Construir una aplicación web para reservar plazas de parking de la empresa.

## Stack fijado

- Angular para el frontend.
- Node.js estándar para el backend HTTP.
- `node:http` para rutas y servidor.
- `node:sqlite` para persistencia.
- TypeScript solo en Angular; el backend usa JavaScript ESM para reducir dependencias.

## Arquitectura

Usar vertical slices. Cada funcionalidad debe contener sus rutas, reglas y tests juntos.

```text
apps/backend/src/features/<feature>/
├── <feature>.routes.mjs
└── <feature>.service.mjs
```

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
