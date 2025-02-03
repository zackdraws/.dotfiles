#!/bin/bash



# Prompt the user for the directory path

read -p "Enter the directory path: " directory



# Check if the directory exists

if [[ ! -d "$directory" ]]; then

  echo "The directory does not exist. Please check the path and try again."

  exit 1

fi



# Prompt the user for the file format (extension)

read -p "Enter the file extension (e.g., jpg, png, txt, etc.): " file_extension



# Change to the specified directory

cd "$directory" || exit



# Loop through all files in the directory

for file in *; do

  # Check if it's a regular file (not a directory)

  if [[ -f "$file" ]]; then

    # Get the date modified in the format YYYY-MM-DD_HHMMSS

    modified_date=$(date -r "$file" "+%Y-%m-%d_%H%M%S")

    

    # Get the file name without extension

    filename_without_extension="${file%.*}"

    

    # Create the new filename with the prefix 'iph_' and the user-defined extension

    new_filename="iph_${modified_date}_${filename_without_extension}.${file_extension}"

    

    # Rename the file

    mv "$file" "$new_filename"

  fi

done
