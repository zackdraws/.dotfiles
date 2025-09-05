#!/bin/bash



set -e



echo "✨ Applying ultra ultra soft light yellow matte..."



if ! command -v python3 &>/dev/null; then

    echo "❌ Python 3 required."

    exit 1

fi



python3 - <<EOF

import cv2

import numpy as np

import glob



for file in glob.glob('*.jpg') + glob.glob('*.jpeg'):

    base = file.rsplit('.', 1)[0]

    output = f"{base}_ultrasoftyellow_softer.png"



    print(f"Processing {file} → {output}")



    image = cv2.imread(file)

    if image is None:

        print(f"Failed to load {file}, skipping.")

        continue



    h, w = image.shape[:2]



    # Grayscale & gentle threshold to isolate subject

    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

    _, binary = cv2.threshold(gray, 245, 255, cv2.THRESH_BINARY_INV)



    # Small morphology open to clean noise

    kernel = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (3, 3))

    clean_mask = cv2.morphologyEx(binary, cv2.MORPH_OPEN, kernel, iterations=1)



    # Find largest contour = subject

    contours, _ = cv2.findContours(clean_mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

    if not contours:

        print(f"No subject detected in {file}, skipping.")

        continue

    main_contour = max(contours, key=cv2.contourArea)



    subject_mask = np.zeros((h, w), dtype=np.uint8)

    cv2.drawContours(subject_mask, [main_contour], -1, 255, thickness=cv2.FILLED)



    # Dilate mask more for wider matte glow

    kernel_dilate = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (65, 65))  # bigger dilation

    matte_mask = cv2.dilate(subject_mask, kernel_dilate, iterations=1)



    # Gaussian blur with larger kernel for ultra soft edges

    matte_mask_blurred = cv2.GaussianBlur(matte_mask, (151, 151), 0)  # bigger blur kernel



    # Matte color - very light yellow pastel (BGR) + alpha

    # Make alpha less intense for softer glow (scale down alpha by ~60%)

    matte_color_rgb = np.array([204, 255, 255], dtype=np.uint8)  # light yellow (BGR)

    matte_alpha_max = int(255 * 0.6)  # 60% opacity max



    matte = np.zeros((h, w, 4), dtype=np.uint8)

    for c in range(3):

        matte[:, :, c] = matte_color_rgb[c]

    # Scale matte alpha mask to max 60% opacity

    matte[:, :, 3] = (matte_mask_blurred.astype(np.float32) * (matte_alpha_max / 255.0)).astype(np.uint8)



    # Create alpha from white removal softly within subject mask

    white_mask = cv2.inRange(image, (245, 245, 245), (255, 255, 255))

    alpha = 255 - white_mask

    alpha = cv2.bitwise_and(alpha, subject_mask)



    image_bgra = cv2.cvtColor(image, cv2.COLOR_BGR2BGRA)

    image_bgra[:, :, 3] = alpha



    # Composite subject over matte with smooth alpha

    fg = image_bgra[:, :, :3].astype(np.float32)

    bg = matte[:, :, :3].astype(np.float32)

    alpha_fg = (image_bgra[:, :, 3] / 255.0)[:, :, np.newaxis]

    alpha_bg = (matte[:, :, 3] / 255.0)[:, :, np.newaxis]



    composite_rgb = (fg * alpha_fg + bg * (1 - alpha_fg)).astype(np.uint8)



    # Final alpha is max of subject and matte alpha for full soft glow

    final_alpha = np.clip(image_bgra[:, :, 3].astype(np.int16) + matte[:, :, 3].astype(np.int16), 0, 255).astype(np.uint8)



    final_img = cv2.merge((composite_rgb, final_alpha))

    cv2.imwrite(output, final_img)



    print(f"✅ Saved {output}")



EOF



echo "✅ Ultra ultra soft light yellow matte applied to all jpg/jpeg images in folder."
