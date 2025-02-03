#!/bin/bash



# Check if a path is provided

if [ -z "$1" ]; then

  echo "Usage: $0 <linux-path>"

  exit 1

fi



# Replace /mnt/c/ with c:\

windows_path=$(echo "$1" | sed 's|/mnt/c|C:|')



# Replace /mnt/<drive>/ with <drive>:\ and forward slashes with backslashes

windows_path=$(echo "$windows_path" | sed 's|/mnt/\([a-z]\)|\1:|g' | sed 's|/|\\|g')



# Copy the converted path to the clipboard using clip.exe

echo "$windows_path" | clip.exe



# Output the converted path

echo "Path copied to clipboard: $windows_path"
