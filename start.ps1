$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$toolsDir = Join-Path $projectRoot 'tools\node'
$localNode = Join-Path $toolsDir 'node.exe'
if (-not (Test-Path $localNode)) { throw 'No hay Node portable en tools\node. Ejecuta primero .\bootstrap.ps1' }

# Mismo aislamiento que bootstrap.ps1: Node de tools/ y caché de npm dentro del proyecto.
$env:PATH = "$toolsDir;$env:PATH"
$env:npm_config_cache = Join-Path $projectRoot '.npm-cache'
$env:NODE_COMPILE_CACHE = Join-Path $projectRoot '.node-compile-cache'
$env:npm_config_update_notifier = 'false'
$env:NG_CLI_ANALYTICS = 'false'

Push-Location $projectRoot
try {
  if (-not (Test-Path 'data\parking.sqlite')) {
    & $localNode apps/backend/scripts/reset-db.mjs
    if ($LASTEXITCODE -ne 0) { throw 'No se pudo crear la base de datos.' }
  }
  & (Join-Path $toolsDir 'npm.cmd') run dev
  if ($LASTEXITCODE -ne 0) { throw "npm run dev terminó con código $LASTEXITCODE" }
} finally { Pop-Location }
