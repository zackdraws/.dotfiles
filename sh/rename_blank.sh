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
for file in *.*; do
  # Check if it's a regular file
  if [[ -f "$file" ]]; then
    # Get the file extension
    extension="${file##*.}"
   # Rename the file to a single space followed by the file extension
    mv "$file" " $extension"
    # Output the renaming result
    echo "Renamed: $file -> '__ $extension'"
  fi
done
