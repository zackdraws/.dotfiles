#!/usr/bin/env python3
from PIL import Image, ImageDraw, ImageFont
import sys
import os
import textwrap



def add_caption(image_path):

    # Open the image

    image = Image.open(image_path).convert("RGBA")



    # Prompt for caption

    caption = input("Enter caption: ").strip()

    if not caption:

        print("No caption entered. Exiting.")

        return



    # Load font

    try:

        font = ImageFont.truetype("DejaVuSans-Bold.ttf", size=40)

    except IOError:

        font = ImageFont.load_default()



    draw = ImageDraw.Draw(image)

    image_width, image_height = image.size



    # Max width for text block (80% of image width)

    max_text_width = int(image_width * 0.8)



    # Wrap caption text into lines fitting max_text_width

    lines = []

    # Split caption into wrapped lines

    wrapper = textwrap.TextWrapper(width=100)  # start with large width



    # Manually wrap based on pixel width:

    words = caption.split()

    current_line = ""

    for word in words:

        test_line = current_line + (" " if current_line else "") + word

        bbox = draw.textbbox((0,0), test_line, font=font)

        line_width = bbox[2] - bbox[0]

        if line_width <= max_text_width:

            current_line = test_line

        else:

            if current_line:

                lines.append(current_line)

            current_line = word

    if current_line:

        lines.append(current_line)



    # Calculate height of all lines together

    line_heights = []

    line_widths = []

    for line in lines:

        bbox = draw.textbbox((0,0), line, font=font)

        w = bbox[2] - bbox[0]

        h = bbox[3] - bbox[1]

        line_widths.append(w)

        line_heights.append(h)

    total_text_height = sum(line_heights) + (len(lines) - 1) * 5  # 5px line spacing



    # Vertical position (20% above bottom)

    y_start = int(image_height * 0.8) - total_text_height // 2



    # Padding for matte

    padding_x = 20

    padding_y = 15



    # Matte rectangle coords covering all lines (centered horizontally)

    matte_x0 = (image_width - max(line_widths)) // 2 - padding_x

    matte_y0 = y_start - padding_y

    matte_x1 = matte_x0 + max(line_widths) + padding_x * 2

    matte_y1 = y_start + total_text_height + padding_y



    # Create overlay for matte and text

    overlay = Image.new("RGBA", image.size, (255,255,255,0))

    overlay_draw = ImageDraw.Draw(overlay)



    # Draw matte rectangle (more opaque black)

    overlay_draw.rectangle([matte_x0, matte_y0, matte_x1, matte_y1], fill=(0,0,0,230))



    # Draw each line centered horizontally

    current_y = y_start

    for i, line in enumerate(lines):

        line_width = line_widths[i]

        x = (image_width - line_width) // 2

        overlay_draw.text((x, current_y), line, font=font, fill=(255,255,255,255))

        current_y += line_heights[i] + 5  # line height + spacing



    # Composite overlay onto image

    combined = Image.alpha_composite(image, overlay).convert("RGB")



    # Save output

    output_path = f"captioned_{os.path.basename(image_path)}"

    combined.save(output_path)

    print(f"✅ Saved captioned image as '{output_path}'")



if __name__ == "__main__":

    if len(sys.argv) < 2:

        print("Usage: caption.py image.jpg")

        sys.exit(1)



    filename = sys.argv[1]

    if not os.path.isfile(filename):

        print(f"Error: File '{filename}' not found.")

        sys.exit(1)



    add_caption(filename)
