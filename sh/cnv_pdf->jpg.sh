#!/bin/bash





if [ -z "$1" ]; then

    echo "Usage: $0 path/to/file.pdf"

    exit 1

fi



pdf_file="$1"
# Get the base filename without extension
base_name=$(basename "$pdf_file" .pdf)
# Create a temporary directory for output
output_dir="${base_name}_pages"
mkdir -p "$output_dir"
echo "Converting PDF pages to JPEGs..."
# Convert PDF to JPEG using pdftoppm
# -jpeg: output JPEG
# -r 300: resolution
# Output: page-1.jpg, page-2.jpg, ...
pdftoppm -jpeg -r 300 "$pdf_file" "$output_dir/page"
# Loop over each output JPEG
for img in "$output_dir"/page-*.jpg; do
    echo
    echo "Image generated: $img"
    read -p "Enter name for this image (without extension): " newname
    # Sanitize filename: remove spaces, special chars
    safe_name=$(echo "$newname" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9' '_')
    mv "$img" "$output_dir/${safe_name}.jpg"
    echo "Saved as: ${safe_name}.jpg"
done
echo
echo "All images saved in: $output_dir/"
