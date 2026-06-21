#!/bin/bash



# Exit if any command fails

set -e



echo "📂 Processing all JPEGs in: $(pwd)"



# Check for Python3

if ! command -v python3 &>/dev/null; then

    echo "❌ Python3 is not installed. Please install it first."

    exit 1

fi



# Auto-install Python dependencies if needed

python3 - <<EOF

try:

    import cv2

    import numpy

except ImportError:

    print("📦 Installing required Python packages...")

    import subprocess

    subprocess.check_call(["pip3", "install", "--user", "opencv-python", "numpy"])

EOF



# Loop through all .jpg and .jpeg files

for file in *.jpg *.jpeg; do

    # Check that the file exists (in case no match)

    if [ ! -e "$file" ]; then

        continue

    fi



    base="${file%.*}"

    output="${base}_transparent.png"



    echo "🎨 Processing: $file → $output"



    # Run the Python processing code

    python3 - <<EOF

import cv2

import numpy as np



input_path = "$file"

output_path = "$output"



image = cv2.imread(input_path)

if image is None:

    raise ValueError("Failed to load image: " + input_path)



image_rgba = cv2.cvtColor(image, cv2.COLOR_BGR2BGRA)



lower_white = np.array([200, 200, 200, 255], dtype=np.uint8)

upper_white = np.array([255, 255, 255, 255], dtype=np.uint8)



white_mask = cv2.inRange(image_rgba, lower_white, upper_white)

image_rgba[white_mask == 255] = [0, 0, 0, 0]



cv2.imwrite(output_path, image_rgba)

print(f"✅ Saved: {output_path}")

EOF



done



echo "✅ Done processing all images."
