#!/usr/bin/env bash
set -euo pipefail

if [ ! -f notes.org ]; then
  echo "notes.org not found in the current directory." >&2
  exit 1
fi

if [ ! -x ./gen_tex.sh ]; then
  echo "./gen_tex.sh not found or not executable in the current directory." >&2
  exit 1
fi

output="$(grep -E '/mnt/.+\.(jpg|jpeg|png|pdf|eps)' notes.org | ./gen_tex.sh)"

if command -v clip.exe >/dev/null 2>&1; then
  printf '%s' "$output" | clip.exe
elif command -v wl-copy >/dev/null 2>&1; then
  printf '%s' "$output" | wl-copy
elif command -v xclip >/dev/null 2>&1; then
  printf '%s' "$output" | xclip -selection clipboard
else
  printf '%s\n' "$output"
fi
