#!/usr/bin/env bash
# Equivalente de bootstrap.ps1 para Linux, WSL y macOS.
# Uso: bash ./bootstrap.sh
#
# Aislamiento: todo lo que se descarga vive dentro de la carpeta del proyecto.
# Se usa siempre el Node de tools/ (nunca el del sistema) y la caché de npm local.
# Borrar la carpeta del proyecto deja el equipo como estaba.
set -euo pipefail
cd "$(dirname "$0")"

NODE_VERSION=22.14.0

die() { echo "Error: $*" >&2; exit 1; }

case "$(uname -s)" in
  Linux) platform=linux ;;
  Darwin) platform=darwin ;;
  *) die "Sistema no soportado: $(uname -s). En Windows usa .\\bootstrap.ps1" ;;
esac
case "$(uname -m)" in
  x86_64|amd64) arch=x64 ;;
  arm64|aarch64) arch=arm64 ;;
  *) die "Arquitectura no soportada: $(uname -m)" ;;
esac

# Node >= 22.13 (node:sqlite sin flag).
node_ok() {
  [ -x "$1" ] || return 1
  "$1" -e 'const [a,b]=process.versions.node.split(".").map(Number);process.exit(a>22||(a===22&&b>=13)?0:1)' 2>/dev/null
}

portable_dir="tools/node-$platform-$arch"

if ! node_ok "$portable_dir/bin/node"; then
  command -v curl >/dev/null || die "Hace falta curl para descargar Node."
  command -v tar >/dev/null || die "Hace falta tar para descomprimir Node."
  name="node-v$NODE_VERSION-$platform-$arch"
  base="https://nodejs.org/dist/v$NODE_VERSION"
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  echo "Descargando Node.js portable $NODE_VERSION ($platform-$arch)..."
  curl -fsSL "$base/$name.tar.gz" -o "$tmp/$name.tar.gz"
  curl -fsSL "$base/SHASUMS256.txt" -o "$tmp/SHASUMS256.txt"
  expected="$(grep " $name.tar.gz\$" "$tmp/SHASUMS256.txt" | awk '{print $1}')"
  [ -n "$expected" ] || die "No se encontró el hash de $name.tar.gz"
  if command -v sha256sum >/dev/null; then actual="$(sha256sum "$tmp/$name.tar.gz" | awk '{print $1}')"
  else actual="$(shasum -a 256 "$tmp/$name.tar.gz" | awk '{print $1}')"; fi
  [ "$actual" = "$expected" ] || die "Hash SHA256 incorrecto para $name.tar.gz"
  rm -rf "$portable_dir"
  mkdir -p "$portable_dir"
  tar -xzf "$tmp/$name.tar.gz" -C "$portable_dir" --strip-components=1
fi

export PATH="$(cd "$portable_dir/bin" && pwd):$PATH"
export npm_config_cache="$PWD/.npm-cache"
export NODE_COMPILE_CACHE="$PWD/.node-compile-cache"
export npm_config_update_notifier=false
export npm_config_fund=false
export NG_CLI_ANALYTICS=false

echo "Usando Node: $(node --version) ($portable_dir)"
npm install   # instala también las dependencias de Angular (postinstall)
node apps/backend/scripts/reset-db.mjs
echo "Preparación completada. Ejecuta: bash ./start.sh"
