$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$localNode = Join-Path $projectRoot 'tools\node\node.exe'
$node = if (Test-Path $localNode) { $localNode } else { (Get-Command node -ErrorAction Stop).Source }
$npm = Join-Path (Split-Path -Parent $node) 'npm.cmd'
Push-Location $projectRoot
try {
  if (-not (Test-Path 'data\parking.sqlite')) { & $node apps/backend/scripts/reset-db.mjs }
  & $npm run dev
} finally { Pop-Location }
