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

    # Create binary mask from alpha (non-transparent = lines)
    mask = (alpha > 0).astype(np.uint8) * 255
    # Add 1-pixel white border to close open shapes touching edges
    bordered_mask = cv2.copyMakeBorder(mask, 1, 1, 1, 1, cv2.BORDER_CONSTANT, value=255)
    # Invert the bordered mask so lines are black and background is white
    inverted = cv2.bitwise_not(bordered_mask)
    # Flood fill from top-left corner (which should be background)
    flood_filled = inverted.copy()
    h, w = inverted.shape[:2]
    mask_ff = np.zeros((h + 2, w + 2), np.uint8)
    cv2.floodFill(flood_filled, mask_ff, (0, 0), 255)
    # Invert flood-filled to get the filled areas inside the lines
    filled = cv2.bitwise_not(flood_filled)
    # Remove the added border
    filled = filled[1:-1, 1:-1]
    # Create output matte image: white RGB + filled alpha
    matte = np.zeros((height, width, 4), dtype=np.uint8)
    matte[:, :, 3] = filled  # Alpha channel from filled mask
    matte[:, :, :3] = 255    # White RGB
    # Save result
    output_path = output_dir / f"{file.stem}_matte.png"
    cv2.imwrite(str(output_path), matte)
    print(f"✅ Saved: {output_path.name}")

print(f"🎉 Done! Mattes saved to: {output_dir.resolve()}")
