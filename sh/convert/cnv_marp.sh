#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 presentation.md"
    exit 1
fi

INPUT="$1"

if [[ ! -f "$INPUT" ]]; then
    echo "File not found: $INPUT"
    exit 1
fi

BASE="${INPUT%.*}"

echo "Generating PDF..."
marp --pdf "$INPUT" -o "${BASE}.pdf"

echo "Generating PowerPoint..."
marp --pptx "$INPUT" -o "${BASE}.pptx"

echo "Done:"
echo "  ${BASE}.pdf"
echo "  ${BASE}.pptx"
