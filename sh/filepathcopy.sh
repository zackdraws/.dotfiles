#!/bin/bash

# Function to copy to clipboard
copy_to_clipboard() {
    if command -v clip.exe >/dev/null 2>&1; then
        # WSL environment
        echo -n "$1" | clip.exe
    elif command -v xclip >/dev/null 2>&1; then
        # Linux with xclip
        echo -n "$1" | xclip -selection clipboard
    else
        echo "Warning: Neither clip.exe (WSL) nor xclip found. Please install xclip for clipboard support." >&2
        return 1
    fi
}

# Function to show usage
show_usage() {
    echo "Usage: pathconvert <path>"
    echo "Converts between Windows and WSL path formats and copies to clipboard."
    echo ""
    echo "Examples:"
    echo "  Windows to WSL:"
    echo "    pathconvert C:\\folder\\file"
    echo "  WSL to Windows:"
    echo "    pathconvert /mnt/c/folder/file"
    exit 1
}

# Check if argument is provided
if [ $# -ne 1 ]; then
    show_usage
fi

path="$1"

# Function to convert Windows path to WSL
windows_to_wsl() {
    local drive_letter=$(echo "${1:0:1}" | tr '[:upper:]' '[:lower:]')
    local remaining_path="${1:2}"
    # Convert backslashes to forward slashes and remove any leading slash
    remaining_path=$(echo "$remaining_path" | tr '\\' '/')
    echo "/mnt/${drive_letter}${remaining_path}"
}

# Function to convert WSL path to Windows
wsl_to_windows() {
    local drive_letter=$(echo "${1:5:1}" | tr '[:lower:]' '[:upper:]')
    local remaining_path="${1:6}"
    # Convert forward slashes to backslashes
    remaining_path=$(echo "$remaining_path" | tr '/' '\\')
    echo "${drive_letter}:${remaining_path}"
}

# Convert the path and store result
if [[ $path =~ ^[A-Za-z]: ]]; then
    result=$(windows_to_wsl "$path")
elif [[ $path =~ ^/mnt/[a-zA-Z]/ ]]; then
    result=$(wsl_to_windows "$path")
else
    echo "Error: Invalid path format" >&2
    echo "Path must be either:" >&2
    echo "  Windows format (e.g., C:\\folder\\file)" >&2
    echo "  WSL format (e.g., /mnt/c/folder/file)" >&2
    exit 1
fi

# Output the result and copy to clipboard
echo "Converted path: $result"
if copy_to_clipboard "$result"; then
    echo "Path copied to clipboard!"
fi
