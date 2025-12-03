#!/bin/bash
# Ask for input and output filenames
echo "Enter the name of the input LaTeX file (e.g., resume.tex):"
read input_file
echo "Enter the name of the output PDF file (e.g., resume_output.pdf):"
read output_file

# Extract the directory and base name
output_dir=$(dirname "$output_file")
output_base=$(basename "$output_file" .pdf)

# Make sure the output directory exists
mkdir -p "$output_dir"

# Compile with XeLaTeX
xelatex -output-directory="$output_dir" -jobname="$output_base" "$input_file"

echo "Compilation complete! Output saved to $output_file"
