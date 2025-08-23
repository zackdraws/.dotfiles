#!/usr/bin/env fish

function usage
    echo "Usage: $argv[0] <directory_path>"
    echo "This script deletes all files and folders in the specified directory"
    exit 1
end

# Function to format size nicely
function format_size
    set -l size $argv[1]
    set -l units B KB MB GB TB
    set -l unit 0

    while test $size -gt 1024
        set size (math "scale=2; $size / 1024")
        set unit (math "$unit + 1")
        if test $unit -ge (count $units) - 1
            break
        end
    end

    printf "%.2f %s\n" $size $units[$unit+1]
end

# Check if argument given
if test (count $argv) -ne 1
    usage
end

# Get full path
set dir_path (realpath $argv[1])

if not test -d "$dir_path"
    echo "Error: Directory '$dir_path' does not exist"
    exit 1
end

# Initial size in bytes
set initial_size (du -sb $dir_path | cut -f1)

# Count files and dirs
set file_list (find $dir_path -mindepth 1 -type f)
set dir_list (find $dir_path -mindepth 1 -type d)

set file_count (count $file_list)
set dir_count (count $dir_list)

echo "Directory: $dir_path"
echo "Contents to be deleted:"
echo "- Files: $file_count"
echo "- Folders: $dir_count"
echo "- Total size: (format_size $initial_size)"

echo ""
echo "WARNING: This will delete ALL files and folders in the directory!"
read -P "Type 'yes' to confirm: " answer

if test "$answer" != "yes"
    echo "Operation cancelled"
    exit 0
end

read -P "Are you REALLY sure? Type 'yes' again to confirm: " second_answer
if test "$second_answer" != "yes"
    echo "Operation cancelled"
    exit 0
end

# Delete files
for f in $file_list
    rm -f $f
end

# Delete dirs in reverse order
for d in (printf '%s\n' $dir_list | sort -r)
    rmdir $d 2>/dev/null
end

# Final size
set final_size (du -sb $dir_path | cut -f1)
set freed (math "$initial_size - $final_size")

echo ""
echo "Deletion completed:"
echo "- Removed $file_count files"
echo "- Removed $dir_count folders"
echo "- Freed (format_size $freed) of space"
