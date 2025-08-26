#!/usr/bin/env python3



import os

import sys

from fpdf import FPDF

from PIL import Image  # Install via: pip install pillow



class UnicodePDF(FPDF):

    def __init__(self):

        inch_to_mm = 25.4

        width_in = 16

        height_in = 9



        # Swap width and height because orientation='P' but size is landscape

        width_mm = width_in * inch_to_mm  # 406.4 mm

        height_mm = height_in * inch_to_mm  # 228.6 mm



        super().__init__(orientation='P', unit='mm', format=(width_mm, height_mm))



        font_path = "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf"

        print("🔎 Checking for font at:", font_path)

        if not os.path.isfile(font_path):

            print(f"❌ Error: Font file not found at {font_path}")

            sys.exit(1)



        self.add_font("DejaVu", "", font_path, uni=True)

        self.set_font("DejaVu", size=12)



def is_image_line(line):

    line = line.strip()

    if line.startswith("[[") and line.endswith("]]"):

        path = line[2:-2].strip()

        if any(path.lower().endswith(ext) for ext in ['.jpg', '.jpeg', '.png', '.gif']):

            return path

    return None



def create_pdf_from_org(org_file_path, output_pdf_path="output.pdf"):

    try:

        print(f"📄 Reading org file: {org_file_path}")

        with open(org_file_path, 'r', encoding='utf-8') as f:

            lines = f.readlines()



        pdf = UnicodePDF()

        pdf.add_page()



        image_batch = []

        max_per_row = 5      # 5 columns

        rows_per_page = 3    # 3 rows

        spacing = 3          # smaller spacing in mm

        margin = 10          # smaller margin in mm



        # Calculate image size based on grid

        usable_width = pdf.w - 2 * margin - spacing * (max_per_row - 1)

        usable_height = pdf.h - 2 * margin - spacing * (rows_per_page - 1)

        image_width = usable_width / max_per_row

        caption_height = 6

        image_height = (usable_height / rows_per_page) - caption_height



        for line in lines:

            line = line.strip()

            image_path = is_image_line(line)



            if image_path:

                if os.path.isfile(image_path):

                    print(f"🖼️  Queued image: {image_path}")

                    image_batch.append(image_path)

                else:

                    print(f"⚠️  Image not found: {image_path}")

                    pdf.multi_cell(0, 10, f"[Image not found: {image_path}]")

                continue



            if image_batch:

                add_image_grid(pdf, image_batch, image_width, image_height, caption_height,

                               max_per_row, rows_per_page, spacing, margin)

                image_batch = []



            if line:

                pdf.multi_cell(0, 10, line)



        if image_batch:

            add_image_grid(pdf, image_batch, image_width, image_height, caption_height,

                           max_per_row, rows_per_page, spacing, margin)



        print(f"💾 Saving PDF to: {output_pdf_path}")

        pdf.output(output_pdf_path)

        print(f"✅ PDF created at: {output_pdf_path}")



    except FileNotFoundError:

        print(f"❌ File not found: {org_file_path}")

    except Exception as e:

        print(f"❌ Error: {e}")



def add_image_grid(pdf, image_paths, image_width, image_height, caption_height,

                   max_per_row, max_rows, spacing, margin):

    print(f"🧩 Adding image grid: {len(image_paths)} images in a {max_rows}x{max_per_row} layout")



    count = 0



    for img in image_paths:

        col = count % max_per_row

        row = (count // max_per_row) % max_rows



        if count > 0 and count % (max_per_row * max_rows) == 0:

            pdf.add_page()



        x = margin + col * (image_width + spacing)

        y = margin + row * (image_height + caption_height + spacing)



        try:

            # Open image to get original size

            with Image.open(img) as im:

                orig_w, orig_h = im.size



            # Calculate scale to fit inside box (image_width x image_height)

            scale_w = image_width / orig_w

            scale_h = image_height / orig_h

            scale = min(scale_w, scale_h, 1.0)  # Don't upscale if smaller than box



            disp_w = orig_w * scale

            disp_h = orig_h * scale



            # Center the image inside the allocated box

            x_centered = x + (image_width - disp_w) / 2

            y_centered = y + (image_height - disp_h) / 2



            pdf.image(img, x=x_centered, y=y_centered, w=disp_w, h=disp_h)



            caption = os.path.basename(img)

            pdf.set_xy(x, y + image_height + 1)

            pdf.set_font("DejaVu", size=10)

            pdf.multi_cell(image_width, caption_height, caption, align='L')

            pdf.set_font("DejaVu", size=12)



        except Exception as e:

            print(f"⚠️  Could not add image {img}: {e}")

            pdf.set_xy(x, y)

            pdf.multi_cell(image_width, 10, "[Image error]")



        count += 1



    # Reset cursor below images

    last_row_y = margin + max_rows * (image_height + caption_height + spacing)

    pdf.set_y(last_row_y)



def main():

    print("=== Org to PDF (16x9 inches Landscape, 5x3 Image Grid, aspect ratio kept) ===")

    org_file = input("📥 Enter the name of the .org file (in current directory): ").strip()



    if not org_file.lower().endswith(".org"):

        org_file += ".org"



    if not os.path.isfile(org_file):

        print(f"❌ Error: '{org_file}' not found in current directory.")

        sys.exit(1)



    output_file = input("💾 Enter output PDF name (or press Enter to use 'output.pdf'): ").strip()

    if not output_file:

        output_file = "output.pdf"

    elif not output_file.lower().endswith(".pdf"):

        output_file += ".pdf"



    create_pdf_from_org(org_file, output_file)



if __name__ == "__main__":

    main()
