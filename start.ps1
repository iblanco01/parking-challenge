$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$localNode = Join-Path $projectRoot 'tools\node\node.exe'
$node = if (Test-Path $localNode) { $localNode } else { (Get-Command node -ErrorAction Stop).Source }
$npm = Join-Path (Split-Path -Parent $node) 'npm.cmd'
Push-Location $projectRoot
try {
  if (-not (Test-Path 'data\parking.sqlite')) {
    & $node apps/backend/scripts/reset-db.mjs
    if ($LASTEXITCODE -ne 0) { throw 'No se pudo crear la base de datos.' }
  }
  & $npm run dev
  if ($LASTEXITCODE -ne 0) { throw "npm run dev terminó con código $LASTEXITCODE" }
} finally { Pop-Location }
