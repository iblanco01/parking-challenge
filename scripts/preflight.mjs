const [major, minor] = process.versions.node.split('.').map(Number);
if (major < 22 || (major === 22 && minor < 13)) {
  console.error(`Se requiere Node.js 22.13 o superior. Detectado: ${process.versions.node}`);
  process.exit(1);
}
console.log(`Node.js ${process.versions.node} OK`);
console.log('Preflight OK');
