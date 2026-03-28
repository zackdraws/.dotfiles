#!/bin/bash
# Check if input folder is provided
if [ -z "$1" ]; then
    echo "Usage: $0 /path/to/folder"
    exit 1
fi
input_dir="$1"
# Ask for the output PDF name
read -p "Enter output PDF name (without .pdf): " output_name
output_pdf="${output_name}.pdf"
# Find jpg/jpeg files and sort them
image_list=$(find "$input_dir" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" \) | sort)
# If no images found
if [ -z "$image_list" ]; then
    echo "No JPG files found in $input_dir"
    exit 1
fi
# Run img2pdf
img2pdf $image_list -o "$output_pdf"
echo "✅ Created PDF: $output_pdf"
