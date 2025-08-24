#!/bin/bash

# Generate Org-mode active timestamp for the title
formatted_title=$(date +"<%Y-%m-%d %a 00:00>")

# Create a unique filename like: 202508241430.org
formatted_filename=$(date +"%Y%m%d%H%M")
filename="${formatted_filename}.org"

# Write Org-mode content into the new file
cat <<EOF > "$filename"
#+title: $formatted_title

* Today's todos

* 1


* 2


* 3

EOF

# Open the file in Emacs terminal mode
emacs -nw "$filename"

# Confirmation message after Emacs exits
echo "✅ Created and opened file: $filename"
