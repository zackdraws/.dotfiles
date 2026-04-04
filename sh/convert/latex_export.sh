#!/bin/bash
# convert all LaTeX files 
# to pdf
if ! command -v pdflatex &> /dev/null; then
  echo "Error: pdflatex command not found.  Please install a LaTeX distribution
(e.g., TeX Live, MiKTeX)."
  exit 1
fi
for file in *.tex; do
if [ -z "$file" ]; then
continue
fi
# Extract the base filename without the extension
filename=$(basename "$file" .tex)
# Construct the output PDF filename
output_pdf="${filename}.pdf"
# Convert the LaTeX file to PDF using pdflatex
pdflatex "$file"  # -output-directory is handled by pdflatex itself
# Check if pdflatex was successful
if [ $? -eq 0 ]; then
echo "Successfully converted: $file to $output_pdf"
else
echo "Error converting: $file"
fi
done
echo "ok"
