#!/bin/bash

# Function to show usage
show_usage() {
    echo "Usage: pathconvert [path_or_image ...]"
    echo "1. Converts between Windows and WSL paths and copies to clipboard"
    echo "2. Combines multiple images into a contact sheet and copies to clipboard"
    echo ""
    echo "Examples:"
    echo "  Path conversion:"
    echo "    pathconvert C:\\folder\\file"
    echo ""
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
        # WSL environment
        powershell.exe Get-Clipboard | tr -d '\r'
    elif command -v xclip >/dev/null 2>&1; then
        # Linux with xclip
        xclip -selection clipboard -o
    else
        echo "Error: Neither PowerShell (WSL) nor xclip found." >&2
        return 1
    fi
}

# Function to create temporary directory
create_temp_dir() {
    mktemp -d
}

# Function to combine images and copy to clipboard
combine_and_copy_images() {
    local temp_dir=$(create_temp_dir)
    local output_file="${temp_dir}/combined_image.png"
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
            echo "Added image: $path"
        else
            echo "Warning: Invalid or non-existent image: $path" >&2
        fi
    done

    if [ ${#valid_images[@]} -eq 0 ]; then
        echo "No valid images found." >&2
        rm -rf "$temp_dir"
        return 1
    fi

    if [ ${#valid_images[@]} -eq 1 ]; then
        # If only one image, copy it directly
        copy_image_to_clipboard "${valid_images[0]}"
    else
        # Calculate grid dimensions
        local cols=$(echo "sqrt($total_images)" | bc)
        cols=$((cols + 1))
        
        # Combine images using ImageMagick
        montage "${valid_images[@]}" -tile ${cols}x -geometry +5+5 "$output_file"
        copy_image_to_clipboard "$output_file"
    fi

    # Cleanup
    rm -rf "$temp_dir"
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

# Main logic
if [ $# -eq 0 ]; then
    # No arguments - try to get paths from clipboard
    clipboard_content=$(get_clipboard_content)
    if [ -n "$clipboard_content" ]; then
        echo "$clipboard_content" | combine_and_copy_images
    else
        echo "No content in clipboard"
        show_usage
    fi
else
    # Handle multiple arguments
    printf "%s\n" "$@" | combine_and_copy_images
fi
