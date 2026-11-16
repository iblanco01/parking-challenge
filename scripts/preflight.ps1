$ErrorActionPreference = 'Stop'
$requiredMajor = 22
$node = Get-Command node -ErrorAction SilentlyContinue
if (-not $node) { throw 'Node.js no está instalado. Ejecuta .\bootstrap.ps1.' }
$version = (& node --version).Trim().TrimStart('v')
$major = [int]($version.Split('.')[0])
if ($major -lt $requiredMajor) { throw "Se requiere Node.js $requiredMajor o superior. Detectado: $version" }
Write-Host "Node.js $version OK"
Write-Host 'Preflight OK'
