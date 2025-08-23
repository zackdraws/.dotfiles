#!/bin/bash

# Check if a file is provided as an argument

if [ -z "$1" ]; then

  echo "Please provide a file to copy."

  exit 1

fi



# Copy the contents of the file to the clipboard

xclip -sel clip < "$1"
