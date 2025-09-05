#!/bin/bash



# Ensure pdftoppm is available

if ! command -v pdftoppm &> /dev/null; then

    echo "Error: 'pdftoppm' is not installed. Please install poppler-utils."

    exit 1

fi



# Find the first PDF in the current directory

pdf_file=$(ls *.pdf 2>/dev/null | head -n 1)



# Check if we found a PDF file

if [ -z "$pdf_file" ]; then

    echo "No PDF file found in current directory."

    exit 1

fi



echo "Found PDF: $pdf_file"



# Get the base filename without extension

base_name=$(basename "$pdf_file" .pdf)



# Create an output directory

output_dir="${base_name}_pages"

mkdir -p "$output_dir"



echo "Converting PDF pages to JPEGs..."



# Convert PDF to JPEG

if ! pdftoppm -jpeg -r 300 "$pdf_file" "$output_dir/page"; then

    echo "Error converting PDF."

    exit 1

fi



# Loop through each image

for img in "$output_dir"/page-*.jpg; do

    echo

    echo "Image generated: $img"

    read -p "Enter name for this image (without extension): " newname



    if [ -z "$newname" ]; then

        echo "Skipping rename."

        continue

    fi



    # Clean up name

    safe_name=$(echo "$newname" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9' '_')



    # Avoid overwrite

    if [ -e "$output_dir/${safe_name}.jpg" ]; then

        echo "Warning: ${safe_name}.jpg already exists. Skipping."

        continue

    fi



    mv "$img" "$output_dir/${safe_name}.jpg"

    echo "Saved as: ${safe_name}.jpg"

done



echo

echo "All images saved in: $output_dir/"
