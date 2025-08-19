#!/usr/bin/env python3

import cv2
import numpy as np
from pathlib import Path

input_dir = Path('.')
output_dir = input_dir / 'mattes'
output_dir.mkdir(exist_ok=True)

print(f"🎨 Auto-Fill Matte Generator running in: {input_dir.resolve()}")

for file in input_dir.glob("*.png"):
    print(f"👉 Processing: {file.name}")
    img = cv2.imread(str(file), cv2.IMREAD_UNCHANGED)

    if img is None or img.shape[2] != 4:
        print(f"⚠️ Skipping {file.name} (not a valid RGBA PNG)")
        continue

    height, width = img.shape[:2]
    alpha = img[:, :, 3]

    # Create binary mask from alpha (non-transparent = line)
    mask = alpha > 0

    # Convert to 8-bit single channel
    mask_uint8 = (mask * 255).astype(np.uint8)

    # Fill holes inside contours
    contours, _ = cv2.findContours(mask_uint8, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

    filled = np.zeros((height, width), dtype=np.uint8)
    cv2.drawContours(filled, contours, -1, 255, thickness=cv2.FILLED)

    # Make output RGBA matte
    matte = np.zeros((height, width, 4), dtype=np.uint8)
    matte[:, :, 3] = filled  # Alpha channel from filled mask
    matte[:, :, :3] = 255    # White RGB

    # Save result
    output_path = output_dir / f"{file.stem}_matte.png"
    cv2.imwrite(str(output_path), matte)
    print(f"✅ Saved: {output_path.name}")

print(f"🎉 Done! Mattes saved to: {output_dir.resolve()}")
