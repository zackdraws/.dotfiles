#!/bin/bash

set -e
command -v emacs >/dev/null 2>&1 || { echo "Emacs not found."; exit 1; }
command -v pandoc >/dev/null 2>&1 || { echo "Pandoc not found."; exit 1; }

ORG_FILE="$1"

if [[ -z "$ORG_FILE" ]]; then
  echo "Usage: $0 file.org"
  exit 1
fi

if [[ ! -f "$ORG_FILE" ]]; then
  echo "File not found: $ORG_FILE"
  exit 1
fi

BASENAME=$(basename "$ORG_FILE" .org)E}.md"
DOCX
MD_FILE="${BASENAM_FILE="${BASENAME}.docx"
emacs "$ORG_FILE" --batch \
  --eval="(progn
             (find-file \"$ORG_FILE\")
             (org-md-export-to-markdown)
             (kill-emacs))"
pandoc "$MD_FILE" -o "$DOCX_FILE"
echo "✅ Exported: $DOCX_FILE"
