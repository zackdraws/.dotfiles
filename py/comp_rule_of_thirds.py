import cv2
import os
import argparse
import numpy as np
def draw_rule_of_thirds(image, color=(0, 255, 0), thickness=2):
    height, width, _ = image.shape
    v_third = width // 3
    h_third = height // 3
    cv2.line(image, (v_third, 0), (v_third, height), color, thickness)
    cv2.line(image, (2 * v_third, 0), (2 * v_third, height), color, thickness)
    cv2.line(image, (0, h_third), (width, h_third), color, thickness)
    cv2.line(image, (0, 2 * h_third), (width, 2 * h_third), color, thickness)
    return image
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
def process_images_recursively(root_folder):
    supported_extensions = ('.jpg', '.jpeg', '.png', '.bmp', '.tiff', '.webp')
    for dirpath, _, filenames in os.walk(root_folder):
        for filename in filenames:
            if filename.lower().endswith(supported_extensions) and '_rule_of_thirds' not in filename:
                input_path = os.path.join(dirpath, filename)
                image = read_image_unicode_safe(input_path)
                if image is None:
                    print(f"Could not read image: {filename.encode('utf-8', errors='replace')}")
                    continue
                print(f"Processing: {input_path.encode('utf-8', errors='replace')}")
                image_with_grid = draw_rule_of_thirds(image.copy())
                name, ext = os.path.splitext(filename)
                output_filename = f"{name}_rule_of_thirds{ext}"
                output_path = os.path.join(dirpath, output_filename)
                if write_image_unicode_safe(output_path, image_with_grid):
                    print(f"Saved: {output_path.encode('utf-8', errors='replace')}")
                else:
                    print(f"Failed to save: {output_filename.encode('utf-8', errors='replace')}")
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Add Rule of Thirds grid to all images in a folder (recursively).")
    parser.add_argument("folder", help="Path to the root folder containing images")
    args = parser.parse_args()
    if not os.path.isdir(args.folder):
        print("Error: The specified path is not a folder.")
    else:
        process_images_recursively(args.folder)
