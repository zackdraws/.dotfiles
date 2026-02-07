#!/usr/bin/env python3
import os
from PIL import Image, ImageEnhance, ImageOps
# Get current working directory
cwd = os.getcwd()
# Supported image file extensions
image_extensions = (".png", ".jpg", ".jpeg", ".bmp", ".tiff")
# Process each image in the current folder
for filename in os.listdir(cwd):
    if filename.lower().endswith(image_extensions):
        input_path = os.path.join(cwd, filename)
        name, ext = os.path.splitext(filename)
        output_filename = f"{name}_white{ext}"
        output_path = os.path.join(cwd, output_filename)
        try:
            with Image.open(input_path).convert("L") as img:
                # Auto contrast: stretch levels while keeping shadows/highlights clean
                img = ImageOps.autocontrast(img, cutoff=1)

                # Brighten the image to push grays toward white
                img = ImageEnhance.Brightness(img).enhance(1.3)

                # Optional: enhance contrast to preserve pencil lines
                img = ImageEnhance.Contrast(img).enhance(1.2)

                # Optional: sharpen strokes
                img = ImageEnhance.Sharpness(img).enhance(1.5)

                img.save(output_path)
                print(f"✅ {filename} → {output_filename}")
        except Exception as e:
            print(f"❌ Error processing {filename}: {e}")
print("\n📄 Done! Pencil drawings whitened and cleaned up.")
