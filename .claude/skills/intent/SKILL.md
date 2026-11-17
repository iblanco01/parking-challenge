---
name: intent
description: >
  Define la intención del cambio en docs/intent.md: el problema, el resultado esperado, a quién afecta, las
  restricciones y las preguntas abiertas. Parte del enunciado y entrevista al usuario. Es el primer paso del flujo,
  antes de /spec. Úsala cuando el usuario pida /intent o `spec` no encuentre una intención.
user-invocable: true
---

# Definir la intención

La intención dice el qué y el porqué del cambio, nunca el cómo.
Es el punto de partida de `spec`, que decide cómo se resuelve, y de `plan`, que baja el detalle técnico.

## Requisitos

- `AGENTS.md` leído: las restricciones fijadas del reto son restricciones de la intención.
- `docs/challenge.md`, el enunciado, que es la fuente principal. Si el usuario aporta más material (manual,
  correos, notas), léelo también.
- [template.md](template.md), junto a este fichero. Sin él, para y avisa al usuario.

## Reglas

- Solo escribes `docs/intent.md`, y solo tras confirmar. Nunca cambias `docs/challenge.md`.
- Nunca inventes una respuesta: lo que el usuario no puede responder todavía, o decide otra persona, va a
  `Preguntas abiertas`.
- Describe resultados observables por personas o sistemas, no la implementación: sin pantallas, tecnologías,
  tablas, endpoints ni nombres de componentes. Eso es de `spec` y `plan`.
- Una a tres frases por sección. Sin marcadores ("pendiente", "por definir") fuera de `Preguntas abiertas`.
- Entrevista en el idioma de la sesión; escribe la intención en español de España.

## Cómo operar

```text
Progreso de intent:
- [ ] Paso 1: Si docs/intent.md ya existe, léela y revísala en vez de reescribirla.
- [ ] Paso 2: Leer AGENTS.md, docs/challenge.md y el material que dé el usuario.
- [ ] Paso 3: Redactar un borrador con lo que las fuentes ya responden.
- [ ] Paso 4: Entrevistar al usuario sobre lo que las fuentes no responden (una sola tanda).
- [ ] Paso 5: Mostrar la intención y repetir con las correcciones hasta que el usuario confirme.
- [ ] Paso 6: Guardar docs/intent.md y devolver el control al usuario.
```

### Paso 4: entrevista

- Una pregunta por sección que falte, en este orden: Problema, Resultado esperado, Usuarios afectados,
  Restricciones. Pregunta solo lo que el enunciado y el material no responden.
- Usa `AskUserQuestion` en una sola tanda de hasta 4 preguntas, con las opciones que puedas inferir y una
  recomendada. Todo el texto en `label` y `description`, nunca en `preview`.
  Sin esa herramienta, agrupa las preguntas en texto libre.
- No propongas soluciones, pantallas ni tecnologías en las preguntas.
- Una pregunta sin respuesta pasa a `Preguntas abiertas`; no se rellena con una suposición.

### Paso 6: siguiente fase

Termina diciendo que el siguiente paso es `/spec`, que te recomendará hacer un mock del servicio en Claude Design.

## Formato de salida

- **Intención**: la ruta de `docs/intent.md` y qué cambió si se revisó.
- **Preguntas abiertas**: las que quedan, o "ninguna".
- **Siguiente paso**: `/spec`.
