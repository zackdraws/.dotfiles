#!/bin/bash

set -euo pipefail

if [ -z "$1" ]; then
    echo "Usage: $0 /path/to/folder"
    exit 1
fi

input_dir="$1"
output_pdf="$input_dir/combined.pdf"

echo "Scanning folder: $input_dir"

tmp_dir="$(mktemp -d)"
echo "Temp working dir: $tmp_dir"

# Find images safely
mapfile -d '' files < <(
    find "$input_dir" -type f \
        \( -iname "*.jpg" -o -iname "*.jpeg" \) \
        ! -name ".*" \
        -size +10k \
        -print0 | sort -z
)

echo "Found: ${#files[@]} images"

if [ "${#files[@]}" -eq 0 ]; then
    echo "No valid images found"
    exit 1
fi

echo "Converting images to clean RGB JPEGs..."

i=0
clean_files=()

for f in "${files[@]}"; do
    ((i++))

    # Skip broken files
    if ! file "$f" | grep -qi "jpeg"; then
        echo "Skipping invalid file: $f"
        continue
    fi

    out="$tmp_dir/$(printf "%05d.jpg" "$i")"

    # THIS is the key fix (kills gray CMYK pages)
    magick "$f" \
        -auto-orient \
        -colorspace RGB \
        -strip \
        "$out"

    clean_files+=("$out")
done

echo "Clean images: ${#clean_files[@]}"

if [ "${#clean_files[@]}" -eq 0 ]; then
    echo "No valid images after processing"
    exit 1
fi

echo "Building PDF..."

img2pdf "${clean_files[@]}" -o "$output_pdf"

echo "✓ DONE: $output_pdf"
