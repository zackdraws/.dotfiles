import cv2
import os

def draw_rule_of_thirds(image, color=(0, 255, 0), thickness=2):
    height, width, _ = image.shape

    # Calculate thirds
    vertical_third = width // 3
    horizontal_third = height // 3

    # Draw vertical lines
    cv2.line(image, (vertical_third, 0), (vertical_third, height), color, thickness)
    cv2.line(image, (2 * vertical_third, 0), (2 * vertical_third, height), color, thickness)

    # Draw horizontal lines
    cv2.line(image, (0, horizontal_third), (width, horizontal_third), color, thickness)
    cv2.line(image, (0, 2 * horizontal_third), (width, 2 * horizontal_third), color, thickness)

    return image

def process_images_in_folder():
    supported_extensions = ('.jpg', '.jpeg', '.png', '.bmp', '.tiff', '.webp')

    for filename in os.listdir('.'):
        if filename.lower().endswith(supported_extensions) and '_rule_of_thirds' not in filename:
            print(f"Processing: {filename}")
            image = cv2.imread(filename)

            if image is None:
                print(f"⚠️ Could not read image: {filename}")
                continue

            processed_image = draw_rule_of_thirds(image.copy())
            
            name, ext = os.path.splitext(filename)
            new_filename = f"{name}_rule_of_thirds{ext}"
            cv2.imwrite(new_filename, processed_image)
            print(f"Saved: {new_filename}")

if __name__ == "__main__":
    process_images_in_folder()
