#!/bin/bash

while IFS= read -r filepath || [[ -n "$filepath" ]]; do

    echo "\\includegraphics[width=0.34\\textwidth]{${filepath}}"

done
