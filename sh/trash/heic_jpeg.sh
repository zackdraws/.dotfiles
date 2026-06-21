#!/bin/bash

# Loop through all .HEIC or .heic files in the current directory
for file in *.heic *.HEIC; do
  # Check if the file exists
  if [[ -f "$file" ]]; then
    echo "Processing $file..."

    # Generate output file name by replacing .HEIC or .heic with .JPEG
    output="${file%.[Hh][Ee][Ii][Cc]}.jpeg"

    # Convert .HEIC to .JPEG using ImageMagick or heif-convert
    if command -v magick &> /dev/null; then
      # Use ImageMagick (magick command)
      magick "$file" "$output"
      echo "Converted $file to $output using ImageMagick."
    elif command -v heif-convert &> /dev/null; then
      # Use heif-convert
      heif-convert "$file" "$output"
      echo "Converted $file to $output using heif-convert."
    else
      echo "Neither ImageMagick nor heif-convert is installed. Please install one of these tools."
      exit 1
    fi

  else
    echo "No .HEIC files found!"
  fi
done
