#!/bin/bash



cd /mnt/c/s/em/O/

counter=1

for file in 

do

  new_name="_$(printf "%02d" $counter)"

  mv "$file.png" "$new_name.png"

  ((counter++))

done
