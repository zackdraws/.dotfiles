#!/usr/bin/env bash
set -euo pipefail

if command -v powershell.exe >/dev/null 2>&1; then
  powershell.exe -NoProfile -Command "Stop-Process -Name syncthing -Force -ErrorAction SilentlyContinue"
elif command -v pkill >/dev/null 2>&1; then
  pkill -x syncthing 2>/dev/null || true
else
  echo "No supported process stopper found. Install PowerShell/MSYS2 or procps." >&2
  exit 1
fi

echo "Syncthing stopped if it was running."
