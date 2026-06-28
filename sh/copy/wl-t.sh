#!/usr/bin/env bash
set -euo pipefail

if [ "${1:-}" = "" ]; then
  echo "Please provide a file to copy." >&2
  exit 1
fi

if [ ! -f "$1" ]; then
  echo "File not found: $1" >&2
  exit 1
fi

if command -v wl-copy >/dev/null 2>&1; then
  wl-copy < "$1"
elif command -v clip.exe >/dev/null 2>&1; then
  clip.exe < "$1"
elif command -v xclip >/dev/null 2>&1; then
  xclip -selection clipboard < "$1"
elif command -v xsel >/dev/null 2>&1; then
  xsel --clipboard --input < "$1"
elif command -v pbcopy >/dev/null 2>&1; then
  pbcopy < "$1"
else
  echo "No clipboard tool found. Install wl-clipboard, clip.exe/MSYS2, xclip, xsel, or pbcopy." >&2
  exit 1
fi
