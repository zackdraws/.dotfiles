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

# Read the file content and format it with [[ and ]]
content=$(cat "$filename")

# Escape special characters for clipboard compatibility (important for shell interpretation)
escaped_content=$(echo "$content" | sed 's/[\[\]]/\\&/g')


# Export the escaped content to the clipboard
# The `xclip -selection clipboard` command is commonly used for clipboard manipulation
# If you don't have xclip, you might need to install it:  sudo apt-get install xclip
# Or you can use `xsel` instead: sudo apt-get install xsel
#  Consider using `pbcopy` (macOS compatible) for macOS users.

if command -v xclip > /dev/null 2>&1; then
  echo "$escaped_content" | xclip -selection clipboard
  echo "File content with [[ and ]] copied to clipboard using xclip."
elif command -v xsel > /dev/null 2>&1; then
  echo "$escaped_content" | xsel -b -i
  echo "File content with [[ and ]] copied to clipboard using xsel."
elif command -v pbcopy > /dev/null 2>&1; then
  echo "$escaped_content" | pbcopy
  echo "File content with [[ and ]] copied to clipboard using pbcopy (macOS)."
else
  echo "Error:  No clipboard tool found (xclip, xsel, or pbcopy).  Please install one."
  exit 1
fi

exit 0
`
