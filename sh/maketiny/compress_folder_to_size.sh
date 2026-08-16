#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "Usage: $0 <folder> [target_size_mb]" >&2
  echo "Example: $0 ~/Videos 1000" >&2
  exit 1
fi

folder=$1
target_mb=${2:-1000}

if [[ ! -d $folder ]]; then
  echo "Not a folder: $folder" >&2
  exit 1
fi
if ! [[ $target_mb =~ ^[1-9][0-9]*$ ]]; then
  echo "Target size must be a positive whole number of MB." >&2
  exit 1
fi
for command in ffmpeg ffprobe; do
  command -v "$command" >/dev/null || {
    echo "Missing required command: $command" >&2
    exit 1
  }
done

target_bytes=$((target_mb * 1000 * 1000))
audio_bitrate=128
processed=0
skipped=0
failed=0

while IFS= read -r -d '' input; do
  input_bytes=$(wc -c < "$input")
  if (( input_bytes <= target_bytes )); then
    printf 'Skipping (already <= %s MB): %s\n' "$target_mb" "$input"
    ((skipped += 1))
    continue
  fi

  duration=$(ffprobe -v error -show_entries format=duration \
    -of default=noprint_wrappers=1:nokey=1 "$input")
  if [[ -z $duration ]] || ! awk "BEGIN { exit !($duration > 0) }"; then
    printf 'Skipping (could not determine duration): %s\n' "$input" >&2
    ((failed += 1))
    continue
  fi

  duration_seconds=$(awk "BEGIN { printf \"%.0f\", $duration }")
  total_kbps=$((target_mb * 8000 / duration_seconds))
  video_kbps=$((total_kbps - audio_bitrate - 16))
  if (( video_kbps < 100 )); then
    printf 'Skipping (target too small for this duration): %s\n' "$input" >&2
    ((failed += 1))
    continue
  fi

  output="${input%.*}.max-${target_mb}mb.mp4"
  if [[ -e $output ]]; then
    printf 'Skipping (output exists): %s\n' "$output"
    ((skipped += 1))
    continue
  fi

  passlog=$(mktemp "${TMPDIR:-/tmp}/compress-pass.XXXXXX")
  rm -f "$passlog"
  printf 'Compressing: %s -> %s (video: %s kbps)\n' "$input" "$output" "$video_kbps"

  if ffmpeg -nostdin -y -i "$input" -c:v libx264 -b:v "${video_kbps}k" \
      -pass 1 -passlogfile "$passlog" -an -f mp4 /dev/null \
    && ffmpeg -nostdin -y -i "$input" -c:v libx264 -b:v "${video_kbps}k" \
      -pass 2 -passlogfile "$passlog" -c:a aac -b:a "${audio_bitrate}k" \
      -movflags +faststart "$output"; then
    ((processed += 1))
  else
    printf 'Failed: %s\n' "$input" >&2
    rm -f "$output"
    ((failed += 1))
  fi
  rm -f "${passlog}"* 
done < <(find "$folder" -type f \( \
  -iname '*.mp4' -o -iname '*.mkv' -o -iname '*.mov' -o -iname '*.avi' \
  -o -iname '*.webm' -o -iname '*.m4v' -o -iname '*.wmv' \
\) ! -iname "*.max-${target_mb}mb.mp4" -print0)

printf '\nDone. Compressed: %d, skipped: %d, failed: %d\n' \
  "$processed" "$skipped" "$failed"
