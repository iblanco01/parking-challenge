import { bootstrapApplication } from '@angular/platform-browser';
import { Component } from '@angular/core';
import { provideHttpClient } from '@angular/common/http';

@Component({ selector: 'app-root', standalone: true, template: `
  <main class="shell">
    <h1>Parking Challenge</h1>
    <p>Aplicación inicial preparada para el equipo.</p>
    <p>Empieza definiendo la solución con <code>/spec</code>.</p>
  </main>
` })
class AppComponent {}
bootstrapApplication(AppComponent, { providers: [provideHttpClient()] });
