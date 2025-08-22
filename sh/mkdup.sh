#!/bin/bash

# Check if a filename is given
if [ -z "$1" ]; then
  echo "Usage: $0 filename"
  exit 1
fi

# Check if the file exists
if [ ! -f "$1" ]; then
  echo "File '$1' not found!"
  exit 1
fi

# Create a copy with a .copy suffix
cp "$1" "$1.copy"
echo "File '$1' copied to '$1.copy'"
