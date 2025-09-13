#!/bin/bash

shopt -s nullglob nocaseglob  # Enable globbing for lowercase/uppercase matching

# Loop through all .heic or .HEIC files in the current directory
for file in *.heic; do
  # Check if the file exists and is a regular file
  if [[ -f "$file" ]]; then
    echo "Processing $file..."

    # Generate output file name by replacing extension with .jpeg
    output="${file%.*}.jpeg"

    # Convert using available tool
    if command -v magick &>/dev/null; then
      magick "$file" "$output"
      echo "Converted $file to $output using ImageMagick."
    elif command -v heif-convert &>/dev/null; then
      heif-convert "$file" "$output"
      echo "Converted $file to $output using heif-convert."
    else
      echo "Neither ImageMagick nor heif-convert is installed. Please install one of them."
      exit 1
    fi
  fi
done

echo "Done."
