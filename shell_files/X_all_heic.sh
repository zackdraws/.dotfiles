#!/bin/bash



# Loop through all .HEIC and .heic files in the current directory

for file in *.heic *.HEIC; do

  # Check if the file exists

  if [[ -f "$file" ]]; then

    echo "Deleting $file..."

    rm "$file"  # Remove the file

  else

    echo "No .HEIC files found!"

  fi

done
