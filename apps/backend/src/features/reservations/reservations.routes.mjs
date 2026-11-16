import { db } from '../../db.mjs';

function required(value) { return typeof value === 'string' && value.trim().length > 0; }

export function registerReservationRoutes(router) {
  router.get('/api/reservations', (request, response) => {
    const email = new URL(request.url, 'http://localhost').searchParams.get('email');
    if (!email) return response.error(400, 'El correo es obligatorio');
    response.json(db.prepare(`
      SELECT r.*, d.date, d.weekday FROM reservations r
      JOIN parking_days d ON d.id = r.parking_day_id
      WHERE lower(r.email) = lower(?) ORDER BY d.date
    `).all(email));
  });

  router.post('/api/reservations', (request, response) => {
    const { parkingDayId, fullName, email, note = '' } = request.body ?? {};
    if (!parkingDayId || !required(fullName) || !required(email)) return response.error(400, 'Día, nombre y correo son obligatorios');
    const day = db.prepare('SELECT * FROM parking_days WHERE id = ? AND enabled = 1').get(parkingDayId);
    if (!day) return response.error(404, 'Día no disponible');
    const used = db.prepare("SELECT COUNT(*) AS total FROM reservations WHERE parking_day_id = ? AND status = 'CONFIRMED'").get(parkingDayId).total;
    if (used >= day.capacity) return response.error(409, 'No quedan plazas disponibles');
    const duplicate = db.prepare("SELECT id FROM reservations WHERE parking_day_id = ? AND lower(email) = lower(?) AND status = 'CONFIRMED'").get(parkingDayId, email);
    if (duplicate) return response.error(409, 'Ya existe una reserva para ese correo');
    const result = db.prepare('INSERT INTO reservations (parking_day_id, full_name, email, note) VALUES (?, ?, ?, ?)').run(parkingDayId, fullName.trim(), email.trim(), note.trim());
    db.prepare('INSERT INTO notifications (email, subject, body) VALUES (?, ?, ?)').run(email.trim(), 'Confirmación de reserva', `Reserva confirmada para ${day.date}`);
    response.status(201).json({ id: Number(result.lastInsertRowid), message: 'Reserva confirmada' });
  });

  router.post('/api/reservations/:id/cancel', (request, response) => {
    const reservation = db.prepare("SELECT * FROM reservations WHERE id = ? AND status = 'CONFIRMED'").get(request.params.id);
    if (!reservation) return response.error(404, 'Reserva no encontrada');
    db.prepare("UPDATE reservations SET status = 'CANCELLED' WHERE id = ?").run(request.params.id);
    db.prepare('INSERT INTO notifications (email, subject, body) VALUES (?, ?, ?)').run(reservation.email, 'Cancelación de reserva', `Reserva cancelada: ${request.params.id}`);
    response.json({ message: 'Reserva cancelada' });
  });
}
