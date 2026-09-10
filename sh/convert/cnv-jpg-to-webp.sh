#!/usr/bin/env bash
set -euo pipefail

quality=80
force=false
dry_run=false

usage() {
  cat <<'EOF'
Usage: ./convert-jpg-to-webp.sh [options]

Options:
  -q, --quality NUMBER  WebP quality from 0 to 100 (default: 80)
  -f, --force           Re-create WebPs that already exist
  -n, --dry-run         Show what would be converted without writing files
  -h, --help            Show this help text

Examples:
  ./convert-jpg-to-webp.sh
  ./convert-jpg-to-webp.sh --quality 75
  ./convert-jpg-to-webp.sh --force
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -q|--quality)
      quality="${2:?A quality value is required}"
      shift 2
      ;;
    -f|--force)
      force=true
      shift
      ;;
    -n|--dry-run)
      dry_run=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if ! [[ "$quality" =~ ^[0-9]+$ ]] || (( quality < 0 || quality > 100 )); then
  echo "Quality must be a whole number from 0 to 100." >&2
  exit 1
fi

if ! command -v cwebp >/dev/null 2>&1; then
  echo "cwebp was not found. Install the WebP utilities, then run this script again." >&2
  exit 1
fi

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
output_dir="$script_dir/webp"

if [[ "$dry_run" == false ]]; then
  mkdir -p -- "$output_dir"
fi

converted=0
skipped=0
found=0

while IFS= read -r -d '' image; do
  found=$((found + 1))
  filename="$(basename -- "$image")"
  output="$output_dir/${filename%.*}.webp"

  if [[ -e "$output" && "$force" == false ]]; then
    skipped=$((skipped + 1))
    continue
  fi

  if [[ "$dry_run" == true ]]; then
    echo "Would convert: $filename -> ${output##*/}"
  else
    cwebp -quiet -q "$quality" "$image" -o "$output"
  fi
  converted=$((converted + 1))
done < <(find "$script_dir" -maxdepth 1 -type f -iname '*.jpg' -print0)

if (( found == 0 )); then
  echo "No JPG files found in $script_dir" >&2
  exit 1
fi

if [[ "$dry_run" == true ]]; then
  echo "Would convert $converted image(s); skip $skipped existing WebP file(s)."
else
  echo "Converted $converted image(s); skipped $skipped existing WebP file(s)."
fi
