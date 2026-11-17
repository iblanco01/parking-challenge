$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$nodeVersion = '22.14.0'
$minNode = [version]'22.13.0'
$toolsDir = Join-Path $projectRoot 'tools\node'
$localNode = Join-Path $toolsDir 'node.exe'

function Test-NodeVersion([string]$raw) {
  $clean = ($raw.Trim().TrimStart('v') -split '-')[0]
  return ([version]$clean) -ge $minNode
}

function Get-NodeCommand {
  if ((Test-Path $localNode) -and (Test-NodeVersion (& $localNode --version))) { return $localNode }
  $systemNode = Get-Command node -ErrorAction SilentlyContinue
  if ($systemNode -and (Test-NodeVersion (& node --version))) { return $systemNode.Source }
  return $null
}

function Invoke-Native([scriptblock]$command) {
  & $command
  if ($LASTEXITCODE -ne 0) { throw "Fallo (código $LASTEXITCODE): $command" }
}

$node = Get-NodeCommand
if (-not $node) {
  Write-Host "Descargando Node.js portable $nodeVersion..."
  $ProgressPreference = 'SilentlyContinue'
  $zipName = "node-v$nodeVersion-win-x64.zip"
  $baseUrl = "https://nodejs.org/dist/v$nodeVersion"
  $tempZip = Join-Path ([System.IO.Path]::GetTempPath()) $zipName
  Invoke-WebRequest -Uri "$baseUrl/$zipName" -OutFile $tempZip

  $sums = (Invoke-WebRequest -Uri "$baseUrl/SHASUMS256.txt" -UseBasicParsing).Content -split "`n"
  $expected = ($sums | Where-Object { $_ -match [regex]::Escape($zipName) + '\s*$' } | Select-Object -First 1) -split '\s+' | Select-Object -First 1
  if (-not $expected) { throw "No se encontró el hash de $zipName en SHASUMS256.txt" }
  $actual = (Get-FileHash -Algorithm SHA256 $tempZip).Hash
  if ($actual -ne $expected.ToUpper()) { Remove-Item -Force $tempZip; throw "Hash SHA256 incorrecto para $zipName" }

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
  Invoke-Native { & $npm install }
  Invoke-Native { & $node apps/backend/scripts/reset-db.mjs }
} finally { Pop-Location }
Write-Host 'Preparación completada. Ejecuta .\start.ps1'
