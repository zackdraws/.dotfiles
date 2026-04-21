#!/bin/bash
echo "File to save?"
read input_file
echo "Save as?"
read output_file
pandoc "$input_file" -o "$output_file" --pdf-engine=xelatex \
  --variable mainfont="CascadiaCode-Regular" \
  --variable geometry:"left=0.01in, right=0.01in, top=0.01in, bottom=0.01in"
echo "Export complete! Output saved to $output_file"
