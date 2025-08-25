#!/bin/bash



# Check for required command

if ! command -v pdftoppm &> /dev/null; then

    echo "Error: 'pdftoppm' is not installed. Please install poppler-utils."

    exit 1

fi



# Check if PDF file is provided

if [ -z "$1" ]; then

    echo "Usage: $0 path/to/file.pdf"

    exit 1

fi



pdf_file="$1"



# Check if file exists

if [ ! -f "$pdf_file" ]; then

    echo "Error: File '$pdf_file' not found."

    exit 1

fi



# Get the base filename without extension

base_name=$(basename "$pdf_file" .pdf)



# Create a temporary directory for output

output_dir="${base_name}_pages"

mkdir -p "$output_dir"



echo "Converting PDF pages to JPEGs..."



# Convert PDF to JPEG using pdftoppm

if ! pdftoppm -jpeg -r 300 "$pdf_file" "$output_dir/page"; then

    echo "Error converting PDF. Make sure the file is a valid PDF."

    exit 1

fi



# Loop over each output JPEG

for img in "$output_dir"/page-*.jpg; do

    echo

    echo "Image generated: $img"

    read -p "Enter name for this image (without extension): " newname



    # Skip renaming if no input provided

    if [ -z "$newname" ]; then

        echo "Skipping rename."

        continue

    fi



    # Sanitize filename: remove spaces, special chars

    safe_name=$(echo "$newname" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9' '_')



    # Avoid overwriting existing files

    if [ -e "$output_dir/${safe_name}.jpg" ]; then

        echo "Warning: ${safe_name}.jpg already exists. Skipping."

        continue

    fi



    mv "$img" "$output_dir/${safe_name}.jpg"

    echo "Saved as: ${safe_name}.jpg"

done



echo

echo "All images saved in: $output_dir/"
