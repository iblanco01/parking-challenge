---
name: spec
description: >
  Escribe en docs/spec.md la especificación de alto nivel del cambio: enfoque, alcance, decisiones, criterios de
  aceptación y riesgos, y extrae las reglas de negocio a docs/business-rules.md.
  Entrevista primero al usuario. Úsala antes de planificar, cuando el usuario pida /spec o `plan` no encuentre una.
user-invocable: true
---

# Especificar

Un cambio tiene tres registros, cada uno sobre el anterior:
el enunciado (`docs/challenge.md`) dice el qué y el porqué, la especificación (esta skill) dice el cómo a alto nivel
y el plan (`plan`) dice el detalle técnico.
La especificación fija el enfoque y las decisiones que cambian la solución; cualquier otro detalle va al plan.

## Requisitos

- `AGENTS.md` leído: el stack y la arquitectura fijados ganan sobre cualquier idea propia.
- [template.md](template.md), junto a este fichero. Sin él, para y avisa al usuario.
- `docs/challenge.md` y el material de reglas que dé el usuario (manual, correos, notas).
  Si el repositorio no trae el manual y el enunciado no basta para decidir, pídelo antes de seguir.

## Reglas

- Explora en solo lectura. Solo escribes `docs/spec.md` y `docs/business-rules.md`, y solo tras confirmar.
  Nunca escribes código, ni cambias de rama, ni haces commit.
- Nunca inventes una regla de negocio. Cada regla de `docs/business-rules.md` cita su origen (enunciado, manual,
  respuesta del usuario o suposición marcada como tal). Si nadie puede decidirla, es un bloqueo: díselo al usuario.
- Alto nivel, legible por negocio y por ingeniería: sin contratos campo a campo, modelo de datos, nombres de
  componentes ni rutas de ficheros. Eso es del plan.
- Respeta `AGENTS.md`: vertical slices, `node:http`, `node:sqlite`, persistencia real, notificaciones solo en log.
  No propongas hexagonal, CQRS ni capas globales salvo que lo justifiques por escrito en `Decisiones`.
- Un solo cambio, una sola entrega. Si no cabe en el tiempo del reto, proponlo recortado: lo imprescindible primero,
  lo demás en `Fuera de alcance`.
- Entrevista en el idioma de la sesión. Escribe la especificación en español de España.

## Cómo operar

```text
Progreso de spec:
- [ ] Paso 1: Leer AGENTS.md, docs/challenge.md y el material de reglas.
- [ ] Paso 2: Explorar el repositorio (qué hay y qué no) con lectura dirigida.
- [ ] Paso 3: Proponer de dos a cuatro enfoques distintos y recomendar uno.
- [ ] Paso 4: Entrevistar al usuario (una sola tanda).
- [ ] Paso 5: Escribir docs/spec.md y docs/business-rules.md.
- [ ] Paso 6: Mostrarlos y repetir con las correcciones hasta que el usuario confirme.
- [ ] Paso 7: Guardar y devolver el control al usuario.
```

### Paso 3: enfoques

Para cada enfoque: idea central, encaje con `AGENTS.md`, trade-offs (complejidad, riesgo, esfuerzo, mantenimiento).
Descarta con una línea los que rompan una restricción. Con el stack fijado, los enfoques difieren en el
alcance, el modelo de reserva (p. ej. cómo se cuentan las plazas) o la experiencia de usuario, no en tecnología.

### Paso 4: entrevista

- Primera pregunta: los enfoques con sus trade-offs, el recomendado primero y marcado.
- Después, solo las dudas que cambian el enfoque o el alcance y que el enunciado, el material y el código no
  responden (qué cuenta como plaza ocupada, quién puede cancelar y hasta cuándo, qué días están habilitados...).
- Deja a `plan` los contratos, el modelo de datos, los casos límite, los nombres y los tests.
- Usa `AskUserQuestion` en una sola tanda de hasta 4 preguntas, con las opciones vistas y un valor por defecto
  recomendado. Pon todo el texto en `label` y `description`, nunca en `preview`.
  Sin esa herramienta, agrupa las preguntas en texto libre.
- Una pregunta sin respuesta toma el valor recomendado y queda como suposición en `Decisiones`.

### Paso 5: formato

Rellena [template.md](template.md): sus encabezados tal cual, en su orden, y sin `<...>` sin sustituir.
Escribe cada regla de negocio en `docs/business-rules.md` como `BR1`, `BR2`... estables y con su origen.
Sin marcadores ("pendiente", "por definir", "gestionar los errores" sin decir cuáles y cómo).
Un punto que nadie puede decidir todavía es un bloqueo, no un hueco que se rodea.

## Formato de salida

- **Especificación**: dónde se escribió y qué cambió si se revisó.
- **Reglas de negocio**: cuántas se extrajeron y cuáles son suposiciones.
- **Pendiente**: bloqueos que nadie puede decidir todavía, o "ninguno".
