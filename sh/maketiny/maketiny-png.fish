#!/usr/bin/env fish
set input_folder (pwd)
set output_folder "$input_folder/compressed_pngs"
mkdir -p $output_folder
# Check dependencies
if not type -q convert
    echo "❌ ImageMagick (convert) is not installed. Install it with:"
    echo "   sudo apt install imagemagick"
    exit 1
end
# Optional: pngquant for lossy compression (commented out by default)
set use_pngquant false
if type -q pngquant
    set use_pngquant true
end
# === FUNCTION ===
function compress_png --argument img output
    set original_size (stat -c%s "$img")
    set tmpfile (mktemp /tmp/compress.XXXXXX.png)
    if test $use_pngquant = true
        # Lossy compression (reduces color depth, much smaller)
        pngquant --force --output "$tmpfile" --quality=65-85 "$img" 2>/dev/null
    else
        # Lossless optimization
        convert "$img" -strip -define png:compression-level=9 "$tmpfile" 2>/dev/null
    end
    mv "$tmpfile" "$output"
    set new_size (stat -c%s "$output")
    echo "Compressed (basename $img): "(math "$original_size / 1e6")"MB → "(math "$new_size / 1e6")"MB"
end
# === MAIN LOOP ===
for img in $input_folder/*.png
    if test -f "$img"
        set filename (basename "$img")
        set output "$output_folder/$filename"
        compress_png "$img" "$output"
    end
end
echo ""
echo "✅ PNG compression complete! Saved to: $output_folder"
if test $use_pngquant = false
    echo "💡 Tip: Install pngquant for even smaller (lossy) PNGs → sudo apt install pngquant"
end
