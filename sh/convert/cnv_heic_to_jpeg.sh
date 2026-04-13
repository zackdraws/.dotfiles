#!/bin/bash
for file in *.heic *.HEIC; do
  if [[ -f "$file" ]]; then
      # Generate output file name
      # replacing .HEIC or .heic with .JPEG
    output="${file%.[Hh][Ee][Ii][Cc]}.jpeg"
    # Convert .HEIC to .JPEG using ImageMagick or heif-convert
    magick "$file" "$output" 
    echo "Converted $file to $output"
  else
    echo "$file does not exist!"
  fi
done
