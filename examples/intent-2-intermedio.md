# Intención (nivel 2: intermedio)

## Problema

Las plazas de parking de la oficina se reservan por orden de llegada y no hay forma de ordenar su uso:

- Las plazas de los titulares se quedan vacías los días que no vienen.
- No se distinguen las plazas con cargador de las que no lo tienen.
- Quien gestiona el parking no puede retirar plazas o días (obras, visitas) sin avisar uno a uno.

Afecta a los empleados, a los titulares de plazas fijas y a quien gestiona el parking.

## Resultado esperado

Una aplicación web de reservas por día completo en la que:

- El empleado ve los próximos días con las plazas libres, reserva, consulta y cancela sus reservas.
- El titular de una plaza marca los días que no va a ir, y su plaza pasa a estar disponible para los demás ese día.
- El empleado puede indicar que necesita plaza con cargador, y solo se le ofrecen las que lo tienen.
- Un administrador puede bloquear un día o una plaza, y no se admiten nuevas reservas sobre ellos.

Se vería que funciona si las plazas de los titulares ausentes se ocupan y las plazas bloqueadas no se pueden reservar.

## Usuarios y sistemas afectados

- Empleados que reservan.
- Titulares de plazas fijas.
- Administrador del parking.

## Restricciones

- La reserva es de día completo y se atiende por orden de llegada (sin sorteo).
- Una plaza no puede estar reservada por dos personas el mismo día.
- La información persiste en base de datos.
- Usable desde escritorio y móvil.
- Fuera de alcance: sorteo, lista de espera, penalizaciones, registro de entrada y otras sedes.

## Preguntas abiertas

- ¿Cuántas plazas hay, cuáles tienen cargador y cuáles son de titular?
- ¿Cómo se distingue a un titular o a un administrador de un empleado normal?
- Si un titular libera un día cuando ya alguien lo ha ocupado, ¿qué pasa?
- ¿Qué ocurre con las reservas que ya existen cuando el administrador bloquea ese día?
