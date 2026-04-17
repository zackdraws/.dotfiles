#!/bin/bash
if ! command -q xclip >/dev/null 2>&1; then
  echo "xclip not found.  Installing..."
  echo "xclip installed.  Please run the script again."
  exit 1
fi
if ! command -q xsel >/dev/null 2>&1; then
  echo "xsel not found.  Installing..."
  sudo apt-get update
  sudo apt-get install xsel
  echo "xsel installed.  Please run the script again."
  exit 1
fi
output=$(history 1 | grep "^[0-9]+" | tail -n 1 | sed 's/^[[:space:]]*//' )
if [ -z "$output" ]; then
  echo "No output found from the last command."
  exit 0
fi
echo "$output" | xclip -selection clipboard
echo "Output copied to the clipboard."
exit 0
