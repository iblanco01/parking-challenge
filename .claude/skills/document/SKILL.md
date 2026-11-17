---
name: document
description: >
  Escribe en docs/ y en el README lo que la aplicación entrega hoy y por qué: funcionalidades, modelo de datos, API,
  reglas de negocio y cómo ejecutarla. Explora el código, entrevista al usuario sobre el porqué y escribe las páginas.
  Úsala cuando el usuario pida /document o documentar lo construido.
user-invocable: true
---

# Documentar

Escribe el resultado del proyecto, lo que existe y hace hoy, sacado del código, y su porqué, sacado del usuario.
Nunca el cómo: eso es el código. La leen personas para trabajar en el proyecto y futuras sesiones de IA para
planificar cambios.

## Requisitos

- `AGENTS.md` leído y el código construido (tras `build`).
- `docs/spec.md` y `docs/plan.md` como fuente de los porqués ya decididos.

## Reglas

- Solo escribes en `docs/` y el `README.md`. Nunca editas código, `AGENTS.md`, `docs/challenge.md`,
  `docs/spec.md` ni `docs/plan.md`.
- Describe el proyecto como es hoy, nunca intenciones. Cada página nombra la ruta que define cada elemento.
- Nunca infieras un porqué: escribe lo que dijo una persona (la entrevista, la especificación, el plan).
  Un porqué sin respuesta se escribe como `TBD` en la sección `## Por qué` de su página y se lista en `Pendiente`.
- Ordena de lo general a lo específico y de lo funcional a lo técnico, en páginas, secciones y listas.
  Cada página abre con un resumen de su tema.
- Escribe para una IA y una persona a la vez: explícito sobre implícito, sin depender de la conversación,
  rutas, símbolos y comandos en código en línea, sin pronombres ambiguos ni jerga sin explicar.
- Cada cosa se dice una vez: enlaza a la página que la contiene. Cita por su `BRn` una regla de negocio,
  no la copies.
- Enlaces relativos entre páginas y diagramas como bloques `mermaid`. Sin tablas.
- Nunca escribas valores secretos ni datos personales reales: nombra el secreto y dónde se guarda.
- Cambia solo lo obsoleto o lo que falta; no reescribas secciones ajenas. Una página movida o borrada no deja
  enlaces rotos (busca su ruta en todo el repositorio).
- Entrevista en el idioma de la sesión; escribe en español de España.

## Cómo operar

```text
Progreso de document:
- [ ] Paso 1: Fijar el alcance (la página o área que dé el usuario, o todo docs/).
- [ ] Paso 2: Explorar el código del alcance en solo lectura.
- [ ] Paso 3: Proponer las páginas y sus huecos (los porqués que solo sabe una persona).
- [ ] Paso 4: Entrevistar al usuario sobre los huecos y confirmar las páginas.
- [ ] Paso 5: Escribir las páginas.
- [ ] Paso 6: Verificar rutas, enlaces y comandos.
- [ ] Paso 7: Devolver el control al usuario.
```

### Paso 3: páginas propuestas

Propón solo las que el código justifica, por ejemplo: visión general y funcionalidades (`docs/overview.md`),
modelo de datos (`docs/data-model.md`), API (`docs/api.md`), reglas de negocio implementadas
(`docs/business-rules.md` ya existe: actualízala, no la dupliques) y la sección de arranque del `README.md`.
Para cada una, redacta lo que el código responde citando su origen y lista como hueco el porqué de cada
decisión: propósito, alternativas descartadas y restricciones.

### Paso 4: entrevista

- Preguntas cerradas con `AskUserQuestion`, hasta 4 por tanda, con las opciones vistas y un valor recomendado.
  Todo el texto en `label` y `description`, nunca en `preview`. Las abiertas, agrupadas en texto libre.
- Nunca una pregunta suelta, ni lo que el código ya responde.
- El usuario puede saltarse un porqué: queda como `TBD`.
- Muestra las páginas a crear o cambiar con un resumen de una línea y confirma una vez antes de escribir.

### Paso 6: verificación

- Cada ruta, símbolo y comando que cita una página existe (`rg`, `ls`) y cada enlace relativo apunta a un fichero.
- Los comandos del README se ejecutan tal cual (`npm test`, `npm run build`) o se indica que no se pudo.
- Un fallo que las páginas no causan se anota en `Pendiente`; no se arregla fuera de `docs/` y el README.

## Formato de salida

- **Páginas**: creadas o actualizadas, con una línea de motivo cada una.
- **Comprobaciones**: qué se verificó y el resultado real.
- **Incidencias**: errores o incoherencias del código vistos al leer, sin corregir, o "ninguna".
- **Pendiente**: porqués sin respuesta (`TBD`) y otros huecos, o "ninguno".
