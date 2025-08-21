#!/usr/bin/env fish

function usage
    echo "Usage: $argv[0] <directory_path>"
    echo "This script deletes all files and folders *inside* the specified directory"
    exit 1
end

# Function to convert and print bytes to human-readable format (KiB, MiB, GiB)
function format_size
    set -l bytes $argv[1]

    if test $bytes -lt 1024
        printf "%d B\n" $bytes
    else if test $bytes -lt 1048576
        set -l kib (math --scale=2 "$bytes / 1024")
        echo "$kib KiB"
    else if test $bytes -lt 1073741824
        set -l mib (math --scale=2 "$bytes / (1024 * 1024)")
        echo "$mib MiB"
    else
        set -l gib (math --scale=2 "$bytes / (1024 * 1024 * 1024)")
        echo "$gib GiB"
    end
end

# Argument check
if test (count $argv) -ne 1
    usage
end

set dir_path (realpath $argv[1])

if not test -d "$dir_path"
    echo "Error: Directory '$dir_path' does not exist"
    exit 1
end

# Get initial size (in bytes)
set initial_size (du -sb "$dir_path" | awk '{print $1}')

# Get file and dir lists
set file_list (find "$dir_path" -mindepth 1 -type f)
set dir_list (find "$dir_path" -mindepth 1 -type d)

set file_count (count $file_list)
set dir_count (count $dir_list)

# Show deletion summary
echo "Directory: $dir_path"
echo "Contents to be deleted:"
echo "- Files: $file_count"
echo "- Folders: $dir_count"
echo "- Total size: (format_size $initial_size)"

# Confirm deletion
echo ""
read -P "Type 'yes' to confirm deletion: " confirm
if test "$confirm" != "yes"
    echo "Operation cancelled."
    exit 0
end

read -P "Are you REALLY sure? Type 'yes' again to confirm: " confirm2
if test "$confirm2" != "yes"
    echo "Operation cancelled."
    exit 0
end

# Delete files
for f in $file_list
    rm -f "$f"
end

# Delete directories (deepest first)
for d in (printf '%s\n' $dir_list | sort -r)
    rmdir "$d" 2>/dev/null
end

# Final size
set final_size (du -sb "$dir_path" | awk '{print $1}')
set freed (math "$initial_size - $final_size")

# Final report
echo ""
echo "Deletion completed:"
echo "- Removed $file_count files"
echo "- Removed $dir_count folders"
echo "- Freed (format_size $freed) of space"
#!/usr/bin/env fish

# Show usage help
function usage
    echo "Usage: $argv[0] <directory_path>"
    echo "This script deletes all files and folders *inside* the specified directory"
    exit 1
end

# Format size in binary units (KiB, MiB, GiB)
function format_size
    set -l bytes $argv[1]

    if test $bytes -lt 1024
        printf "%d B\n" $bytes
    else if test $bytes -lt 1048576
        set -l kib (math "scale=2; $bytes / 1024")
        printf "%.2f KiB\n" $kib
    else if test $bytes -lt 1073741824
        set -l mib (math "scale=2; $bytes / (1024 * 1024)")
        printf "%.2f MiB\n" $mib
    else
        set -l gib (math "scale=2; $bytes / (1024 * 1024 * 1024)")
        printf "%.2f GiB\n" $gib
    end
end

# Argument check
if test (count $argv) -ne 1
    usage
end

# Resolve absolute path
set dir_path (realpath $argv[1])

# Check if it's a directory
if not test -d "$dir_path"
    echo "Error: Directory '$dir_path' does not exist"
    exit 1
end

# Get original size
set initial_size (du -sb "$dir_path" | cut -f1)

# Get files and directories (excluding the main dir)
set file_list (find "$dir_path" -mindepth 1 -type f)
set dir_list (find "$dir_path" -mindepth 1 -type d)

set file_count (count $file_list)
set dir_count (count $dir_list)

# Display info before deletion
echo "Directory: $dir_path"
echo "Contents to be deleted:"
echo "- Files: $file_count"
echo "- Folders: $dir_count"
echo "- Total size: (format_size $initial_size)"

# First confirmation
echo ""
echo "WARNING: This will delete ALL files and folders in the directory!"
read -P "Type 'yes' to confirm: " answer
if test "$answer" != "yes"
    echo "Operation cancelled"
    exit 0
end

# Second confirmation
read -P "Are you REALLY sure? Type 'yes' again to confirm: " second_answer
if test "$second_answer" != "yes"
    echo "Operation cancelled"
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

# Get new size
set final_size (du -sb "$dir_path" | cut -f1)
set freed (math "$initial_size - $final_size")

# Final report
echo ""
echo "Deletion completed:"
echo "- Removed $file_count files"
echo "- Removed $dir_count folders"
echo "- Freed (format_size $freed) of space"
