#!/bin/bash



set -e



echo "✨ Creating folders for matte, composite, and line art (stronger white removal)..."



if ! command -v python3 &>/dev/null; then

    echo "❌ Python 3 required."

    exit 1

fi



mkdir -p matte composite line



python3 - <<EOF

import cv2

import numpy as np

import glob

import os



for file in glob.glob('*.jpg') + glob.glob('*.jpeg'):

    base = os.path.splitext(file)[0]

    matte_output = os.path.join("matte", f"{base}_MATTE.png")

    composite_output = os.path.join("composite", f"{base}.png")

    line_output = os.path.join("line", f"{base}_LINE.png")



    print(f"Processing {file} → Matte: {matte_output}, Composite: {composite_output}, Line: {line_output}")



    image = cv2.imread(file)

    if image is None:

        print(f"Failed to load {file}, skipping.")

        continue



    h, w = image.shape[:2]



    # -------- Extract subject mask --------

    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

    _, binary = cv2.threshold(gray, 230, 255, cv2.THRESH_BINARY_INV)  # stronger threshold



    kernel = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (3, 3))

    clean_mask = cv2.morphologyEx(binary, cv2.MORPH_OPEN, kernel, iterations=1)



    contours, _ = cv2.findContours(clean_mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

    if not contours:

        print(f"No subject detected in {file}, skipping.")

        continue

    main_contour = max(contours, key=cv2.contourArea)



    subject_mask = np.zeros((h, w), dtype=np.uint8)

    cv2.drawContours(subject_mask, [main_contour], -1, 255, thickness=cv2.FILLED)



    # -------- Create hard-edged matte --------

    kernel_dilate = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (25, 25))

    matte_mask = cv2.dilate(subject_mask, kernel_dilate, iterations=1)



    matte_color_rgb = np.array([204, 255, 255], dtype=np.uint8)  # light yellow (BGR)



    matte_img = np.zeros((h, w, 4), dtype=np.uint8)

    for c in range(3):

        matte_img[:, :, c] = matte_color_rgb[c]

    matte_img[:, :, 3] = matte_mask  # no blur = hard edge



    cv2.imwrite(matte_output, matte_img)



    # -------- Create alpha for subject --------

    white_mask = cv2.inRange(image, (230, 230, 230), (255, 255, 255))  # more aggressive

    alpha = 255 - white_mask

    alpha = cv2.bitwise_and(alpha, subject_mask)



    image_bgra = cv2.cvtColor(image, cv2.COLOR_BGR2BGRA)

    image_bgra[:, :, 3] = alpha



    # -------- Composite drawing over matte --------

    fg = image_bgra[:, :, :3].astype(np.float32)

    bg = matte_img[:, :, :3].astype(np.float32)

    alpha_fg = (image_bgra[:, :, 3] / 255.0)[:, :, np.newaxis]



    composite_rgb = (fg * alpha_fg + bg * (1 - alpha_fg)).astype(np.uint8)



    final_alpha = np.clip(image_bgra[:, :, 3].astype(np.int16) + matte_img[:, :, 3].astype(np.int16), 0, 255).astype(np.uint8)



    final_img = cv2.merge((composite_rgb, final_alpha))

    cv2.imwrite(composite_output, final_img)



    # -------- Transparent line art (harsher white removal) --------

    gray_line = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)



    # Harsher white removal for more clarity in line art

    _, alpha_line = cv2.threshold(gray_line, 230, 255, cv2.THRESH_BINARY_INV)

    alpha_line = cv2.GaussianBlur(alpha_line, (3, 3), 0)  # still a little soft



    line_rgb = cv2.cvtColor(gray_line, cv2.COLOR_GRAY2RGB)

    line_rgba = cv2.merge((line_rgb, alpha_line))



    line_rgba[:, :, :3] = cv2.add(line_rgba[:, :, :3], 30)  # slightly brighten lines



    cv2.imwrite(line_output, line_rgba)



    print(f"✅ Saved matte, composite, and sharper line art for {file}")



EOF



echo "✅ Finished! Check 'matte/', 'composite/', and 'line/' folders."
