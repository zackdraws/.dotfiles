 #!/bin/bash

# Use the current directory
input_dir="$PWD"

# Ask for the output PDF name
read -p "Enter output PDF name (without .pdf): " output_name
output_pdf="${output_name}.pdf"

# Find jpg/jpeg files in current directory and store them in an array
mapfile -t image_list < <(find "$input_dir" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" \) | sort)

# Check if any images were found
if [ ${#image_list[@]} -eq 0 ]; then
    echo "No JPG files found in $input_dir"
    exit 1
fi

# Run img2pdf with the image list
img2pdf "${image_list[@]}" -o "$output_pdf"

echo "✅ Created PDF: $output_pdf"
