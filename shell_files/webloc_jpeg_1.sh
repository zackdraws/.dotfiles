#!/bin/bash

# Set the directory to the current working directory or provide a path
DIR="${1:-$(pwd)}"  # Default to current directory if no argument is passed

# Check if the directory exists
if [ ! -d "$DIR" ]; then
  echo "Directory does not exist: $DIR"
  exit 1
fi

# Loop over each .webloc file in the directory
for webloc in "$DIR"/*.webloc; do
  # Check if the file exists and is a .webloc file
  if [ -f "$webloc" ]; then
    # Extract the URL from the .webloc file using xmlstarlet (or xmllint if available)
    url=$(xmlstarlet sel -t -v "//string" "$webloc")

    # If no URL is found in the .webloc file
    if [ -z "$url" ]; then
      echo "No URL found in $webloc"
      continue
    fi

    echo "Processing URL: $url"

    # Set a filename for the screenshot
    output_file="$DIR/$(basename "$webloc" .webloc).png"

    # Take a screenshot using Chromium in headless mode
    chromium --headless --disable-gpu --screenshot="$output_file" --window-size=1280x1024 --virtual-time-budget=5000 "$url"

    # Check if screenshot was successfully taken
    if [ $? -eq 0 ]; then
      echo "Screenshot saved to $output_file"

      # Convert PNG to JPG using ImageMagick
      jpg_output_file="${output_file%.png}.jpg"
      convert "$output_file" "$jpg_output_file"
      if [ $? -eq 0 ]; then
        echo "Converted to JPG: $jpg_output_file"
      else
        echo "Failed to convert to JPG: $jpg_output_file"
      fi

      # Clean up PNG file
      rm "$output_file"
    else
      echo "Failed to capture screenshot for $url"
    fi
  fi
done
