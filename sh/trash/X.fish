#!/usr/bin/env fish

function usage
    echo "Usage: $argv[0] <directory_path>"
    echo "This script deletes all contents inside the specified directory"
    exit 1
end

# Format bytes into binary units (KiB / MiB / GiB) with fixed 2-decimal precision
function format_size
    set -l bytes $argv[1]

    if test $bytes -lt 1024
        printf "%d B\n" $bytes
    else if test $bytes -lt 1048576
        set -l kib (math --scale=2 "$bytes / 1024")
        printf "%.2f KiB\n" $kib
    else if test $bytes -lt 1073741824
        set -l mib (math --scale=2 "$bytes / (1024 * 1024)")
        printf "%.2f MiB\n" $mib
    else
        set -l gib (math --scale=2 "$bytes / (1024 * 1024 * 1024)")
        printf "%.2f GiB\n" $gib
    end
end

# Ensure one argument is provided
if test (count $argv) -ne 1
    usage
end

set dir_path (realpath $argv[1])

if not test -d "$dir_path"
    echo "Error: Directory '$dir_path' does not exist"
    exit 1
end

# Get initial size in bytes
set initial_size (du -sb --apparent-size $dir_path | awk '{print $1}')

# Get file and directory lists
set file_list (find $dir_path -mindepth 1 -type f)
set dir_list (find $dir_path -mindepth 1 -type d)

set file_count (count $file_list)
set dir_count (count $dir_list)

# Show pre-deletion summary
echo "Directory: $dir_path"
echo "Contents to be deleted:"
echo "- Files: $file_count"
echo "- Folders: $dir_count"
echo "- Total size: (format_size $initial_size)"

echo ""
read -P "Type 'yes' to confirm deletion: " confirm
if test "$confirm" != "yes"
    echo "Cancelled."
    exit 0
end

read -P "Type 'yes' again to proceed: " confirm2
if test "$confirm2" != "yes"
    echo "Cancelled."
    exit 0
end

# Delete files
for f in $file_list
    rm -f "$f"
end

# Delete directories in reverse depth order
for d in (printf '%s\n' $dir_list | sort -r)
    rmdir "$d" 2>/dev/null
end

# Calculate freed space
set final_size (du -sb --apparent-size $dir_path | awk '{print $1}')
set freed (math "$initial_size - $final_size")

# Display results
echo ""
echo "Deletion completed:"
echo "- Removed $file_count files"
echo "- Removed $dir_count folders"
echo "- Freed (format_size $freed) of space"
