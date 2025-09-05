#!/bin/bash
# Get the current directory (parent directory)
parent_dir=$(pwd)
# Loop through all subdirectories
find "$parent_dir" -mindepth 2 -type f -exec mv -t "$parent_dir" {} +
