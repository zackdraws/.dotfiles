#!/bin/bash
read -p "Enter the directory path: " directory
if [[ ! -d "$directory" ]]; then
  echo "The directory does not exist. Please check the path and try again."
  exit 1
fi
cd "$directory" || exit
for file in *; do
  if [[ -f "$file" ]]; then
    # Check if the filename contains "_2025-02-01"
    if [[ "$file" == *_2025-02-01* ]]; then
      # Remove "_2025-02-01" from the filename
      new_filename="${file//_2025-02-01/}"
      # Rename the file
      mv "$file" "$new_filename"
      echo "Renamed: $file -> $new_filename"
    fi
  fi
done
