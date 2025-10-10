#!/bin/bash
# Script to convert all LaTeX files in the current directory to PDF.
# Check if pdflatex is installed
if ! command -v pdflatex &> /dev/null; then
  echo "Error: pdflatex command not found.  Please install a LaTeX distribution
(e.g., TeX Live, MiKTeX)."
  exit 1
fi
# Loop through all .tex files in the current directory
for file in *.tex; do
  # Skip empty files
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
echo "Conversion complete."
