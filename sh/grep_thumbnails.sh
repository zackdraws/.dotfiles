#!/bin/bash

# based on grep -E '/mnt/.+\.(jpg|jpeg|png|pdf|eps)' notes.org | ./gen_tex.sh | clip.exe
# Check if an input file is given
if [ -z "$1" ]; then
    echo "Usage: $0 path_to_org_file"
    exit 1
fi

input_file="$1"

# Extract image paths and convert them to LaTeX commands
grep -Eo '/mnt[^ ]+\.(jpg|jpeg|png|pdf|eps)' "$input_file" | while IFS= read -r filepath; do
    echo "\\includegraphics[width=0.34\\textwidth]{${filepath}}"
done | clip.exe

echo "LaTeX image include commands copied to clipboard."

