# Intención (nivel 4: experto)

## Problema

Hoy las plazas de parking de la oficina de Madrid se reservan en un Microsoft Bookings ("Parking Madrid"). Hay un servicio por día de la semana ("Plaza de parking - Lunes", "Martes", "Miércoles", "Jueves"…). Cada servicio ofrece un único hueco de 9 horas que empieza a las 9:00, para las plazas 24, 25, 26, 27, 28 y 29 (6 plazas de uso compartido). El empleado elige día y hora y escribe a mano su nombre y su correo.

Con este sistema:

- Gana quien reserva primero. La plaza depende de estar atento al calendario en el momento justo, no de un criterio justo.
- Se puede automatizar o trampear: el formulario acepta cualquier nombre y correo escritos a mano, así que se puede reservar a nombre de otra persona o con scripts.
- Las plazas asignadas a un titular se quedan vacías los días que no viene, porque no hay forma de liberarlas para los demás.
- No distingue las plazas con cargador de las que no lo tienen.
- No hay consecuencias para quien reserva y no viene: la plaza se pierde para todos.
- Un administrador no puede retirar plazas de forma ordenada (obras, visitas, cesiones puntuales).
- Una vez adjudicada, una plaza se puede modificar sin control (notas: "controlar la no modificación de las plazas una vez adjudicadas").

Afecta a todos los empleados que usan el parking de Madrid, a los titulares de plazas asignadas y a quien gestiona el parking.

## Resultado esperado

Una aplicación web interna de reservas, que se plantea como reto de tecnología, en la que:

- **Titulares**: el titular de una plaza asignada marca los días que no va a ir a la oficina, y su plaza queda liberada esos días.
- **Bolsa común**: las plazas de uso compartido (hoy la 24, 25, 26, 27, 28 y 29) y las plazas liberadas por sus titulares forman una bolsa disponible para todos los empleados.
- **Solicitud semanal y asignación por el sistema**: los empleados piden plaza para los días que les interesan de la semana siguiente. Cada jueves el sistema adjudica las plazas de la semana siguiente.
- **Sin carrera por llegar primero**: la adjudicación se hace por sorteo entre todos los solicitantes, no por orden de llegada. Los que no consiguen plaza quedan en una lista de espera ordenada. Cuando una plaza queda libre después del sorteo, se asigna automáticamente al siguiente de la lista.
- **Plazas con cargador**: el sistema sabe qué plazas tienen cargador y lo tiene en cuenta al asignar.
- **Adjudicación estable**: una vez adjudicada, la plaza no se puede modificar salvo en los supuestos que se definan (ver Preguntas abiertas).
- **Validación de asistencia**: el usuario registra su llegada a la plaza con un código o con la app, para dejar constancia de que la ha usado.
- **Penalización por no presentarse**: quien tiene plaza adjudicada y no la usa queda penalizado 1 mes. Si se repite, la penalización es de 3 meses.
- **Administración**: un administrador puede retirar plazas de la bolsa disponible.

Qué se vería si funciona:

- Cada jueves, todos los solicitantes saben qué plaza tienen (o qué puesto ocupan en la lista de espera) para cada día de la semana siguiente.
- Pedir la plaza a una hora o a otra dentro del plazo no cambia la probabilidad de conseguirla.
- Las plazas de los titulares ausentes se ocupan en lugar de quedarse vacías.
- Bajan las plazas adjudicadas que acaban sin usarse.

## Usuarios y sistemas afectados

- Empleados que usan el parking de Madrid (solicitantes).
- Titulares de plazas asignadas.
- Administrador o administradores del parking (gestión de plazas, retirada de plazas, penalizaciones).
- Sistema actual: el Microsoft Bookings "Parking Madrid", al que sustituiría la aplicación (pendiente de confirmar).
- Identidad corporativa: las cuentas de empleado (Microsoft 365) como forma natural de saber quién reserva (pendiente de decidir en la spec).
- Acceso físico al parking: entrada o barrera, si se quiere validar la asistencia con ella (pendiente de ver si es viable).

## Restricciones

- **Justicia**: el sistema tiene que ser justo. Sus reglas tienen que ser explicables a cualquier empleado.
- **Sin dependencia de horarios**: conseguir plaza no puede depender de la hora a la que se pide.
- **No automatizable ni trampeable**: no se puede reservar a nombre de otro, ni con scripts, ni con varias identidades. La persona que reserva tiene que estar identificada.
- **Cadencia fija**: la asignación se hace todos los jueves para la semana siguiente.
- **Penalizaciones**: 1 mes por un no-show, 3 meses si se repite.
- **Datos personales (RGPD)**: la aplicación tratará datos de empleados (identidad, días de presencia, registro de entrada y posiblemente matrícula). El registro de asistencia es un dato de presencia del trabajador. Debe limitarse a la gestión del parking, con información previa a los empleados y validación de Compliance o el DPD antes de ponerlo en marcha.
- Hereda las políticas internas de identidad y seguridad (ENS) como cualquier aplicación corporativa.
- Fuera de alcance, salvo que se decida otra cosa: otras sedes distintas de Madrid, reserva de puestos de trabajo o salas, y cobro por el uso del parking.

## Preguntas abiertas

- **Reglas del sorteo**: ¿sorteo puro o ponderado (por ejemplo, dar más peso a quien menos plazas ha conseguido en las últimas semanas)? ¿Cómo se decide quién va primero en la lista de espera?
- **"No depender de horarios"**: ¿significa solo que no se gana por llegar primero, o también que la reserva es de día completo y no de franja horaria (hoy es un hueco de 9:00 a 18:00)?
- **Plazo de solicitud**: ¿hasta cuándo se puede pedir plaza para la semana siguiente (por ejemplo, hasta el jueves a una hora fija) y a qué hora se publica la asignación?
- **Modificaciones tras adjudicar**: ¿se puede ceder o intercambiar una plaza? ¿Se puede renunciar? ¿Hasta cuándo se puede renunciar sin penalización?
- **Penalización**: ¿qué cuenta como "no venir"? ¿No hacer el registro de entrada, o no liberar la plaza a tiempo? ¿"Más de una vez" se cuenta en qué periodo? ¿La penalización impide entrar en el sorteo o solo baja la prioridad? ¿Se aplica también a los titulares que no liberan su plaza y no vienen? ¿Hay vía de reclamación?
- **Plazas con cargador**: ¿tienen prioridad para ellas los empleados con vehículo eléctrico? ¿Se pueden asignar a vehículos de combustión si sobran?
- **Registro de entrada**: ¿es viable usar el control de acceso del parking ("ver si es posible quién entra en la entrada"), o basta un código QR en la plaza o un check-in desde la app? ¿Hasta qué hora se puede hacer el check-in antes de que la plaza pase al siguiente?
- **Inventario**: las plazas compartidas son la 24, 25, 26, 27, 28 y 29. Falta saber cuáles de ellas tienen cargador, qué plazas fijas tienen titular (para que puedan liberarse) y si el servicio incluye los viernes.
- **Titulares**: ¿con cuánta antelación deben marcar sus ausencias para que la plaza entre en el sorteo del jueves? ¿Qué pasa con las ausencias imprevistas?
- **Notificación**: ¿cómo se entera el empleado de su adjudicación o de que ha subido en la lista de espera (correo, Teams, la propia app)?
- **Gobierno**: ¿quién es el PO y quién el administrador del parking? ¿Hay que acordar las reglas con RR. HH. o con la representación de los trabajadores?
- **Convivencia con Bookings**: ¿se retira el Bookings actual al lanzar la aplicación o conviven durante un periodo?
