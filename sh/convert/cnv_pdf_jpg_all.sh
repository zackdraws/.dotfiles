#!/bin/bash
# Ensure pdftoppm is available
if ! command -v pdftoppm &> /dev/null; then
    echo "Error: 'pdftoppm' is not installed. Please install poppler-utils."
    exit 1
fi
# Find all PDF files in the current directory
pdf_files=(*.pdf)
# Check if there are any PDF files
if [ ${#pdf_files[@]} -eq 0 ]; then
    echo "No PDF files found in current directory."
    exit 1
fi
# Loop through each PDF file
for pdf_file in "${pdf_files[@]}"; do
    echo
    echo "Processing PDF: $pdf_file"
    # Get base name without extension
    base_name=$(basename "$pdf_file" .pdf)
    # Create output directory
    output_dir="${base_name}_pages"
    mkdir -p "$output_dir"
    echo "Converting PDF pages to JPEGs..."
    # Convert PDF to JPEG images
    if ! pdftoppm -jpeg -r 300 "$pdf_file" "$output_dir/page"; then
        echo "Error converting $pdf_file"
        continue
    fi
    # Loop through generated images
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

    echo "All images for $pdf_file saved in: $output_dir/"

done
