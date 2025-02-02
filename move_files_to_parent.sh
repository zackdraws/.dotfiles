#!/bin/bash



# Get the current directory (parent directory)

parent_dir=$(pwd)



# Loop through all subdirectories

find "$parent_dir" -mindepth 2 -type f -exec mv -t "$parent_dir" {} +



# Optional: You can also remove empty directories after moving files (uncomment the line below if you want to do this)

# find "$parent_dir" -mindepth 1 -type d -empty -exec rmdir {} +
