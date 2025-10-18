#!/bin/bash
set -e

# Loop over all .mp4 files in the folder
for video in *.mp4; do
    # Check if there are no MP4 files
    [ -e "$video" ] || { echo "No MP4 files found."; exit 1; }

    # Output file name (replace .mp4 with .gif)
    output="${video%.mp4}.gif"

    echo "Converting '$video' -> '$output'..."

    # Convert to GIF (optimized for size and color)
    ffmpeg -i "$video" -vf "fps=15,scale=480:-1:flags=lanczos" -loop 0 "$output"

    echo "Γ£à Done: $output"
done

echo "≡ƒÄë All conversions completed!"
1~
