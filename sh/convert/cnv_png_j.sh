k#!/usr/bin/env bash
set -euo pipefail

converter=()
if command -v magick >/dev/null 2>&1; then
  converter=(magick)
elif command -v convert >/dev/null 2>&1; then
  converter=(convert)
else
  echo "ImageMagick was not found. Install imagemagick in MSYS2, Scoop, or your Linux package manager." >&2
  exit 1
fi

shopt -s nullglob nocaseglob
png_files=(*.png)

if [ "${#png_files[@]}" -eq 0 ]; then
  echo "No PNG files found."
  exit 0
fi

for png in "${png_files[@]}"; do
  jpg="${png%.*}.jpg"
  "${converter[@]}" "$png" "$jpg"
  echo "Converted: $png -> $jpg"
done
