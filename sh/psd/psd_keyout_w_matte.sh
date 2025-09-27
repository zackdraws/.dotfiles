#!/bin/bash
set -e
echo "🧼 Running softer subject detection and matte fill..."
# Ensure Python 3 is available
if ! command -v python3 &>/dev/null; then
    echo "❌ Python 3 is required."
    exit 1
fi
# Install Python deps if missing
python3 - <<EOF
try:
    import cv2
    import numpy
except ImportError:
    print("📦 Installing OpenCV and NumPy...")
    import subprocess
    subprocess.check_call(["pip3", "install", "--user", "opencv-python", "numpy"])
EOF
# Process all .jpg/.jpeg images
for file in *.jpg *.jpeg; do
    if [ ! -f "$file" ]; then
        continue
    fi
    base="${file%.*}"
    output="${base}_softmatte.png"
    echo "🎨 Processing: $file → $output"
    python3 - <<EOF
import cv2
import numpy as np
input_path = "$file"
output_path = "$output"
# Load and prep image
image = cv2.imread(input_path)
if image is None:
    raise ValueError("Could not read image.")

h, w = image.shape[:2]

# Step 1: Convert to grayscale and blur slightly

gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

blurred = cv2.GaussianBlur(gray, (5, 5), 0)

# Step 2: Adaptive threshold to gently pull subject from white bg

thresh = cv2.adaptiveThreshold(

    blurred, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C,

    cv2.THRESH_BINARY_INV, 11, 2

)
# Step 3: Find the largest contour (assumed to be subject)

contours, _ = cv2.findContours(thresh, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

if not contours:

    raise ValueError("No subject found.")

# Get the largest contour
main_contour = max(contours, key=cv2.contourArea)

# Create subject mask

subject_mask = np.zeros((h, w), dtype=np.uint8)

cv2.drawContours(subject_mask, [main_contour], -1, 255, thickness=cv2.FILLED)



# Optionally dilate a bit to give a little margin around subject

kernel = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (15, 15))

expanded_mask = cv2.dilate(subject_mask, kernel, iterations=1)



# Step 4: Create matte — light yellow-grey (BGR: 180, 240, 220)

matte_color = np.array([180, 240, 220, 255], dtype=np.uint8)

matte = np.zeros((h, w, 4), dtype=np.uint8)

matte[:, :] = matte_color

for c in range(4):

    matte[:, :, c] = matte[:, :, c] * (expanded_mask // 255)



# Step 5: Remove white from original image → create alpha

white_mask = cv2.inRange(image, (200, 200, 200), (255, 255, 255))

alpha = cv2.bitwise_not(white_mask)



# Add alpha to original image

image_bgra = cv2.cvtColor(image, cv2.COLOR_BGR2BGRA)

image_bgra[:, :, 3] = alpha



# Composite: put subject image over matte (only where subject mask exists)

subject_area = expanded_mask > 0

foreground = image_bgra[:, :, :3].astype(np.float32)

bg = matte[:, :, :3].astype(np.float32)

alpha_fg = (image_bgra[:, :, 3] / 255.0)[:, :, np.newaxis]



composite_rgb = (foreground * alpha_fg + bg * (1 - alpha_fg)).astype(np.uint8)



# Final alpha: only where expanded subject mask exists

final_alpha = np.where(subject_area, 255, 0).astype(np.uint8)



# Merge and save

final_image = cv2.merge((composite_rgb, final_alpha))

cv2.imwrite(output_path, final_image)



print(f"✅ Output saved: {output_path}")

EOF



done



echo "✅ Done. Matte added gently behind subject only. Outside is transparent."
