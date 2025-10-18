#!/bin/bash



# Use the current directory

find . -type f -name "*.psd" | while read psd_file; do

    # Set the output JPEG file name by replacing the .psd extension with .jpg

    output_file="${psd_file%.psd}.jpg"

    

    # Run the convert command to flatten and save the output as .jpg

    convert "$psd_file" -flatten "$output_file"

done
