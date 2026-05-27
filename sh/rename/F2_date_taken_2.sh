#!/bin/bash
# Prompt the user for the directory path
read -p "Enter the directory path: " directory
# Check if the directory exists
if [[ ! -d "$directory" ]]; then
  echo "The directory does not exist. Please check the path and try again."
  exit 1
fi
read -p "Enter the file extension (e.g., jpg, png, etc.): " file_extension
cd "$directory" || exit
for file in *.$file_extension; do
  if [[ -f "$file" ]]; then
    date_taken=$(exiftool -d "%Y-%m-%d_%H%M%S" -DateTimeOriginal "$file" | awk -F': ' '{print $2}')
    if [[ -n "$date_taken" ]]; then
      new_filename="iph_${date_taken}_${file}"
      mv "$file" "$new_filename"
      echo "Renamed: $file -> $new_filename"
    else
      echo "No Date Taken found for $file. Skipping."
    fi
  fi
done
