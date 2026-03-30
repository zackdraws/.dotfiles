#!/bin/bash



# Loop through all .PSD files in the current directory

for file in *.psd; do

    if [[ -f "$file" ]]; then

        # Generate output file name by replacing .PSD with .JPEG

        output="${file%.[Pp][Ss][Dd]}.jpg"



        # Run GIMP in batch mode to load the .PSD and save as .JPEG

        gimp -i -b "(define image (car (gimp-file-load RUN-NONINTERACTIVE \"$file\" \"$file\")))" \

               -b "(file-jpeg-save RUN-NONINTERACTIVE image (car (gimp-image-get-active-layer image)) \"$output\" \"$output\" 0.9 0 0 1 1 1 0 0)" \

               -b "(gimp-quit 0)"

        

        # Check if the output file was created

        if [[ -f "$output" ]]; then

            echo "Converted $file to $output"

        else

            echo "Failed to convert $file."

        fi

    else

        echo "No .PSD files found!"

    fi

done
