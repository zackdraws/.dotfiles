#!/bin/bash
# Check dependencies
if ! command -v convert &> /dev/null; then
    echo "❌ 'convert' (ImageMagick) not found. Install it with: sudo apt install imagemagick"
    exit 1
fi
# Create output directory for mattes
output_dir="mattes"
mkdir -p "$output_dir"
echo "🎨 Generating mattes in: $output_dir"
echo "🔄 Processing images in: $(pwd)"
for file in *.png; do
    [ -e "$file" ] || continue

    base="${file%.*}"
    output="${output_dir}/${base}_matte.png"

    echo "👉 Processing: $file"
    # Fill interior white with solid green, make background transparent, remove outlines
    convert "$file" \
        -fuzz 10% -fill "#00FF00" -draw "color 1,1 floodfill" \
        -fuzz 5% -transparent black \
        -alpha on -channel rgba -separate +channel \
        -combine -alpha extract \
        -threshold 1% \
        -alpha off -background none -compose CopyOpacity -composite \
        -fill "#00FF00" -colorize 100% \
        "$output"
    echo "✅ Saved matte: $output"
done

echo "🎉 All done!"
