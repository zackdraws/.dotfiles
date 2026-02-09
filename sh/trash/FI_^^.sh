#!/bin/bash
current_dir=$(pwd)
parent_dir=$(dirname "$current_dir")
# Move all files (non-hidden) from the current directory to its parent
find "$current_dir" -maxdepth 1 -type f -exec mv -t "$parent_dir" {} +
echo "Files moved from $current_dir to $parent_dir"
