$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$nodeVersion = '22.14.0'
$toolsDir = Join-Path $projectRoot 'tools\node'
$localNode = Join-Path $toolsDir 'node.exe'

function Get-NodeCommand {
  if (Test-Path $localNode) { return $localNode }
  $systemNode = Get-Command node -ErrorAction SilentlyContinue
  if ($systemNode) {
    $major = [int]((& node --version).Trim().TrimStart('v').Split('.')[0])
    if ($major -ge 22) { return 'node' }
  }
  return $null
}

$node = Get-NodeCommand
if (-not $node) {
  Write-Host "Descargando Node.js portable $nodeVersion..."
  $tempZip = Join-Path ([System.IO.Path]::GetTempPath()) "node-v$nodeVersion-win-x64.zip"
  $url = "https://nodejs.org/dist/v$nodeVersion/node-v$nodeVersion-win-x64.zip"
  Invoke-WebRequest -Uri $url -OutFile $tempZip
  $extract = Join-Path ([System.IO.Path]::GetTempPath()) "parking-node-$nodeVersion"
  if (Test-Path $extract) { Remove-Item -Recurse -Force $extract }
  Expand-Archive -Path $tempZip -DestinationPath $extract
  New-Item -ItemType Directory -Force $toolsDir | Out-Null
  Copy-Item -Path (Join-Path $extract "node-v$nodeVersion-win-x64\*") -Destination $toolsDir -Recurse -Force
  Remove-Item -Recurse -Force $extract, $tempZip
  $node = $localNode
}

$npm = Join-Path (Split-Path -Parent $node) 'npm.cmd'
Write-Host "Usando Node: $(& $node --version)"
Push-Location $projectRoot
try {
  & $npm install
  & $npm --prefix apps/frontend install
  & $node apps/backend/scripts/reset-db.mjs
} finally { Pop-Location }
Write-Host 'Preparación completada. Ejecuta .\start.ps1'
