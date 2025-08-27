#!/bin/bash

# --- Configuration (Modify these!) ---
VIDEO_FOLDER="/path/to/your/video/folder"
BLENDER_EXECUTABLE="/usr/bin/blender"
SCRIPT_PATH="/path/to/your/script.py"
OUTPUT_FOLDER="/path/to/output/folder"
OUTPUT_FILENAME="video_with_subtitles"

# --- Create output folder if it doesn't exist ---
mkdir -p "$OUTPUT_FOLDER"

# --- Function to process a single video file ---
process_video() {
  VIDEO_FILE="$1"
  BASE_NAME=$(basename "$VIDEO_FILE")
  VIDEO_NAME="${BASE_NAME%.*}"
  OUTPUT_VIDEO_FILE="$OUTPUT_FOLDER/${OUTPUT_FILENAME}_${VIDEO_NAME}.mp4"

  echo "Processing: $VIDEO_FILE"

  # Run Blender to process video
  "$BLENDER_EXECUTABLE" --background --python "$SCRIPT_PATH" -- \
    --video "$VIDEO_FILE" \
    --output "$OUTPUT_VIDEO_FILE"

  echo "Finished processing: $VIDEO_FILE"
}

# --- Find all video files in the folder ---
VIDEO_FILES=($(find "$VIDEO_FOLDER" -type f \( -iname "*.mp4" -o -iname "*.avi" -o -iname "*.mov" \)))

# --- Loop through each video file ---
for VIDEO_FILE in "${VIDEO_FILES[@]}"; do
  process_video "$VIDEO_FILE"
done

echo "Script finished."
