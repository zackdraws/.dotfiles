#!/bin/bash



# Define full path to Photoshop executable

PHOTOSHOP_PATH="/mnt/c/Program Files/Adobe/Adobe Photoshop 2023/Photoshop.exe"



# Full Windows-style path to your JSX script (with double backslashes)

JSX_SCRIPT_PATH="C:\\Users\\zacha\\scripts\\new_canvas.jsx"



# Execute Photoshop with script

"$PHOTOSHOP_PATH" -r "$JSX_SCRIPT_PATH"
