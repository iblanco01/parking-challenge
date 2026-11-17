# Intención (nivel 1: básico)

## Problema

Las plazas de parking de la oficina se reservan hoy por correo o a mano, sin saber cuántas quedan cada día. Dos personas pueden pedir la misma plaza y nadie sabe qué días están libres hasta preguntar.

Afecta a los empleados que usan el parking y a quien lo gestiona.

## Resultado esperado

Una aplicación web de reservas por día completo en la que el empleado:

- Ve los próximos días y cuántas plazas quedan en cada uno.
- Reserva un día indicando su nombre, su correo y una nota opcional.
- Consulta sus reservas.
- Cancela una reserva.

Se vería que funciona si nadie puede reservar un día completo y cada empleado ve sus reservas.

## Usuarios y sistemas afectados

- Empleados que reservan.
- Quien gestiona el parking, que solo consulta la ocupación.

## Restricciones

- La reserva es de día completo, no por franjas horarias.
- Algunos días no están habilitados y otros pueden estar completos.
- La información persiste en base de datos.
- Usable desde escritorio y móvil.
- Fuera de alcance: identidad corporativa, pagos y otras sedes.

## Preguntas abiertas

- ¿Cuántas plazas hay cada día y cuántos días hacia delante se puede reservar?
- ¿Se puede reservar más de un día, o dos veces el mismo día con el mismo correo?
- ¿Cómo se identifica a la persona, solo por el correo que escribe?
