#!/bin/bash



# List of .HEIC files to convert

files=(

  "IMG_3739.HEIC"

  "IMG_3740.HEIC"

  "IMG_3746.HEIC"

  "IMG_3747.HEIC"

  "IMG_3748.HEIC"

  "IMG_3749.HEIC"

  "IMG_3750.HEIC"

  "IMG_3751.HEIC"

  "IMG_3752.HEIC"

  "IMG_3753.HEIC"

)



# Loop through each file and convert to JPG

for file in "${files[@]}"; do

  # Check if the file exists

  if [[ -f "$file" ]]; then

    # Generate output file name by replacing .HEIC with .JPG

    output="${file%.HEIC}.jpg"

    

    # Convert .HEIC to .JPG using ImageMagick or heif-convert

    magick "$file" "$output"   # Use heif-convert if ImageMagick isn't installed

    echo "Converted $file to $output"

  else

    echo "$file does not exist!"

  fi

done
