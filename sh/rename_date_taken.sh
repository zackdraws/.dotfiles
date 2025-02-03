#!/bin/bash



# Prompt the user for the directory path

read -p "Enter the directory path: " directory



# Check if the directory exists

if [[ ! -d "$directory" ]]; then

  echo "The directory does not exist. Please check the path and try again."

  exit 1

fi



# Prompt the user for the file format (extension)

read -p "Enter the file extension (e.g., jpg, png, etc.): " file_extension



# Change to the specified directory

cd "$directory" || exit



# Loop through all files with the given extension in the directory

for file in *.$file_extension; do

  # Check if it's a regular file

  if [[ -f "$file" ]]; then

    # Get the Date Taken (EXIF) from the image file using exiftool

    date_taken=$(exiftool -d "%Y-%m-%d_%H%M%S" -DateTimeOriginal "$file" | awk -F': ' '{print $2}')

    

    # If Date Taken exists

    if [[ -n "$date_taken" ]]; then

      # Create the new filename with 'iph_' prefix and the Date Taken

      new_filename="iph_${date_taken}_${file}"

      

      # Rename the file

      mv "$file" "$new_filename"

      echo "Renamed: $file -> $new_filename"

    else

      echo "No Date Taken found for $file. Skipping."

    fi

  fi

done
