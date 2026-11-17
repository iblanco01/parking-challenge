# <Descripción en una línea del cambio>

## Resumen

<Para quien no lea nada más, en lenguaje llano: qué cambia y por qué, las decisiones clave y el efecto visible.
Sin rutas, código ni jerga; unos pocos párrafos o viñetas cortas.>

## Contexto

<El problema y el resultado buscado, en dos o tres frases.>

## Decisiones

- <Una decisión de la especificación que condiciona las tareas, una respuesta de la entrevista o una suposición.
  Una suposición por pregunta sin respuesta se etiqueta "Suposición:".>

## Enfoque

<El enfoque de la especificación y el diseño técnico que lo desarrolla: funcionalidades y su responsabilidad.>

### Modelo de datos

<Tablas, columnas, claves, restricciones e índices que crea `apps/backend/scripts/reset-db.mjs`, en prosa o lista.>

### API

<Una viñeta por endpoint: método y ruta, entrada, respuesta y errores (códigos HTTP y mensaje).>

### Errores

<Cómo se validan las entradas y qué error recibe el cliente en cada caso.>

### Alternativas descartadas

- <Alternativa de la especificación>: <motivo en una línea.>

## Criterios de aceptación

- AC1: <Un criterio de la especificación: qué se comprueba y el resultado esperado.>

## Fuera de alcance

<Lo que el plan deja fuera a propósito y por qué, o "nada".>

## Tareas

### Tarea 1: <Qué entrega la tarea>

- Cubre: <los criterios de aceptación que cumple, p. ej. `AC1, AC2`, o `ninguno` para una tarea de apoyo>.
- Ficheros: `<ruta>` (crear), `<ruta>` (`<función, clase o método>`, modificar).
- Reutiliza: `<función, clase o utilidad>` de `<ruta>`.
- Diseño: <los artboards del mock en Claude Design que implementa la tarea; borra la línea si la tarea no tiene interfaz>.
- Cambios: <qué cambia en cada fichero y por qué, en prosa, nunca código. Nombra el comportamiento, lo que se añade
  o renombra y los contratos que cambian>.
- Tests: <los casos de test que se añaden o actualizan y en qué fichero `*.spec.mjs`: comportamiento, límites y errores>.
- Verificación: `<comando>`, esperado: <resultado>.

### Tarea 2: <Qué entrega la tarea>

<Los mismos campos que la Tarea 1, un bloque por tarea y en el orden en que se ejecutan.>

## Riesgos

- <Qué podría romperse>: <cómo se mitiga.>

## Verificación

- `<comando>`: <resultado esperado.>
- <Comprobación de extremo a extremo que necesita más que un comando, paso a paso.>
