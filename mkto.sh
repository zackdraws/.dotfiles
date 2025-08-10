#!/bin/bash
# Format title with active Org timestamp: <yyyy-mm-dd Day 00:00>
formatted_title=$(date +"<%Y-%m-%d %a 00:00>")
# Filename: yyyymmdd.org
formatted_filename=$(date +"%Y%m%d")
filename="${formatted_filename}.org"
cat <<EOF > "$filename"
#+title: $formatted_title
* Today's todo's
* 1



* 2



* 3

EOF

# Open in Emacs terminal mode
emacs -nw "$filename"
# Confirm after Emacs exits
echo "Created and opened file: $filename"
