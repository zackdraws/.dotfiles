#!/bin/bash
echo "Searching for files to delete (excluding files with 'cropped' in the name)..."
find . -type f ! -name '*cropped*' -print
read -p "Are you sure you want to delete these files? (y/N): " confirm
if [[ "$confirm" == [yY] ]]; then
    find . -type f ! -name '*cropped*' -delete
    echo "Files deleted."
else
    echo "Operation cancelled."
fi
