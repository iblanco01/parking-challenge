$ErrorActionPreference = 'Stop'
$minVersion = [version]'22.13.0'
$node = Get-Command node -ErrorAction SilentlyContinue
if (-not $node) { throw 'Node.js no está instalado. Ejecuta .\bootstrap.ps1.' }
$version = (& node --version).Trim().TrimStart('v')
if ([version](($version -split '-')[0]) -lt $minVersion) { throw "Se requiere Node.js $minVersion o superior. Detectado: $version" }
Write-Host "Node.js $version OK"
Write-Host 'Preflight OK'
