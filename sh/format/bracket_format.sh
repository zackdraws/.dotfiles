#!/bin/bash



# Prompt the user for the filename

read -p "Enter the filename (e.g., myfile.txt): " filename



# Check if the filename is provided

if [ -z "$filename" ]; then

  echo "Error: Filename cannot be empty."

  exit 1

fi



# Check if the file exists

if [ ! -f "$filename" ]; then

  echo "Error: File '$filename' not found."

  exit 1

fi



# Add [[ at the start and ]] at the end of each line

formatted_content=$(sed 's/^/[[/; s/$/]]/' "$filename")



# Copy the formatted content to the clipboard

if command -v xclip > /dev/null 2>&1; then

  echo "$formatted_content" | xclip -selection clipboard

  echo "Formatted content copied to clipboard using xclip."

elif command -v xsel > /dev/null 2>&1; then

  echo "$formatted_content" | xsel -b -i

  echo "Formatted content copied to clipboard using xsel."

elif command -v pbcopy > /dev/null 2>&1; then

  echo "$formatted_content" | pbcopy

  echo "Formatted content copied to clipboard using pbcopy (macOS)."

else

  echo "Error: No clipboard tool found (xclip, xsel, or pbcopy). Please install one."

  exit 1

fi



exit 0
