#!/bin/bash



# Loop through all .JFIF and .jfif files in the current directory

for file in *.jfif *.JFIF; do

  # Check if the file exists

  if [[ -f "$file" ]]; then

    echo "Deleting $file..."

    rm "$file"  # Remove the file

  else

    echo "No .JFIF files found!"

  fi

done
