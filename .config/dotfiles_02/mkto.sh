#!/bin/bash



# Get date for the title: yyyy-mm-dd Day 00:00

formatted_title=$(date +"%Y-%m-%d %A 00:00")



# Get date for the filename: yyyymmddhhmm

formatted_filename=$(date +"%Y%m%d%H%M")



# Final filename

filename="${formatted_filename}.org"



# Write the content to the file

cat <<EOF > "$filename"

#+title: $formatted_title



* Today's todo's

* 1



* 2



* 3

EOF



# Open in Emacs (optional — uncomment if needed)

# emacs "$filename"



# Confirm creation

echo "Created file: $filename"
