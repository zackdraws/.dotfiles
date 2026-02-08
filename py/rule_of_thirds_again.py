import cv2
import os
import argparse
import numpy as np
def draw_rule_of_thirds(image, color=(255, 0, 0), thickness=2):
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
def process

