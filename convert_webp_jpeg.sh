#!/bin/bash

# Check if there are any arguments
if [ $# -eq 0 ]; then
    echo "Usage: $0 <webp-files>"
    echo "Example: $0 image1.webp image2.webp"
    exit 1
fi

# Check if convert (ImageMagick) is installed
if ! command -v convert >/dev/null 2>&1; then
    echo "Error: ImageMagick is not installed. Please install it first."
    echo "Ubuntu/Debian: sudo apt install imagemagick"
    echo "Fedora: sudo dnf install imagemagick"
    exit 1
fi

# Process each file
for file in "$@"; do
    # Check if file exists
    if [ ! -f "$file" ]; then
        echo "Error: File \"$file\" not found"
        continue
    fi

    # Check if file is WebP
    if [[ ! "$file" =~ \.webp$ ]]; then
        echo "Error: \"$file\" is not a WebP file"
        continue
    fi

    # Get the base name and create new filename
    newfile="${file%.webp}.jpg"

    # Convert the file
    if convert "$file" "$newfile"; then
        echo "Converted: $file -> $newfile"
    else
        echo "Error converting: $file"
    fi
done
