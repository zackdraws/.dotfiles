#!/usr/bin/env fish



# Loop through all .JFIF or .jfif files in the current directory

for file in *.jfif *.JFIF

    # Check if the file exists

    if test -f $file

        echo "Processing $file..."



        # Generate output file name by replacing .JFIF or .jfif with .JPEG

        set output (string replace -r '\.jfif$' '.jpeg' $file)

        echo "Output file: $output"  # Debugging: Show the output file



        # Convert .JFIF to .JPEG using ImageMagick (convert command)

        if type -q convert

            # Use ImageMagick (convert command)

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
