#!/bin/bash

# Script to convert all .opus files in the current directory to .mp3

for file in *.opus; do
  # Check if any .opus files exist
  [ -e "$file" ] || continue

  # Remove extension and create output filename
  base="${file%.opus}"
  output="${base}.mp3"

  echo "Converting: $file -> $output"

  ffmpeg -i "$file" -codec:a libmp3lame -qscale:a 2 "$output"
done

echo "Conversion complete!"
