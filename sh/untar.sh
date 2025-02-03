#!/bin/bash

# Get the current directory where the script is run
source_directory=$(pwd)

# Find all tar files in the current directory and subdirectories
find "$source_directory" -type f -name "*.tar" | while read tar_file; do

    # Create a subdirectory in the same directory as the tar file (without extension)
    dir_name=$(basename "$tar_file" .tar)
    dest_dir="$(dirname "$tar_file")/$dir_name"

    mkdir -p "$dest_dir"

    # Extract the tar file
    tar -xf "$tar_file" -C "$dest_dir"
    echo "Extracted $tar_file to $dest_dir"

    # Delete the tar file after extraction
    rm "$tar_file"
    echo "Deleted $tar_file"
done
