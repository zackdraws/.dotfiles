#!/usr/bin/env fish
# Loop through all .JFIF or .jfif files in the current directory
for file in *.jfif *.JFIF
if test -f $file
echo "Processing $file..."
set output (string replace -r '\.jfif$' '.jpeg' $file)
echo "Output file: $output" 
if type -q convert
convert $file $output
echo "Converted $file to $output using ImageMagick."
else
echo "ImageMagick (convert command) is not installed. Please install it to proceed."
exit 1
end
else
echo "No .JFIF files found!"
end
end
