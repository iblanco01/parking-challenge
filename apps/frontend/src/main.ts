import { bootstrapApplication } from '@angular/platform-browser';
import { Component } from '@angular/core';
import { provideHttpClient } from '@angular/common/http';

@Component({ selector: 'app-root', standalone: true, template: `
  <main class="shell">
    <h1>Parking Challenge</h1>
    <p>Aplicación inicial preparada para el equipo.</p>
    <h2>Cómo empezar</h2>
    <ol>
      <li>Abre Claude Desktop y entra en la pestaña <strong>Code</strong>.</li>
      <li>Pulsa para elegir carpeta y selecciona la raíz del repo, la que contiene <code>AGENTS.md</code> y <code>.claude/</code>. No elijas <code>apps/</code> ni la carpeta que contiene el repo.</li>
      <li>Si te pide confiar en la carpeta, acepta. Sin esa confianza las skills del proyecto no se cargan.</li>
      <li>Escribe <code>/</code> en el cuadro de mensaje. Deben aparecer <code>intent</code>, <code>spec</code>, <code>plan</code>, <code>build</code>, <code>document</code> y <code>finish</code>.</li>
      <li>Empieza por <code>/intent</code>; después sigue con <code>/spec</code>, <code>/plan</code>, <code>/build</code>, <code>/document</code> y <code>/finish</code>.</li>
    </ol>
  </main>
` })
class AppComponent {}
bootstrapApplication(AppComponent, { providers: [provideHttpClient()] });
