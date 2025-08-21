#!/bin/bash



# Loop through all .HEIC or .heic files in the current directory

for file in *.heic *.HEIC; do

  # Check if the file exists

  if [[ -f "$file" ]]; then

    # Generate output file name by replacing .HEIC or .heic with .JPEG

    output="${file%.[Hh][Ee][Ii][Cc]}.jpeg"

    

    # Convert .HEIC to .JPEG using ImageMagick or heif-convert

    magick "$file" "$output"   # Use heif-convert if ImageMagick isn't installed

    echo "Converted $file to $output"

  else

    echo "$file does not exist!"

  fi

done
