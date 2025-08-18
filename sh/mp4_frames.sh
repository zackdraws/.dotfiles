#!/bin/bash

# Check if input is given
if [ -z "$1" ]; then
    echo "Usage: $0 input_video.mp4"
    exit 1
fi

INPUT_FILE="$1"
BASENAME=$(basename "$INPUT_FILE" .mp4)
OUTPUT_DIR="${BASENAME}_frames"

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Extract frames as JPG images
ffmpeg -i "$INPUT_FILE" "$OUTPUT_DIR/frame_%04d.jpg"

echo "Frames saved to: $OUTPUT_DIR"
