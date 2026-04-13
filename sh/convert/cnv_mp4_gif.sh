#!/bin/bash
set -e
for video in *.mp4; do
[ -e "$video" ] || { echo "No MP4 files found."; exit 1; }
# mp4 > gif 
output="${video%.mp4}.gif"
echo "Converting '$video' -> '$output'..."
# Convert to GIF 
ffmpeg -i "$video" -vf "fps=15,scale=480:-1:flags=lanczos" -loop 0 "$output"
echo "Γ£à Done: $output"
done
echo "≡ƒÄë All conversions completed!"

