#!/bin/bash

# Use the current directory

find . -type f -name "*.psd" | while read psd_file; do

    # outputs file as jpeg

    output_file="${psd_file%.psd}.jpg"

    

    # Run the convert command to flatten and save the output as .jpg

    convert "$psd_file" -flatten "$output_file"

done
