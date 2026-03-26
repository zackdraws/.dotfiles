#!/bin/bash

# Function to show usage
show_usage() {
    echo "Usage: pathconvert [path_or_image]"
    echo "1. Converts between Windows and WSL paths and copies to clipboard"
    echo "2. Copies image files to clipboard"
    echo "3. Extracts and copies image from clipboard path"
    echo ""
    echo "Examples:"
    echo "  Path conversion:"
    echo "    pathconvert C:\\folder\\file"
    echo "    pathconvert /mnt/c/folder/file"
    echo ""
    echo "  Image handling:"
    echo "    pathconvert image.png"
    echo "    pathconvert                  # reads image path from clipboard"
    exit 1
}

# Function to check if file is an image
is_image() {
    local file="$1"
    file --mime-type "$file" | grep -q "image/"
    return $?
}

# Function to get clipboard content
get_clipboard_content() {
    if command -v powershell.exe >/dev/null 2>&1; then
        # WSL environment
        powershell.exe Get-Clipboard
    elif command -v xclip >/dev/null 2>&1; then
        # Linux with xclip
        xclip -selection clipboard -o
    else
        echo "Error: Neither PowerShell (WSL) nor xclip found." >&2
        return 1
    fi
}

# Function to copy image to clipboard
copy_image_to_clipboard() {
    local image_path="$1"
    if command -v powershell.exe >/dev/null 2>&1; then
        # WSL environment - using PowerShell for image copying
        powershell.exe -command "Add-Type -AssemblyName System.Windows.Forms; \$clipboard = [System.Windows.Forms.Clipboard]; \$image = [System.Drawing.Image]::FromFile('$(wslpath -w "$image_path")'); \$clipboard::SetImage(\$image)"
        echo "Image copied to clipboard using PowerShell!"
    elif command -v xclip >/dev/null 2>&1; then
        # Linux with xclip
        xclip -selection clipboard -t image/png -i "$image_path"
        echo "Image copied to clipboard using xclip!"
    else
        echo "Error: Neither PowerShell (WSL) nor xclip found. Please install required tools." >&2
        return 1
    fi
}

# Function to copy text to clipboard
copy_to_clipboard() {
    if command -v clip.exe >/dev/null 2>&1; then
        # WSL environment
        echo -n "$1" | clip.exe
    elif command -v xclip >/dev/null 2>&1; then
        # Linux with xclip
        echo -n "$1" | xclip -selection clipboard
    else
        echo "Warning: Neither clip.exe (WSL) nor xclip found." >&2
        return 1
    fi
}

# Function to convert Windows path to WSL
windows_to_wsl() {
    local drive_letter=$(echo "${1:0:1}" | tr '[:upper:]' '[:lower:]')
    local remaining_path="${1:2}"
    remaining_path=$(echo "$remaining_path" | tr '\\' '/')
    echo "/mnt/${drive_letter}${remaining_path}"
}

# Function to convert WSL path to Windows
wsl_to_windows() {
    local drive_letter=$(echo "${1:5:1}" | tr '[:lower:]' '[:upper:]')
    local remaining_path="${1:6}"
    remaining_path=$(echo "$remaining_path" | tr '/' '\\')
    echo "${drive_letter}:${remaining_path}"
}

# Function to handle image path
handle_image_path() {
    local path="$1"
    
    # Convert Windows path to WSL if needed
    if [[ $path =~ ^[A-Za-z]: ]]; then
        path=$(windows_to_wsl "$path")
    fi

    # Remove any quotes
    path=$(echo "$path" | tr -d '"' | tr -d "'")

    # Check if the file exists and is an image
    if [ -f "$path" ] && is_image "$path"; then
        copy_image_to_clipboard "$path"
        return 0
    fi
    return 1
}

# Main logic
if [ $# -eq 0 ]; then
    # No arguments - try to get path from clipboard
    clipboard_content=$(get_clipboard_content)
    if [ -n "$clipboard_content" ]; then
        if handle_image_path "$clipboard_content"; then
            exit 0
        else
            echo "Clipboard content is not a valid image path"
            show_usage
        fi
    else
        echo "No content in clipboard"
        show_usage
    fi
else
    input="$1"
    
    # Check if input is or contains an image path
    if handle_image_path "$input"; then
        exit 0
    fi

    # Handle path conversion
    if [[ $input =~ ^[A-Za-z]: ]]; then
        result=$(windows_to_wsl "$input")
    elif [[ $input =~ ^/mnt/[a-zA-Z]/ ]]; then
        result=$(wsl_to_windows "$input")
    else
        echo "Error: Invalid path format or file not found" >&2
        echo "Path must be either:" >&2
        echo "  - Windows format (e.g., C:\\folder\\file)" >&2
        echo "  - WSL format (e.g., /mnt/c/folder/file)" >&2
        echo "  - Valid image file path" >&2
        exit 1
    fi

    # Output the result and copy to clipboard
    echo "Converted path: $result"
    if copy_to_clipboard "$result"; then
        echo "Path copied to clipboard!"
    fi
fi
