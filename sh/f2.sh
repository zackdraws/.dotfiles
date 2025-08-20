#!/bin/bash



# Check if the file path is provided as an argument

if [ -z "$1" ]; then

    echo "Usage: $0 <file-path>"

    exit 1

fi



# Check if the file exists

if [ ! -f "$1" ]; then

    echo "File not found: $1"

    exit 1

fi



# Copy the file contents to the Windows clipboard using clip.exe

cat "$1" | clip.exe

echo "Copied contents of $1 to clipboard."
