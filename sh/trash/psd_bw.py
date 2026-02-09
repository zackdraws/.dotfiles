#!/usr/bin/env python3
import os
from PIL import Image
# Get current working directory
cwd = os.getcwd()
# Supported image file extensions
image_extensions = (".png", ".jpg", ".jpeg", ".bmp", ".tiff")
# Process each image in the current folder
for filename in os.listdir(cwd):
    if filename.lower().endswith(image_extensions):
        input_path = os.path.join(cwd, filename)
        name, ext = os.path.splitext(filename)
        output_filename = f"{name}_bw{ext}"
        output_path = os.path.join(cwd, output_filename)
        try:
            with Image.open(input_path) as img:
                # Convert image to grayscale
                bw_img = img.convert("L")
                bw_img.save(output_path)
                print(f"✅ {filename} → {output_filename}")
        except Exception as e:
            print(f"❌ Error processing {filename}: {e}")
print("\n🖤 Done! Images converted to black and white.")
