#!/usr/bin/env bash
set -euo pipefail

if command -v powershell.exe >/dev/null 2>&1; then
  powershell.exe -NoProfile -Command "& {
    \$cmd = Get-Command syncthing.exe -ErrorAction SilentlyContinue
    if (-not \$cmd) { throw 'syncthing.exe was not found on PATH. Install it with Scoop or MSYS2 first.' }
    Start-Process -FilePath \$cmd.Source -WindowStyle Hidden
  }"
elif command -v syncthing >/dev/null 2>&1; then
  nohup syncthing >/dev/null 2>&1 &
else
  echo "syncthing was not found on PATH." >&2
  exit 1
fi

echo "Syncthing started."
