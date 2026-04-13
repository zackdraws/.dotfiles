#!/bin/bash
# check for pdftoppm 
if ! command -v pdftoppm &> /dev/null; then
echo "Error: 'pdftoppm' is not installed. install poppler-utils."
exit 1
fi
pdf_file=$(ls *.pdf 2>/dev/null | head -n 1)
if [ -z "$pdf_file" ]; then
echo "No PDF file found in current directory."
exit 1
fi
echo "Found PDF: $pdf_file"
base_name=$(basename "$pdf_file" .pdf)
output_dir="${base_name}_pages"
mkdir -p "$output_dir"
echo "Converting PDF pages to JPEGs..."
if ! pdftoppm -jpeg -r 300 "$pdf_file" "$output_dir/page"; then
echo "Error converting PDF."
exit 1
fi
for img in "$output_dir"/page-*.jpg; do
echo
echo "Image generated: $img"
read -p "Enter name for this image (without extension): " newname
if [ -z "$newname" ]; then
echo "Skipping rename."
continue
fi
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
