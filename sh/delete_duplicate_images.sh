#!/bin/bash



# Display warning message before proceeding

echo "WARNING: This is an experimental script by Zack."

echo "Please understand that by using this script, you accept the risk."

echo "Thank you! :-)"

echo "Press Enter to continue..."



# Wait for the user to press Enter

read -r



# Check if directory argument is provided

if [ -z "$1" ]; then

    echo "Please provide a directory to search for duplicates."

    exit 1

fi



# Define the directory to search for duplicates

directory="$1"



# Temporary file to store filenames of unique images

temp_file=$(mktemp)



# Debugging: Output to show the directory being processed

echo "Searching for duplicates in: $directory"



# Find all jpg files in the directory and subdirectories

find "$directory" -type f -iname "*.jpg" | while read -r file; do

    # Compare the current image with all previously found images

    duplicate_found=false

    

    while read -r saved_file; do

        # Use ImageMagick compare command (using -metric AE to find identical images)

        result=$(compare -metric AE "$file" "$saved_file" null: 2>&1)

        

        # If the result is 0, the images are identical

        if [ "$result" -eq 0 ]; then

            echo "Duplicate found: $file and $saved_file"

            duplicate_found=true

            break

        fi

    done < "$temp_file"



    # If no duplicate was found, save the file for future comparison

    if [ "$duplicate_found" = false ]; then

        echo "$file" >> "$temp_file"

    else

        # Delete the duplicate file

        echo "Deleting duplicate: $file"

        rm "$file"

    fi

done



# Clean up the temporary file

rm "$temp_file"



echo "Duplicate deletion complete."
