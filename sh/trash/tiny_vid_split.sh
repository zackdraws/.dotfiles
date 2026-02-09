#!/bin/bash



CHUNK_DURATION=600  # 10 minutes in seconds



# Check dependencies

if ! command -v ffmpeg &>/dev/null || ! command -v ffprobe &>/dev/null; then

  echo "Error: ffmpeg and ffprobe must be installed."

  exit 1

fi



shopt -s nullglob



FILES=(*.mp4)



if [ ${#FILES[@]} -eq 0 ]; then

  echo "No .mp4 files found in current directory."

  exit 1

fi



for FILE in "${FILES[@]}"; do

  BASENAME="${FILE%.mp4}"

  OUTPUT_DIR="chunks_${BASENAME}"



  mkdir -p "$OUTPUT_DIR"



  # Get duration in seconds (integer)

  DURATION=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$FILE")

  DURATION=${DURATION%.*}



  # Calculate how many chunks

  CHUNKS=$(( (DURATION + CHUNK_DURATION - 1) / CHUNK_DURATION ))



  echo "Splitting '$FILE' ($DURATION sec) into $CHUNKS parts..."



  for ((i=0; i<CHUNKS; i++)); do

    START=$((i * CHUNK_DURATION))

    OUTFILE=$(printf "%s/%s_%03d.mp4" "$OUTPUT_DIR" "$BASENAME" $((i+1)))



    ffmpeg -hide_banner -loglevel error -ss "$START" -i "$FILE" -t "$CHUNK_DURATION" -c copy "$OUTFILE"



    echo "Created $OUTFILE"

  done



  echo "----------------------------"

done



echo "All files processed."
