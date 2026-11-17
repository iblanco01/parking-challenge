#!/usr/bin/env bash
# Equivalente de start.ps1 para Linux, WSL y macOS.
# Uso: bash ./start.sh
set -euo pipefail
cd "$(dirname "$0")"

case "$(uname -s)" in Linux) platform=linux ;; Darwin) platform=darwin ;; *) platform=unknown ;; esac
case "$(uname -m)" in x86_64|amd64) arch=x64 ;; arm64|aarch64) arch=arm64 ;; *) arch=unknown ;; esac

portable="tools/node-$platform-$arch/bin"
if [ -x "$portable/node" ]; then
  export PATH="$(cd "$portable" && pwd):$PATH"
fi
command -v node >/dev/null || { echo "Node no encontrado. Ejecuta: bash ./bootstrap.sh" >&2; exit 1; }

[ -f data/parking.sqlite ] || node apps/backend/scripts/reset-db.mjs
exec npm run dev
