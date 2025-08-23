#!/bin/bash
# Ensure rembg and convert exist
if ! command -v rembg &> /dev/null; then
    echo "❌ 'rembg' not found. Install it with: pip install rembg"
    exit 1
fi
if ! command -v convert &> /dev/null; then
    echo "❌ 'convert' (ImageMagick) not found. Install it with: sudo apt install imagemagick"
    exit 1
fi

# Supported extensions
EXTENSIONS="jpg jpeg png JPG JPEG PNG"
echo "🔄 Starting background removal in: $(pwd)"
for ext in $EXTENSIONS; do
  for file in *.$ext; do
    [ -e "$file" ] || continue

    base="${file%.*}"

    output="${base}_bg_removed.png"

    echo "👉 Processing: $file"

    # Use rembg to remove background
    if rembg i "$file" temp_no_bg.png; then
        # Trim and save final output
        convert temp_no_bg.png -trim +repage "$output"
        echo "✅ Saved: $output"

    else

        echo "❌ rembg failed on: $file"

    fi

  done

done



rm -f temp_no_bg.png



echo "🎉 All done!"
