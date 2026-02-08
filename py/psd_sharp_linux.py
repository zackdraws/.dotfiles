#!/usr/bin/env python3
import os
from PIL import Image, ImageEnhance, ImageOps
cwd = os.getcwd()
image_extensions = (".png", ".jpg", ".jpeg", ".bmp", ".tiff")
for filename in os.listdir(cwd):
    if filename.lower().endswith(image_extensions):
        input_path = os.path.join(cwd, filename)
        name, ext = os.path.splitext(filename)
        output_filename = f"{name}_sharp{ext}"
        output_path = os.path.join(cwd, output_filename)
        try:
            with Image.open(input_path) as im:
                img = im.convert("L")
                img = ImageOps.autocontrast(img, cutoff=2)
                img = ImageEnhance.Contrast(img).enhance(1.3)
                img = ImageEnhance.Sharpness(img).enhance(2.0)
                img.save(output_path)
                print(f"✅ {filename} → {output_filename}")
        except Exception as e:
            print(f"❌ Error processing {filename}: {e}")
print("\n🎉 Done! Pencil drawings enhanced with auto-levels and sharpening.")
