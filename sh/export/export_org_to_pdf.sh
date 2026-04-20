#!/bin/bash
echo "org file name?"
read input_file
echo "save as?"
read output_file
pandoc "$input_file" -o "$output_file" --pdf-engine=xelatex \
  --variable mainfont="Europa" \
  --variable geometry:"left=0.90in, right=0.90in, top=0.50in, bottom=0.35in"
echo "Export complete! Output saved to $output_file"
