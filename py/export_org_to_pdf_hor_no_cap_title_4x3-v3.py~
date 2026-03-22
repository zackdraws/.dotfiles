#!/usr/bin/env python3
import os
import sys
from fpdf import FPDF
from PIL import Image  # pip install pillow


class UnicodePDF(FPDF):
    def __init__(self, title):
        inch_to_mm = 25.4
        width_in = 16
        height_in = 9
        width_mm = width_in * inch_to_mm
        height_mm = height_in * inch_to_mm

        super().__init__(orientation='P', unit='mm', format=(width_mm, height_mm))

        font_path_regular = "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf"
        font_path_bold = "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf"

        if not os.path.isfile(font_path_regular):
            print(f"Error: Regular font file not found at {font_path_regular}")
            sys.exit(1)

        if not os.path.isfile(font_path_bold):
            print(f"Error: Bold font file not found at {font_path_bold}")
            sys.exit(1)

        self.add_font("DejaVu", "", font_path_regular, uni=True)
        self.add_font("DejaVu", "B", font_path_bold, uni=True)

        self.title = title

    def header(self):
        self.set_font("DejaVu", "B", 16)
        self.set_xy(10, 10)
        self.cell(0, 10, self.title, ln=0, align='L')
        self.set_font("DejaVu", "", 12)
        self.ln(15)


def is_image_line(line):
    line = line.strip()
    if line.startswith("[[") and line.endswith("]]"):
        path = line[2:-2].strip()
        if any(path.lower().endswith(ext) for ext in ['.jpg', '.jpeg', '.png', '.gif']):
            return path
    return None


def add_five_horizontal(pdf, image_paths):
    print(f"Adding horizontal Pinterest layout ({len(image_paths)} images)")

    margin_mm = 5.3        # ≈20px
    spacing_mm = 3
    header_offset = 15
    images_per_page = 5

    usable_width = pdf.w - 2 * margin_mm
    usable_height = pdf.h - 2 * margin_mm - header_offset

    column_width = (usable_width - (images_per_page - 1) * spacing_mm) / images_per_page

    count = 0

    for img in image_paths:
        if count % images_per_page == 0:
            pdf.add_page()

        col = count % images_per_page
        x = margin_mm + col * (column_width + spacing_mm)
        y = margin_mm + header_offset

        try:
            with Image.open(img) as im:
                orig_w, orig_h = im.size

            # Convert pixels → mm (assuming 96 DPI)
            px_to_mm = 25.4 / 96.0
            orig_w_mm = orig_w * px_to_mm
            orig_h_mm = orig_h * px_to_mm

            # Scale to column width
            scale = column_width / orig_w_mm
            disp_w = orig_w_mm * scale
            disp_h = orig_h_mm * scale

            # If too tall, shrink to fit height
            if disp_h > usable_height:
                scale = usable_height / orig_h_mm
                disp_w = orig_w_mm * scale
                disp_h = orig_h_mm * scale

            # Vertically center
            y_centered = y + (usable_height - disp_h) / 2

            pdf.image(img, x=x, y=y_centered, w=disp_w, h=disp_h)

        except Exception as e:
            print(f"Could not add image {img}: {e}")
            pdf.set_xy(x, y)
            pdf.multi_cell(column_width, 10, "[Image error]")

        count += 1


def create_pdf_from_org(org_file_path, output_pdf_path="output.pdf", title=""):
    try:
        with open(org_file_path, 'r', encoding='utf-8') as f:
            lines = f.readlines()

        pdf = UnicodePDF(title)

        image_list = []

        for line in lines:
            line = line.strip()
            image_path = is_image_line(line)

            if image_path:
                if os.path.isfile(image_path):
                    image_list.append(image_path)
                else:
                    print(f"Image not found: {image_path}")
                continue

            # Regular text
            if line:
                if image_list:
                    add_five_horizontal(pdf, image_list)
                    image_list = []

                pdf.add_page()
                pdf.multi_cell(0, 10, line)

        # Flush remaining images
        if image_list:
            add_five_horizontal(pdf, image_list)

        pdf.output(output_pdf_path)
        print(f"PDF created at: {output_pdf_path}")

    except FileNotFoundError:
        print(f"File not found: {org_file_path}")
    except Exception as e:
        print(f"Error: {e}")


def main():
    print("=== Org to PDF (Horizontal Pinterest Layout - 5 Images Per Page) ===")

    title = input("Enter the title for the PDF: ").strip()
    if not title:
        title = "Untitled Document"

    org_file = input("Enter the name of the .org file: ").strip()
    if not org_file.lower().endswith(".org"):
        org_file += ".org"

    if not os.path.isfile(org_file):
        print(f"Error: '{org_file}' not found.")
        sys.exit(1)

    output_file = input("Enter output PDF name (default output.pdf): ").strip()
    if not output_file:
        output_file = "output.pdf"
    elif not output_file.lower().endswith(".pdf"):
        output_file += ".pdf"

    create_pdf_from_org(org_file, output_file, title)


if __name__ == "__main__":
    main()
