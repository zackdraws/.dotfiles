#!/bin/bash
set -e
echo "✨ Creating folders..."
mkdir -p matte composite line flat_matte
if ! command -v python3 &>/dev/null; then
    echo "❌ Python 3 is required."
    exit 1
fi
python3 - <<EOF
import cv2
import numpy as np
import glob
import os
import random
input_files = glob.glob("*.jpg") + glob.glob("*.jpeg") + glob.glob("*.png")
for file in input_files:
    base = os.path.splitext(file)[0]
    print(f"\n🔧 Processing {file}")
    image = cv2.imread(file)
    if image is None:
        print(f"❌ Failed to load {file}, skipping.")
        continue
    h, w = image.shape[:2]
    # === Subject Detection ===
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    _, binary = cv2.threshold(gray, 230, 255, cv2.THRESH_BINARY_INV)
    kernel = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (3, 3))
    clean_mask = cv2.morphologyEx(binary, cv2.MORPH_OPEN, kernel, iterations=1)
    contours, _ = cv2.findContours(clean_mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    if not contours:
        print(f"❌ No subject detected in {file}, skipping.")
        continue
    main_contour = max(contours, key=cv2.contourArea)
    subject_mask = np.zeros((h, w), dtype=np.uint8)
    cv2.drawContours(subject_mask, [main_contour], -1, 255, thickness=cv2.FILLED)
    # === Matte Creation ===
    kernel_dilate = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (25, 25))
    matte_mask = cv2.dilate(subject_mask, kernel_dilate, iterations=1)
    matte_color = np.array([204, 255, 255], dtype=np.uint8)
    matte_img = np.zeros((h, w, 4), dtype=np.uint8)
    for c in range(3):
        matte_img[:, :, c] = matte_color[c]
    matte_img[:, :, 3] = matte_mask
    cv2.imwrite(os.path.join("matte", f"{base}_MATTE.png"), matte_img)
    # === Composite ===
    white_mask = cv2.inRange(image, (230, 230, 230), (255, 255, 255))
    alpha = 255 - white_mask
    alpha = cv2.bitwise_and(alpha, subject_mask)
    image_bgra = cv2.cvtColor(image, cv2.COLOR_BGR2BGRA)
    image_bgra[:, :, 3] = alpha
    fg = image_bgra[:, :, :3].astype(np.float32)
    bg = matte_img[:, :, :3].astype(np.float32)
    alpha_fg = (image_bgra[:, :, 3] / 255.0)[:, :, np.newaxis]
    composite_rgb = (fg * alpha_fg + bg * (1 - alpha_fg)).astype(np.uint8)
    final_alpha = np.clip(image_bgra[:, :, 3].astype(np.int16) + matte_img[:, :, 3].astype(np.int16), 0, 255).astype(np.uint8)
    final_img = cv2.merge((composite_rgb, final_alpha))
    cv2.imwrite(os.path.join("composite", f"{base}.png"), final_img)
    # === Transparent Line Drawing ===
    gray_line = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    _, alpha_line = cv2.threshold(gray_line, 230, 255, cv2.THRESH_BINARY_INV)
    alpha_line = cv2.GaussianBlur(alpha_line, (3, 3), 0)
    line_rgb = cv2.cvtColor(gray_line, cv2.COLOR_GRAY2RGB)
    line_rgba = cv2.merge((line_rgb, alpha_line))
    line_rgba[:, :, :3] = cv2.add(line_rgba[:, :, :3], 30)
    cv2.imwrite(os.path.join("line", f"{base}_LINE.png"), line_rgba)
    # === Flat Color Matte (for Flatting with More Regions) ===
    inv = 255 - gray
    _, thresh = cv2.threshold(inv, 100, 255, cv2.THRESH_BINARY)
    # 👇 Use RETR_TREE instead of RETR_EXTERNAL to get nested regions
    flat_contours, _ = cv2.findContours(thresh, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
    flat_matte = np.zeros((h, w, 4), dtype=np.uint8)
    for cnt in flat_contours:
        # 👇 Ensure truly random distinct colors
        while True:
            color = tuple(random.randint(50, 255) for _ in range(3))
            if color not in used_colors:
                used_colors.add(color)
                break
        color_rgba = list(color) + [255]
        cv2.drawContours(flat_matte, [cnt], -1, color_rgba, thickness=cv2.FILLED)
    cv2.imwrite(os.path.join("flat_matte", f"{base}_FLATMATTE.png"), flat_matte)
    print(f"✅ Done: {file}")
EOF
echo -e "\n✅ All processing complete!"
echo "📂 Output folders: matte/, composite/, line/, flat_matte/"
