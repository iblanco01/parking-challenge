---
name: build
description: >
  Implementa las tareas de docs/plan.md en orden, con sus tests, hace una revisión independiente y corrige lo grave.
  Anota el resultado de cada tarea en el plan. Úsala después de planificar o cuando el usuario pida /build.
user-invocable: true
---

# Construir

Construye las tareas de `docs/plan.md` una a una, con sus tests, hasta dejar la aplicación arrancable con `npm run dev`.
Una ronda de revisión independiente al final, con una sola corrección de lo grave.

## Requisitos

- `docs/plan.md` y `docs/spec.md`. Sin plan, para y dile al usuario que ejecute `plan`.
- `AGENTS.md` leído: stack, arquitectura y reglas del reto. Los comandos se ejecutan tal cual aparecen.
- La aplicación arranca (`npm run dev`) y `GET /api/health` responde. Si no, es lo primero que se arregla o se avisa.

## Entrada

- **Alcance**: todas las tareas, salvo que el usuario nombre algunas.
- **Notas**: decisiones del usuario en esta sesión que no están en el plan.

## Reglas

- Sigue el plan. Si una tarea no puede hacerse como está escrita, haz lo mínimo para cumplir su intención y anota
  la desviación y el motivo en su `Resultado`. Si la desviación cambia el enfoque, para y dile al usuario que
  revise `spec` o `plan`.
- Escribe solo código, tests y el fichero `docs/plan.md` (únicamente la línea `Resultado:` de cada tarea).
  No edites `AGENTS.md`, `docs/spec.md` ni el enunciado.
- Respeta `AGENTS.md`: vertical slices en `apps/backend/src/features/<feature>/`, `node:http`, `node:sqlite`, JavaScript
  ESM en backend, TypeScript solo en Angular, persistencia real, notificaciones solo en log, Node 22.13 o superior.
  Sin controllers/, services/, repositories/, domain/, ports/ ni adapters/ globales.
- No añadas dependencias sin preguntar al usuario.
- Primero el test, después el código: las reglas de reserva se escriben guiadas por sus tests (`node:test`, ficheros
  `<feature>.spec.mjs`). Cada tarea termina con su `Verificación` pasando.
- Sin abstracciones nuevas (clase base, interfaz, wrapper, factoría, helper genérico) hasta que haya tres usos
  reales. Sin código muerto, sin errores tragados, sin cadenas ni números mágicos.
- Frontend: Angular 19 con componentes standalone, responsive para escritorio y móvil. Sin dependencias nuevas.
- Nunca hagas commit, push ni cambies de rama: lo decide el usuario (ver `finish`).
- Datos de prueba ficticios y claramente falsos; nunca datos reales de personas.

## Cómo operar

```text
Progreso de build:
- [ ] Paso 1: Comprobar plan, especificación y que la aplicación arranca.
- [ ] Paso 2: Fijar el alcance y las notas.
- [ ] Paso 3: Por cada tarea, en orden: test que falla, código mínimo, verificación en verde.
- [ ] Paso 4: Si un test falla y no se arregla, parar e informar.
- [ ] Paso 5: Revisión independiente (ver Paso 5).
- [ ] Paso 6: Corregir los hallazgos `blocker` y `major`, una sola vez.
- [ ] Paso 7: Anotar el resultado en el plan.
- [ ] Paso 8: Ejecutar `npm test` y comprobar `/api/health`; informar al usuario.
```

### Paso 3: por cada tarea

1. Escribe el test del `Tests:` de la tarea y comprueba que falla por el motivo correcto.
2. Escribe el código mínimo que lo hace pasar, en los ficheros de `Ficheros:`.
3. Ejecuta la `Verificación:` de la tarea y deja la salida real en tu informe.
4. Pasa a la siguiente. No dejes una tarea a medias para empezar otra.

### Paso 5: revisión independiente

Lanza un subagente revisor en primer plano, con un prompt autocontenido (no ve esta conversación):

```text
Revisa el cambio de este repositorio contra docs/spec.md y docs/plan.md, sin editar ficheros.
Alcance: <ficheros cambiados>.
Comprueba: cada criterio de aceptación está cubierto y probado; las reglas de docs/business-rules.md se cumplen;
AGENTS.md se respeta (arquitectura, dependencias, persistencia, notificaciones); validación de entrada; errores
con código HTTP correcto; condiciones de carrera al reservar (dos reservas simultáneas de la última plaza);
inyección SQL (consultas parametrizadas); fugas de datos personales en logs; tests que no prueban lo que dicen.
Devuelve hallazgos con severidad (blocker, major, minor, nit), ruta:línea, problema y arreglo propuesto.
```

Sin subagentes, haz tú esa revisión con la misma lista, leyendo el diff completo antes de opinar.
Corrige los `blocker` y `major`; los `minor` y `nit` se dejan en el informe. No hay una tercera ronda.

### Paso 7: anotar el resultado

Añade a cada tarea de `docs/plan.md` una última viñeta: `- Resultado: hecho`, `- Resultado: <cómo se desvía y por qué>`
o `- Resultado: omitido, <motivo>`. No cambies nada más del plan.

## Formato de salida

- **Cambios**: qué cambió, en qué fichero y por qué.
- **Tests**: el comando y su resultado real.
- **Revisión**: veredicto, hallazgos corregidos y los `blocker` o `major` que sigan abiertos.
- **Desviaciones**: las del plan y las decisiones tomadas donde el plan no decía.
- **Pendiente**: tareas omitidas y por qué, fallos de test, o "ninguno".
