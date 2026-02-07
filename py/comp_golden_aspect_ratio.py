#!/usr/bin/env python3
import os
import cv2
import numpy as np
import math
def draw_horizontal_fibonacci_spiral(image, color=(0, 165, 255), thickness=2, turns=4):
    """
    Draw a full horizontal golden spiral line starting from the top-right
    and spiraling clockwise inward toward the bottom-left.
    """
    height, width, _ = image.shape
    # Spiral center toward bottom-left
    center_x = int(width * 0.25)
    center_y = int(height * 0.5)
    # Max radius scaled to width
    a = 1  # initial scale
    b = 0.306349  # golden spiral growth factor
    max_radius = width * 1.2  # extend a little beyond width
    # Build spiral points
    points = []
    theta_values = np.linspace(0, 2 * math.pi * turns, 3000)
    for theta in theta_values:
        r = a * np.exp(b * theta)
        x = int(center_x + r * math.cos(theta))
        y = int(center_y + r * math.sin(theta))
        if 0 <= x < width and 0 <= y < height:
            points.append((x, y))
    # Rotate the spiral to start from top-right and go clockwise
    rotation_degrees = -45
    rot_center = (width // 2, height // 2)
    M = cv2.getRotationMatrix2D(rot_center, rotation_degrees, 1.0)
    rotated_points = [
        tuple(np.dot(M, [x, y, 1]).astype(int)) for (x, y) in points
    ]
    # Draw the spiral
    for i in range(1, len(rotated_points)):
        cv2.line(image, rotated_points[i - 1], rotated_points[i], color, thickness)
def read_image_unicode_safe(path):
    try:
        data = np.fromfile(path, dtype=np.uint8)
        return cv2.imdecode(data, cv2.IMREAD_COLOR)
    except Exception:
        return None
def write_image_unicode_safe(path, image):
    ext = os.path.splitext(path)[1]
    result, encoded = cv2.imencode(ext, image)
    if result:
        encoded.tofile(path)
        return True
    return False
def process_images_recursively(folder):
    supported_exts = ('.jpg', '.jpeg', '.png', '.bmp', '.tiff', '.webp')
    for dirpath, _, filenames in os.walk(folder):
        for filename in filenames:
            if not filename.lower().endswith(supported_exts):
                continue
            if '_fib_line' in filename:
                continue
            input_path = os.path.join(dirpath, filename)
            image = read_image_unicode_safe(input_path)
            if image is None:
                print(f"⚠️ Could not read: {filename}")
                continue
            print(f"✨ Processing: {filename}")
            output_image = image.copy()
            draw_horizontal_fibonacci_spiral(output_image)
            name, ext = os.path.splitext(filename)
            output_filename = f"{name}_fib_line{ext}"
            output_path = os.path.join(dirpath, output_filename)
            if write_image_unicode_safe(output_path, output_image):
                print(f"✅ Saved: {output_path}")
            else:
                print(f"❌ Failed to save: {output_filename}")
if __name__ == "__main__":
    current_dir = os.getcwd()
    print(f"�� Working in: {current_dir}")
    process_images_recursively(current_dir)
