---
name: finish
description: >
  Cierra el cambio sin preguntar: ejecuta tests, build y arranque real, comprueba cada criterio de aceptación con
  evidencia, las reglas de AGENTS.md y la coherencia de la documentación, y entrega un informe final.
  Úsala al terminar o cuando el usuario pida /finish.
user-invocable: true
---

# Terminar

Última fase del flujo, después de `build` y `document`, sin preguntar.
Comprueba que lo entregado cumple la especificación y las reglas del reto, y lo dice con evidencia.

## Requisitos

- `docs/spec.md`, `docs/plan.md` y `AGENTS.md`.
- Nada más que esperar: las tareas del plan tienen `Resultado:`.

## Reglas

- No preguntes al usuario: si un paso no puede decidir por sí solo, para ahí e informa del motivo.
- No cambies código para que algo pase: si una comprobación falla, informa del fallo con su salida. Solo arreglas
  lo trivial que `build` dejó a medias (p. ej. una línea del README) y lo dices.
- Nunca des por bueno lo que no has ejecutado: cada afirmación lleva el comando y su salida real.
- Nunca hagas `git commit` ni `git push` por tu cuenta. Prepara el resumen del cambio; el usuario decide.
- Para al terminar los procesos que arrancaste y borra los ficheros temporales que crees.

## Cómo operar

```text
Progreso de finish:
- [ ] Paso 1: Leer especificación, plan y AGENTS.md.
- [ ] Paso 2: Ejecutar `npm test` y `npm run build`.
- [ ] Paso 3: Arrancar la aplicación y recorrer el flujo principal por HTTP.
- [ ] Paso 4: Comprobar cada criterio de aceptación con evidencia.
- [ ] Paso 5: Comprobar las reglas de AGENTS.md.
- [ ] Paso 6: Comprobar la documentación.
- [ ] Paso 7: Parar lo arrancado, limpiar y entregar el informe.
```

### Paso 3: arranque real

Arranca con `npm run dev` (o `npm start` tras `npm run build`) y, con `curl`:

- `GET /api/health` responde `{"status":"ok"}`.
- Recorre el flujo del enunciado: consultar días y plazas, reservar, consultar la reserva, cancelar o reprogramar.
- Prueba un error de cada tipo que defina el plan (campo obligatorio ausente, día completo o no habilitado...).
- Reinicia el servidor y comprueba que los datos siguen ahí: la persistencia es real.

### Paso 4: criterios de aceptación

Para cada `ACn` de `docs/spec.md`: el comando o la prueba que lo demuestra, su salida real y el veredicto
(cumplido, no cumplido o no verificable, con motivo). Un criterio sin evidencia no está cumplido.

### Paso 5: reglas de AGENTS.md

- Estructura de vertical slices: cada funcionalidad con sus rutas, reglas y tests juntos; sin carpetas globales
  `controllers/`, `services/`, `repositories/`, `domain/`, `ports/` ni `adapters/`.
- Persistencia en `data/parking.sqlite`, no solo en memoria ni `localStorage`.
- Notificaciones registradas localmente, sin correo real.
- Aplicación arrancable con `npm run dev`; compatible con Node 22.13 o superior.
- Tests de las reglas de reserva, ejecutados por `npm test`.
- Sin dependencias nuevas que el usuario no haya aprobado (`git diff` de los `package.json`).
- Sin datos personales reales ni secretos en código, tests, fixtures, logs o documentación.

### Paso 6: documentación

Cada ruta, comando y enlace de `docs/` y del `README.md` existe y funciona; el README explica cómo arrancar la
aplicación terminada. Los `TBD` que queden se listan en `Pendiente`.

## Formato de salida

- **Tests y build**: comandos y resultado real.
- **Arranque**: lo comprobado por HTTP y su salida.
- **Criterios de aceptación**: cada `ACn` con su veredicto y su evidencia.
- **Reglas de AGENTS.md**: cada regla, cumplida o no, con su evidencia.
- **Documentación**: lo comprobado y lo que falta.
- **Cambios para commit**: `git status --short` y un mensaje de commit propuesto (sin ejecutarlo).
- **Pendiente**: lo no cumplido o no verificable y por qué, o "ninguno".
