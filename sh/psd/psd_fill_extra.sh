#!/bin/bash

# Ensure ImageMagick is installed
if ! command -v convert &> /dev/null; then
    echo "❌ 'convert' (ImageMagick) not found. Install it with: sudo apt install imagemagick"
    exit 1
fi

# Create output folder
output_dir="mattes"
mkdir -p "$output_dir"

echo "🎨 Creating matte files in: $output_dir"
echo "🔄 Scanning PNGs in: $(pwd)"

for file in *.png; do
    [ -e "$file" ] || continue

    base="${file%.*}"
    output="${output_dir}/${base}_matte.png"

    echo "👉 Processing: $file"

    # 1. Start with the original image
    # 2. Fill interior white areas with green
    # 3. Make black background transparent
    # 4. Remove original outlines (leaving only the fill)
    convert "$file" \
        -fuzz 10% -fill "#00FF00" -draw "color 1,1 floodfill" \
        -fuzz 5% -transparent black \
        -alpha on \
        -channel rgba -separate +channel \
        -combine \
        -alpha extract \
        -threshold 5% \
        -background none -alpha shape \
        -fill "#00FF00" -colorize 100% \
        "$output"

    echo "✅ Saved: $output"
done

echo "🎉 Matte generation complete!"
