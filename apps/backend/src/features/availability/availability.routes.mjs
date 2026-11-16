import { db } from '../../db.mjs';

export function registerAvailabilityRoutes(router) {
  router.get('/api/parking-days', (_request, response) => {
    const days = db.prepare(`
      SELECT d.*, d.capacity - COUNT(CASE WHEN r.status = 'CONFIRMED' THEN 1 END) AS remaining
      FROM parking_days d LEFT JOIN reservations r ON r.parking_day_id = d.id
      GROUP BY d.id ORDER BY d.date
    `).all();
    response.json(days);
  });
}
