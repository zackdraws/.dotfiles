#!/bin/bash



# Get the current directory

current_dir=$(pwd)



# Check if the current directory is valid

if [ ! -d "$current_dir" ]; then

  echo "The current directory is not valid!"

  exit 1

fi



# Prompt the user for the prefix name

read -p "Rename files first enter the prefix: " prefix



# Find all files in the current directory (excluding subdirectories)

files=($(find "$current_dir" -maxdepth 1 -type f))



# Check if there are files to rename

if [ ${#files[@]} -eq 0 ]; then

  echo "No files found in the directory."

  exit 1

fi



# Show the renaming plan for confirmation

echo "You are about to rename the following files with the prefix '$prefix':"

counter=1

for file in "${files[@]}"; do

  extension="${file##*.}"

  new_name="${prefix}_$(printf "%02d" $counter).${extension}"

  echo "$(basename "$file") -> $new_name"

  counter=$((counter + 1))

done



# Prompt for confirmation

read -p "Do you want to proceed with renaming these files? (y/n): " confirm

if [[ ! "$confirm" =~ ^[Yy]$ ]]; then

  echo "Renaming cancelled. No files were renamed."

  exit 1

fi



# Rename the files with the provided prefix and sequential number (zero-padded)

counter=1

for file in "${files[@]}"; do

  # Get the file extension

  extension="${file##*.}"

  

  # Generate the new filename with the prefix and zero-padded sequence number

  new_name="${current_dir}/${prefix}_$(printf "%02d" $counter).${extension}"

  

  # Rename the file

  mv "$file" "$new_name"

  echo "Renamed: $(basename "$file") -> $(basename "$new_name")"

  

  # Increment the counter

  counter=$((counter + 1))

done
