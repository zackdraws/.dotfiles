#!/bin/bash

INPUT_DIR="${1:-.}"
OUTPUT="merged.pdf"

# Find PDFs, sort alphabetically, merge
find "$INPUT_DIR" -maxdepth 1 -type f -iname "*.pdf" \
  | sort \
  | xargs pdfunite \
  "$OUTPUT"

echo "Created $OUTPUT"
