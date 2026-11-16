import { bootstrapApplication } from '@angular/platform-browser';
import { Component, inject } from '@angular/core';
import { HttpClient, provideHttpClient } from '@angular/common/http';
import { CommonModule } from '@angular/common';
import { firstValueFrom } from 'rxjs';

type Day = { id: number; date: string; weekday: string; capacity: number; enabled: number; remaining: number };

@Component({ selector: 'app-root', standalone: true, imports: [CommonModule], template: `
  <main class="shell"><h1>Reserva de parking</h1><p>Selecciona un día disponible para reservar una plaza.</p>
  <section class="days"><button *ngFor="let day of days" [disabled]="!day.enabled || day.remaining <= 0" (click)="selected = day" [class.selected]="selected?.id === day.id"><strong>{{day.weekday}}</strong><span>{{day.date}}</span><small>{{day.enabled ? (day.remaining + ' plazas libres') : 'No disponible'}}</small></button></section>
  <section *ngIf="selected" class="card"><h2>{{selected.weekday}} {{selected.date}}</h2><label>Nombre completo<input #name></label><label>Correo electrónico<input #email type="email"></label><label>Nota opcional<textarea #note></textarea></label><button class="primary" (click)="reserve(name.value, email.value, note.value)">Reservar plaza</button><p class="message" *ngIf="message">{{message}}</p></section></main>
`, styles: [] })
class AppComponent {
  private http = inject(HttpClient); days: Day[] = []; selected?: Day; message = '';
  constructor() { this.load(); }
  async load() { this.days = await firstValueFrom(this.http.get<Day[]>('/api/parking-days')); }
  async reserve(fullName: string, email: string, note: string) { try { const body = { parkingDayId: this.selected?.id, fullName, email, note }; await firstValueFrom(this.http.post('/api/reservations', body)); this.message = 'Reserva confirmada'; await this.load(); } catch { this.message = 'No se ha podido realizar la reserva'; } }
}
bootstrapApplication(AppComponent, { providers: [provideHttpClient()] });
