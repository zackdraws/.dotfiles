#!/usr/bin/env bash
set -euo pipefail

copy_to_clipboard() {
  if command -v clip.exe >/dev/null 2>&1; then
    clip.exe
  elif command -v wl-copy >/dev/null 2>&1; then
    wl-copy
  elif command -v xclip >/dev/null 2>&1; then
    xclip -selection clipboard
  elif command -v xsel >/dev/null 2>&1; then
    xsel --clipboard --input
  elif command -v pbcopy >/dev/null 2>&1; then
    pbcopy
  else
    echo "No clipboard tool found. Install clip.exe/MSYS2, wl-clipboard, xclip, xsel, or pbcopy." >&2
    return 1
  fi
}

if [ -t 0 ]; then
  output="$(history 1 2>/dev/null | sed 's/^[[:space:]]*[0-9]\+[[:space:]]*//' || true)"
else
  output="$(cat)"
fi

if [ -z "$output" ]; then
  echo "No output found to copy."
  exit 0
fi

printf '%s' "$output" | copy_to_clipboard
echo "Output copied to the clipboard."
