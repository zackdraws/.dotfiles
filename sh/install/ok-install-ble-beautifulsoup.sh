#!/usr/bin/env bash
# Install Beautiful Soup into the per-user modules directory of a Blender install.
# Usage: BLENDER_EXE='/c/Program Files/Blender Foundation/Blender 5.2/blender.exe' \
#          ./ok-install-blender-beautifulsoup.sh

set -euo pipefail

if [[ -n "${BLENDER_EXE:-}" ]]; then
  blender="$BLENDER_EXE"
elif command -v blender >/dev/null 2>&1; then
  blender="$(command -v blender)"
else
  candidates=(
    "/c/Program Files/Blender Foundation/Blender 5.2/blender.exe"
    "/c/Program Files (x86)/Steam/steamapps/common/Blender/blender.exe"
  )

  blender=""
  for candidate in "${candidates[@]}"; do
    if [[ -x "$candidate" ]]; then
      blender="$candidate"
      break
    fi
  done
fi

if [[ -z "${blender:-}" || ! -x "$blender" ]]; then
  echo "Blender was not found. Set BLENDER_EXE to its blender.exe path." >&2
  exit 1
fi

echo "Installing beautifulsoup4 for: $blender"
"$blender" --background --python-expr '
import bpy
import subprocess
import sys
from pathlib import Path

modules_dir = Path(bpy.utils.user_resource("SCRIPTS", path="addons/modules", create=True))
subprocess.check_call([
    sys.executable, "-m", "pip", "install", "--upgrade", "--target",
    str(modules_dir), "beautifulsoup4",
])
import bs4
print(f"Installed beautifulsoup4 {bs4.__version__} in {modules_dir}")
' --python-exit-code 1
