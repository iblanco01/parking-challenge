$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$nodeVersion = '22.14.0'
$minNode = [version]'22.13.0'
$toolsDir = Join-Path $projectRoot 'tools\node'
$localNode = Join-Path $toolsDir 'node.exe'

# Aislamiento: todo lo que se descarga vive dentro de la carpeta del proyecto.
# Se usa siempre el Node de tools/ (nunca el del sistema) y la caché de npm local.
# Borrar la carpeta del proyecto deja el PC como estaba.
function Test-NodeVersion([string]$raw) {
  $clean = ($raw.Trim().TrimStart('v') -split '-')[0]
  return ([version]$clean) -ge $minNode
}

function Invoke-Native([scriptblock]$command) {
  & $command
  if ($LASTEXITCODE -ne 0) { throw "Fallo (código $LASTEXITCODE): $command" }
}

$hasLocalNode = (Test-Path $localNode) -and (Test-NodeVersion (& $localNode --version))
if (-not $hasLocalNode) {
  Write-Host "Descargando Node.js portable $nodeVersion..."
  $ProgressPreference = 'SilentlyContinue'
  $zipName = "node-v$nodeVersion-win-x64.zip"
  $baseUrl = "https://nodejs.org/dist/v$nodeVersion"
  $tempZip = Join-Path ([System.IO.Path]::GetTempPath()) $zipName
  Invoke-WebRequest -Uri "$baseUrl/$zipName" -OutFile $tempZip

  $sums = (Invoke-WebRequest -Uri "$baseUrl/SHASUMS256.txt" -UseBasicParsing).Content -split "`n"
  $expected = ($sums | Where-Object { $_ -match [regex]::Escape($zipName) + '\s*$' } | Select-Object -First 1) -split '\s+' | Select-Object -First 1
  if (-not $expected) { throw "No se encontró el hash de $zipName en SHASUMS256.txt" }
  # .NET directo (no depende de módulos de PowerShell y descomprime mucho más rápido que Expand-Archive).
  $sha = [System.Security.Cryptography.SHA256]::Create()
  $stream = [System.IO.File]::OpenRead($tempZip)
  try { $actual = ([System.BitConverter]::ToString($sha.ComputeHash($stream))) -replace '-', '' } finally { $stream.Dispose(); $sha.Dispose() }
  if ($actual -ne $expected.ToUpper()) { Remove-Item -Force $tempZip; throw "Hash SHA256 incorrecto para $zipName" }

  $extract = Join-Path ([System.IO.Path]::GetTempPath()) "parking-node-$nodeVersion"
  if (Test-Path $extract) { Remove-Item -Recurse -Force $extract }
  Add-Type -AssemblyName System.IO.Compression.FileSystem
  [System.IO.Compression.ZipFile]::ExtractToDirectory($tempZip, $extract)
  if (Test-Path $toolsDir) { Remove-Item -Recurse -Force $toolsDir }
  New-Item -ItemType Directory -Force $toolsDir | Out-Null
  Copy-Item -Path (Join-Path $extract "node-v$nodeVersion-win-x64\*") -Destination $toolsDir -Recurse -Force
  Remove-Item -Recurse -Force $extract, $tempZip
}

$env:PATH = "$toolsDir;$env:PATH"
$env:npm_config_cache = Join-Path $projectRoot '.npm-cache'
$env:NODE_COMPILE_CACHE = Join-Path $projectRoot '.node-compile-cache'
$env:npm_config_update_notifier = 'false'
$env:npm_config_fund = 'false'
$env:NG_CLI_ANALYTICS = 'false'

Write-Host "Usando Node: $(& $localNode --version) (tools\node)"
Push-Location $projectRoot
try {
  Invoke-Native { & (Join-Path $toolsDir 'npm.cmd') install }
  Invoke-Native { & $localNode apps/backend/scripts/reset-db.mjs }
} finally { Pop-Location }
Write-Host 'Preparación completada. Ejecuta .\start.ps1'
