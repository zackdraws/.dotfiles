#!/bin/bash



# Check if directory argument is provided

if [ -z "$1" ]; then

    echo "Please provide a directory to search for duplicates."

    exit 1

fi



# Define the directory to search for duplicates

directory="$1"



# Temporary file to store hashes

temp_file=$(mktemp)



# Find all files in the directory and subdirectories

find "$directory" -type f | while read -r file; do

    # Calculate the SHA256 hash of the file

    hash=$(sha256sum "$file" | awk '{ print $1 }')

    

    # If the hash is already in the temp file, it's a duplicate

    if grep -q "$hash" "$temp_file"; then

        # Delete the duplicate file

        echo "Deleting duplicate: $file"

        rm "$file"

    else

        # Otherwise, save the hash to the temp file

        echo "$hash" >> "$temp_file"

    fi

done



# Clean up the temporary file

rm "$temp_file"



echo "Duplicate deletion complete."
