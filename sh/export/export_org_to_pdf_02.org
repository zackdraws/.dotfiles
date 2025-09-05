#!/bin/bash

# Ask for input and output filenames
echo "Enter the name of the input Org file (e.g., office_hours.org):"
read input_file

echo "Enter the name of the output PDF file (e.g., office_hours_output.pdf):"
read output_file

# Run pandoc with the provided input and output file
pandoc "$input_file" -o "$output_file" --pdf-engine=xelatex \
  --variable mainfont="CascadiaCode-Regular" \
  --variable geometry:"left=0.90in, right=0.90in, top=0.35in, bottom=0.35in"

echo "Export complete! Output saved to $output_file"
