#!/usr/bin/env fish



# Target 

set crop_width 1179

set crop_height 1510

set x_offset 0

set y_offset 460

set crop_geometry "$crop_width"x"$crop_height"+"$x_offset"+"$y_offset"



# Loop 

for file in *.png *.PNG *.jpg

    if test -f "$file"

        set base (string replace -r '\.[^.]*$' '' "$file")

        set ext (string match -r '\.[^.]*$' "$file")

        set output_file "$base"_cropped"$ext"



        echo "Cropping $file -> $output_file"

        convert "$file" -crop "$crop_geometry" +repage "$output_file"

    end

end
