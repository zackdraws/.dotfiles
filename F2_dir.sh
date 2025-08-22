#!/bin/bash

# Check for required argument
if [ -z "$1" ]; then
  echo "Usage: $0 filename"
  exit 1
fi

# Check if file exists
if [ ! -f "$1" ]; then
  echo "File '$1' not found!"
  exit 1
fi

# Use clip.exe to copy to Windows clipboard
cat "$1" | /mnt/c/Windows/System32/clip.exe

# Confirm success
if [ $? -eq 0 ]; then
  echo "Copied contents of '$1' to Windows clipboard."
else
  echo "Failed to copy to clipboard."
fi
