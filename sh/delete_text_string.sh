#!/bin/bash



# Prompt the user for the directory path

read -p "Enter the directory path: " directory



# Check if the directory exists

if [[ ! -d "$directory" ]]; then

  echo "The directory does not exist. Please check the path and try again."

  exit 1

fi



# Change to the specified directory

cd "$directory" || exit



# Loop through all files in the directory

for file in *; do

  # Check if it's a regular file (not a directory)

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
