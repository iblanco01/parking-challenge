#!/usr/bin/env bash
# Equivalente de start.ps1 para Linux, WSL y macOS.
# Uso: bash ./start.sh
set -euo pipefail
cd "$(dirname "$0")"

case "$(uname -s)" in Linux) platform=linux ;; Darwin) platform=darwin ;; *) platform=unknown ;; esac
case "$(uname -m)" in x86_64|amd64) arch=x64 ;; arm64|aarch64) arch=arm64 ;; *) arch=unknown ;; esac

portable="tools/node-$platform-$arch/bin"
[ -x "$portable/node" ] || { echo "No hay Node portable en $portable. Ejecuta primero: bash ./bootstrap.sh" >&2; exit 1; }

# Mismo aislamiento que bootstrap.sh: Node de tools/ y caché de npm dentro del proyecto.
export PATH="$(cd "$portable" && pwd):$PATH"
export npm_config_cache="$PWD/.npm-cache"
export NODE_COMPILE_CACHE="$PWD/.node-compile-cache"
export npm_config_update_notifier=false
export NG_CLI_ANALYTICS=false

[ -f data/parking.sqlite ] || node apps/backend/scripts/reset-db.mjs
exec npm run dev
