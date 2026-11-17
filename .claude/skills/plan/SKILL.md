---
name: plan
description: >
  Escribe en docs/plan.md un plan de implementación autocontenido a partir de docs/spec.md: modelo de datos, API,
  tareas ordenadas con tests y verificación. Entrevista primero al usuario. Úsala antes de escribir código; sustituye
  al modo plan.
user-invocable: true
---

# Planificar

Convierte la especificación (enfoque y decisiones, de `spec`) en ficheros, tareas y verificación.
Cualquier ejecutor puede seguir el plan sin preguntar: dice qué hacer y `build` escribe el código.

## Requisitos

- `docs/spec.md` y `docs/business-rules.md`. Sin especificación, invoca `spec` (o avisa al usuario) y para.
- [template.md](template.md), junto a este fichero. Sin él, para y avisa al usuario.
- `AGENTS.md` leído: sus restricciones y comandos se usan tal cual, nunca reconstruidos.

## Reglas

- No uses `EnterPlanMode`. Si la sesión ya está en modo plan, presenta el plan con `ExitPlanMode` y, una vez
  aprobado, escribe `docs/plan.md` antes que nada.
- Explora en solo lectura. Solo escribes `docs/plan.md`. El código y los tests los escribe `build`.
- Define tareas, nunca código: sin bloques de código, fragmentos ni firmas completas. Describe en prosa qué cambia
  y por qué, nombrando rutas, símbolos y contratos.
- Nunca reabras la especificación: desarrolla el detalle técnico que deja abierto. Si no puede funcionar como se
  especificó, o el detalle fuerza un cambio de enfoque o de decisiones, para, explica por qué y dile al usuario que
  la revise con `spec`.
- Un plan es una entrega. Sin fases ni planes de seguimiento. Ordena las tareas por valor: lo imprescindible
  (MVP) primero, de modo que cada tarea deje la aplicación arrancable con `npm run dev`.
- Arquitectura: vertical slices en `apps/backend/src/features/<feature>/` con `<feature>.routes.mjs`,
  `<feature>.service.mjs` y `<feature>.spec.mjs`. Sin controllers/, services/, repositories/, domain/, ports/ ni
  adapters/ globales. Las rutas se registran con el router de `server.mjs`.
- No añadas dependencias sin preguntar al usuario. Si el plan las necesita, plantéalo en la entrevista.
- Las reglas de reserva llevan tests (`node:test`, `npm test`): ponlos en el `Tests:` de la tarea que las implementa.
- Entrevista en el idioma de la sesión; escribe el plan en español de España.

## Base de código limpio

Se diseña con ella, no se repite en el plan. `AGENTS.md` y el código de alrededor ganan sobre ella.

- Valida la entrada en la frontera (ruta) antes de tocar la lógica, y rechaza con un error claro.
- Separa la lógica pura de reserva (sin E/S ni reloj implícito) del resto: así se prueba sin mocks.
- Nombres que dicen lo que son; funciones pequeñas con una sola responsabilidad; guard clauses en vez de anidar.
- Sin números ni cadenas mágicas; sin código muerto; sin errores tragados; comentarios del porqué, no del qué.
- Nada de abstracciones nuevas (clase base, interfaz, wrapper, factoría, helper genérico) hasta que haya tres usos
  reales. Antes duplicar que abstraer mal.

## Cómo operar

```text
Progreso de plan:
- [ ] Paso 1: Leer docs/spec.md, docs/business-rules.md y AGENTS.md.
- [ ] Paso 2: Explorar el repositorio (server.mjs, db.mjs, reset-db.mjs, frontend) con lectura dirigida.
- [ ] Paso 3: Entrevistar al usuario sobre lo que la especificación deja abierto (una sola tanda).
- [ ] Paso 4: Escribir docs/plan.md desde template.md.
- [ ] Paso 5: Autorrevisión y corrección de cada hueco.
- [ ] Paso 6: Mostrar el plan y devolver el control al usuario.
```

### Paso 3: entrevista

- Solo diseño técnico e implementación: contratos de la API, modelo de datos, gestión de errores, dónde va el código,
  nombres, orden de tareas, casos límite y tests. Nunca lo que la especificación, el enunciado o el código ya dicen.
- Si no queda nada abierto, sáltala y dilo.
- Usa `AskUserQuestion` en una sola tanda (máximo 4 preguntas) con las opciones vistas y un valor recomendado.
  Todo el texto en `label` y `description`, nunca en `preview`.
- Una pregunta sin respuesta toma el valor recomendado, anotado como suposición en `Decisiones`.

### Paso 4: formato

Rellena [template.md](template.md): sus secciones en su orden, cada `<...>` sustituido.
Las tareas son `### Tarea 1: ...`, `### Tarea 2: ...`, ordenadas, cada una implementable y verificable por sí sola.

- `Criterios de aceptación`: los de la especificación, numerados `AC1`, `AC2`... en su orden. No se renumeran:
  los `Cubre:` de las tareas apuntan a ellos.
- Referencia código por ruta y símbolo (función, clase, método), nunca por número de línea.
- La tarea del esquema de base de datos edita `apps/backend/scripts/reset-db.mjs`, que es quien crea las tablas.
- Los casos de test acordados en la entrevista van al `Tests:` de su tarea.

Sin marcadores: "TBD", "TODO", "implementar más tarde", "gestionar los errores" sin decir cuáles y cómo,
"igual que la Tarea N" (las tareas se leen aisladas) ni referencias a tipos, funciones o ficheros que no existan
ni se definan en una tarea.

### Paso 5: autorrevisión

1. **Cobertura**: cada criterio de aceptación está en algún `Cubre:` y cada regla `BRn` se implementa en una tarea.
2. **Marcadores**: ninguno de los anteriores y ningún `<...>` sobrante.
3. **Coherencia**: nombres, contratos y rutas coinciden entre tareas y con el código real.
4. **Una entrega**: nada se aplaza a otra fase.
5. **Sin código**: ningún bloque de código ni implementación en el fichero.
6. **Restricciones**: nada contradice `AGENTS.md` (arquitectura, dependencias, persistencia, notificaciones).

## Formato de salida

- **Plan**: la ruta de `docs/plan.md`.
- **Resumen**: la sección `Resumen` del plan, literal.
- **Siguientes pasos**: ajustar el plan o implementarlo con `build`.
- **Pendiente**: bloqueos abiertos o una revisión necesaria de la especificación, o "ninguno".
