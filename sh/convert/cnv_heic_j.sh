#!/bin/bash
for file in *.HEIC; do
  echo "Processing $file"
  # Create a temp file for stripped metadata
  tmpfile="${file%.HEIC}_stripped.HEIC"
  # Strip all metadata
  exiftool -all= -overwrite_original -o "$tmpfile" "$file"
  # Convert stripped HEIC to JPG
  heif-convert "$tmpfile" "${file%.HEIC}.jpg"
  # Remove temp stripped file
  rm "$tmpfile"
  echo "Converted $file to ${file%.HEIC}.jpg without metadata"
done
