#!/usr/bin/env bash
# Equivalente de bootstrap.ps1 para Linux, WSL y macOS.
# Uso: bash ./bootstrap.sh
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

# Node >= 22.13 (node:sqlite sin flag). En WSL se ignora el node de Windows (/mnt/...).
node_ok() {
  [ -x "$1" ] || return 1
  "$1" -e 'const [a,b]=process.versions.node.split(".").map(Number);process.exit(a>22||(a===22&&b>=13)?0:1)' 2>/dev/null
}

portable_dir="tools/node-$platform-$arch"
node_bin=""
if node_ok "$portable_dir/bin/node"; then
  node_bin="$portable_dir/bin/node"
else
  system_node="$(command -v node || true)"
  case "$system_node" in /mnt/*) system_node="" ;; esac
  if [ -n "$system_node" ] && node_ok "$system_node"; then node_bin="$system_node"; fi
fi

if [ -z "$node_bin" ]; then
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
  node_bin="$portable_dir/bin/node"
fi

node_dir="$(cd "$(dirname "$node_bin")" && pwd)"
export PATH="$node_dir:$PATH"
echo "Usando Node: $(node --version)"
npm install   # instala también las dependencias de Angular (postinstall)
node apps/backend/scripts/reset-db.mjs
echo "Preparación completada. Ejecuta: bash ./start.sh"
