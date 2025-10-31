#!/usr/bin/env fish



# Folder setup

set input_folder (pwd)

set output_folder "$input_folder/compressed"

mkdir -p $output_folder



# Function to compress JPEG/WebP

function compress_lossy --argument img output

    set original_size (stat -c%s "$img")

    set quality 85

    set step 5

    set tmpfile (mktemp /tmp/compress.XXXXXX.jpg)



    while test $quality -ge 10

        convert "$img" -quality $quality "$tmpfile" 2>/dev/null

        set new_size (stat -c%s "$tmpfile")

        set ratio (math "$new_size / $original_size")

        if test (math "$ratio <= 0.5") -eq 1

            break

        end

        set quality (math "$quality - $step")

    end



    mv "$tmpfile" "$output"

    echo "Compressed (lossy) (basename $img): "(math "$original_size / 1e6")"MB → "(math (stat -c%s "$output") / 1e6)"MB (quality=$quality)"

end



# Function to compress PNG

function compress_png --argument img output

    set original_size (stat -c%s "$img")

    set tmpfile (mktemp /tmp/compress.XXXXXX.png)



    # Try a few compression levels (9 = max compression)

    convert "$img" -strip -define png:compression-level=9 "$tmpfile" 2>/dev/null

    mv "$tmpfile" "$output"

    echo "Compressed (PNG) (basename $img): "(math "$original_size / 1e6")"MB → "(math (stat -c%s "$output") / 1e6)"MB"

end



# Process all images

for img in $input_folder/*.{jpg,jpeg,png,webp}

    if test -f "$img"

        set filename (basename "$img")

        set output "$output_folder/$filename"



        switch (string lower (string split "." $filename)[-1])

            case jpg jpeg webp

                compress_lossy "$img" "$output"

            case png

                compress_png "$img" "$output"

        end

    end

end



echo ""

echo "✅ Compression complete! Saved to: $output_folder"
