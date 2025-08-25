#!/bin/bash

# This script captures the output of the last command and copies it to the clipboard.
# It uses xclip (or xsel) to copy the output to the clipboard.
# You might need to install xclip or xsel.

# Check if xclip is installed and install it if not
if ! command -q xclip >/dev/null 2>&1; then
  echo "xclip not found.  Installing..."
  sudo apt-get update
  sudo apt-get install xclip
  echo "xclip installed.  Please run the script again."
  exit 1
fi

# Check if xsel is installed and install it if not
if ! command -q xsel >/dev/null 2>&1; then
  echo "xsel not found.  Installing..."
  sudo apt-get update
  sudo apt-get install xsel
  echo "xsel installed.  Please run the script again."
  exit 1
fi

# Capture the last command's output
output=$(history 1 | grep "^[0-9]+" | tail -n 1 | sed 's/^[[:space:]]*//' )

# Check if there's any output
if [ -z "$output" ]; then
  echo "No output found from the last command."
  exit 0
fi

# Copy the output to the clipboard using xclip
echo "$output" | xclip -selection clipboard

# Alternatively, if xclip doesn't work, try xsel:
# echo "$output" | xsel -b -i

# Print a success message
echo "Output copied to the clipboard."

exit 0
