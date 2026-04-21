#!/bin/bash
if ! command -v pdflatex &> /dev/null; then
  echo "Error: pdflatex command not found.  Please install a LaTeX distribution
(e.g., TeX Live, MiKTeX)."
  exit 1
fi
for file in *.tex; do
if [ -z "$file" ]; then
continue
fi
filename=$(basename "$file" .tex)
output_pdf="${filename}.pdf"
# Convert the LaTeX file to PDF using pdflatex
pdflatex "$file" 
if [ $? -eq 0 ]; then
echo "Successfully converted: $file to $output_pdf"
else
echo "Error converting: $file"
fi
done
echo "ok"
