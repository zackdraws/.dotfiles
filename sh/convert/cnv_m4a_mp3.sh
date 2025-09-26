#!/usr/bin/env bash
set -e
echo "Converting all .m4a files in: $(pwd)"
echo "Preserving metadata"
shopt -s nullglob
shopt -s nocaseglob
for AUDIO_FILE in *.m4a; do
  if [[ -n "$AUDIO_FILE" ]]; then  # Check if the file exists (handles nullglob)
    OUTPUT_FILE="${AUDIO_FILE%.m4a}.mp3"
    echo "Converting: \"$AUDIO_FILE\" ΓåÆ \"$OUTPUT_FILE\""
    ffmpeg -y -i "$AUDIO_FILE" \
        -map_metadata 0 \
        -codec:a libmp3lame \
        -b:a 192k \
        "$OUTPUT_FILE"
    echo "Done: \"$OUTPUT_FILE\""
    echo
  fi
done
echo "All .m4a files converted to .mp3 with metadata preserved!"
~
