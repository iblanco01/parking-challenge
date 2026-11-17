# Intención (nivel 3: avanzado)

## Problema

Las plazas de parking de la oficina las gana quien reserva primero. Eso depende de estar atento en el momento justo, no de un criterio justo, y quien no viene tampoco sufre ninguna consecuencia.

Afecta a los empleados, a los titulares de plazas fijas y a quien gestiona el parking.

## Resultado esperado

Una aplicación web de reservas semanales en la que:

- Los empleados piden plaza para los días que quieren de la semana siguiente, hasta un plazo fijo.
- Cada semana el sistema adjudica las plazas por sorteo entre los solicitantes, sin tener en cuenta el orden de llegada.
- Quien no consigue plaza queda en una lista de espera ordenada, y cuando se libera una plaza pasa al siguiente.
- El titular de una plaza marca los días que no va, y esa plaza entra en el sorteo.
- Un administrador puede retirar plazas.
- Cada empleado ve su plaza o su puesto en la lista de espera para cada día.

Se vería que funciona si pedir antes o después dentro del plazo no cambia la probabilidad de conseguir plaza.

## Usuarios y sistemas afectados

- Empleados que solicitan.
- Titulares de plazas fijas.
- Administrador del parking.

## Restricciones

- El sorteo tiene que ser explicable a cualquier empleado.
- La asignación se hace una vez por semana, en un día fijo.
- La información persiste en base de datos.
- Usable desde escritorio y móvil.
- Fuera de alcance: registro de entrada, penalizaciones, plazas con cargador y otras sedes.

## Preguntas abiertas

- ¿Sorteo puro o ponderado por las plazas conseguidas en semanas anteriores?
- ¿Hasta cuándo se puede pedir y cuándo se publica el resultado?
- ¿Se puede renunciar a una plaza adjudicada, y hasta cuándo?
- ¿Cómo se ordena la lista de espera?
- ¿Cómo se entera el empleado del resultado?
