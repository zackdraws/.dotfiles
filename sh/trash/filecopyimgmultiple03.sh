#!/bin/bash

# Function to show usage
show_usage() {
    echo "Usage: pathconvert [path_or_image ...]"
    echo "1. Converts between Windows and WSL paths"
    echo "2. Copies multiple images to Windows clipboard history"
    echo ""
    echo "Examples:"
    echo "  Multiple images:"
    echo "    pathconvert image1.jpg image2.jpg"
    echo "    # Or paste multiple paths and run:"
    echo "    pathconvert"
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
        powershell.exe Get-Clipboard | tr -d '\r'
    elif command -v xclip >/dev/null 2>&1; then
        xclip -selection clipboard -o
    else
        echo "Error: Neither PowerShell (WSL) nor xclip found." >&2
        return 1
    fi
}

# Function to copy image to clipboard using PowerShell
copy_image_powershell() {
    local image_path="$1"
    local win_path=$(wslpath -w "$image_path")
    # Copy each image individually to the clipboard history
    powershell.exe -command "
        Add-Type -AssemblyName System.Windows.Forms;
        Add-Type -AssemblyName System.Drawing;
        \$image = [System.Drawing.Image]::FromFile('$win_path');
        [System.Windows.Forms.Clipboard]::SetImage(\$image);
        \$image.Dispose();
        Start-Sleep -Milliseconds 500;
    "
}

# Function to process multiple images
process_images() {
    local valid_images=()
    local total_images=0

    # Process each input path
    while IFS= read -r path; do
        # Skip empty lines
        [ -z "$path" ] && continue
        
        # Convert Windows path to WSL if needed
        if [[ $path =~ ^[A-Za-z]: ]]; then
            path=$(windows_to_wsl "$path")
        fi

        # Remove any quotes and trim whitespace
        path=$(echo "$path" | tr -d '"' | tr -d "'" | xargs)

        # Check if the file exists and is an image
        if [ -f "$path" ] && is_image "$path"; then
            valid_images+=("$path")
            ((total_images++))
            echo "Processing image: $path"
        else
            echo "Warning: Invalid or non-existent image: $path" >&2
        fi
    done

    if [ ${#valid_images[@]} -eq 0 ]; then
        echo "No valid images found." >&2
        return 1
    fi

    # Process each image
    echo "Copying ${#valid_images[@]} images to clipboard history..."
    for image in "${valid_images[@]}"; do
        echo "Copying: $image"
        copy_image_powershell "$image"
    done
    
    echo "All images copied to clipboard history!"
    echo "Press Windows + V to view and paste them"
}

# Function to convert Windows path to WSL
windows_to_wsl() {
    local drive_letter=$(echo "${1:0:1}" | tr '[:upper:]' '[:lower:]')
    local remaining_path="${1:2}"
    remaining_path=$(echo "$remaining_path" | tr '\\' '/')
    echo "/mnt/${drive_letter}${remaining_path}"
}

# Main logic
if [ $# -eq 0 ]; then
    # No arguments - try to get paths from clipboard
    clipboard_content=$(get_clipboard_content)
    if [ -n "$clipboard_content" ]; then
        echo "$clipboard_content" | process_images
    else
        echo "No content in clipboard"
        show_usage
    fi
else
    # Handle multiple arguments
    printf "%s\n" "$@" | process_images
fi
