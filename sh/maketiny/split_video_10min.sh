#!/usr/bin/env bash
set -euo pipefail

chunk_seconds=600
output_parent=""

usage() {
  cat <<'EOF'
Usage: split_video_10min.sh [-o output_dir] video [video ...]

Split each video into 10-minute chunks with ffmpeg.

Options:
  -o, --output-dir DIR  Put chunk folders inside DIR
  -h, --help            Show this help

Examples:
  split_video_10min.sh movie.mp4
  split_video_10min.sh -o chunks *.mp4
EOF
}

if ! command -v ffmpeg >/dev/null 2>&1; then
  echo "Error: ffmpeg must be installed and available on PATH." >&2
  exit 1
fi

videos=()
while [ "$#" -gt 0 ]; do
  case "$1" in
    -o|--output-dir)
      if [ "$#" -lt 2 ]; then
        echo "Error: missing directory after $1." >&2
        exit 1
      fi
      output_parent="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      while [ "$#" -gt 0 ]; do
        videos+=("$1")
        shift
      done
      ;;
    -*)
      echo "Error: unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
    *)
      videos+=("$1")
      shift
      ;;
  esac
done

if [ "${#videos[@]}" -eq 0 ]; then
  usage >&2
  exit 1
fi

for input in "${videos[@]}"; do
  if [ ! -f "$input" ]; then
    echo "Skipping missing file: $input" >&2
    continue
  fi

  input_dir=$(dirname -- "$input")
  filename=$(basename -- "$input")
  base="${filename%.*}"
  ext="${filename##*.}"

  if [ "$base" = "$filename" ]; then
    ext="mp4"
  fi

  if [ -n "$output_parent" ]; then
    outdir="${output_parent%/}/${base}_10min_chunks"
  else
    outdir="${input_dir%/}/${base}_10min_chunks"
  fi

  mkdir -p "$outdir"
  pattern="${outdir%/}/${base}_part_%03d.${ext}"

  echo "Splitting: $input"
  echo "Output:    $pattern"

  ffmpeg -hide_banner -i "$input" \
    -map 0 \
    -c copy \
    -f segment \
    -segment_time "$chunk_seconds" \
    -reset_timestamps 1 \
    "$pattern"

  echo "Done: $outdir"
done
