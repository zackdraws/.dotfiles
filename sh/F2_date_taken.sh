#!/bin/bash



# Prompt the user for the directory path

read -p "Enter the directory path: " directory



# Check if the directory exists

if [[ ! -d "$directory" ]]; then

  echo "The directory does not exist. Please check the path and try again."

  exit 1

fi



# Prompt the user for the file extension (e.g., jpg, png)

read -p "Enter the file extension (e.g., jpg, png): " file_extension



# Change to the specified directory

cd "$directory" || exit



# Loop through all files with the given extension

for file in *."$file_extension"; do

  if [[ -f "$file" ]]; then

    # Extract the Date Taken using exiftool

    date_taken=$(exiftool -d "%Y%m%d%H%M%S" -DateTimeOriginal "$file" | awk -F': ' '{print $2}')



    if [[ -n "$date_taken" ]]; then

      # Construct new filename with correct extension

      new_filename="${date_taken}.${file_extension}"



      # Avoid overwriting existing files

      if [[ -e "$new_filename" ]]; then

        new_filename="${date_taken}_$RANDOM.${file_extension}"

      fi



      # Rename the file

      mv "$file" "$new_filename"

      echo "Renamed: $file -> $new_filename"

    else

      echo "No Date Taken found for $file. Skipping."

    fi

  fi

done
