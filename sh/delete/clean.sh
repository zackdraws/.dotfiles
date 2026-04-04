#!/bin/bash
# this is a script to delete a folder
usage() {
    echo "Usage: $0 <directory_path>"
    echo "This script deletes all files and folders in the specified directory"
    exit 1
}
format_size() {
    local size=$1
    local units=("B" "KB" "MB" "GB" "TB")
    local unit=0
    while ((size > 1024 && unit < ${#units[@]}-1)); do
        size=$(echo "scale=2; $size/1024" | bc)
        ((unit++))
    done
    printf "%.2f %s" $size "${units[$unit]}"
}
if [ $# -ne 1 ]; then
    usage
fi
dir_path=$(realpath "$1")
if [ ! -d "$dir_path" ]; then
    echo "Error: Directory '$dir_path' does not exist"
    exit 1
fi
total_size=$(du -sb "$dir_path" | cut -f1)
dir_size=$((total_size - $(du -sb "$dir_path/." | cut -f1)))
file_count=$(find "$dir_path" -type f | wc -l)
dir_count=$(find "$dir_path" -type d | wc -l)
((dir_count--))
echo "Directory: $dir_path"
echo "Contents to be deleted:"
echo "- Total size: $(format_size $dir_size)"
echo "- Files: $file_count"
echo "- Folders: $dir_count"
echo -e "\nWARNING: This will delete ALL files and folders in the directory!"
echo "This is a recursive deletion and cannot be undone!"
echo -n "Type 'yes' to confirm: "
read -r answer
if [ "$answer" != "yes" ]; then
    echo "Operation cancelled"
    exit 0
fi
echo -n "Are you REALLY sure? This cannot be undone! (Type 'yes' again): "
read -r second_answer
if [ "$second_answer" != "yes" ]; then
    echo "Operation cancelled"
    exit 0
fi
..
find "$dir_path" -mindepth 1 -delete
echo -e "\nDeletion completed:"
echo "- Removed $file_count files"
echo "- Removed $dir_count folders"
echo "- Freed $(format_size $dir_size) of space"
