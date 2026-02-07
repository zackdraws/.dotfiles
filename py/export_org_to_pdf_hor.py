#!/usr/bin/env python3
import os
import sys
from fpdf import FPDF
class UnicodePDF(FPDF):
    def __init__(self):
        # 297mm x 167mm ≈ 16:9 in landscape (A4 width, 16:9 height)
        super().__init__(orientation='L', unit='mm', format=(297, 167))
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
        max_per_row = 2
        spacing = 5
        margin = 10
        usable_width = pdf.w - 2 * margin - spacing * (max_per_row - 1)
        image_width = usable_width / max_per_row
        for line in lines:
            line = line.strip()
            image_path = is_image_line(line)
            if image_path:
                if os.path.isfile(image_path):
                    print(f"🖼️  Queued image for grid: {image_path}")
                    image_batch.append(image_path)
                else:
                    print(f"⚠️  Image not found: {image_path}")
                    pdf.multi_cell(0, 10, f"[Image not found: {image_path}]")
                continue
            if image_batch:
                add_image_grid(pdf, image_batch, image_width, max_per_row, spacing, margin)
                image_batch = []
            if line:
                pdf.multi_cell(0, 10, line)
        if image_batch:
            add_image_grid(pdf, image_batch, image_width, max_per_row, spacing, margin)
        print(f"💾 Saving PDF to: {output_pdf_path}")
        pdf.output(output_pdf_path)
        print(f"✅ PDF created at: {output_pdf_path}")
    except FileNotFoundError:
        print(f"❌ File not found: {org_file_path}")
    except Exception as e:
        print(f"❌ Error: {e}")
def add_image_grid(pdf, image_paths, image_width, max_per_row, spacing, margin):
    print(f"🧩 Adding image grid: {len(image_paths)} images, {max_per_row} per row")
    caption_height = 6
    row_height = image_width + caption_height + spacing
    count = 0
    x = margin
    y = pdf.get_y()
    for img in image_paths:
        if count and count % max_per_row == 0:
            y += row_height
            if y + row_height > pdf.h - margin:
                pdf.add_page()
                y = margin
            pdf.set_y(y)
            x = margin
        if count % max_per_row == 0 and y + row_height > pdf.h - margin:
            pdf.add_page()
            y = margin
            pdf.set_y(y)
            x = margin
        try:
            pdf.image(img, x=x, y=y, w=image_width)
            caption = os.path.basename(img)
            pdf.set_xy(x, y + image_width + 1)
            pdf.set_font("DejaVu", size=10)
            pdf.multi_cell(image_width, caption_height, caption, align='L')
            pdf.set_font("DejaVu", size=12)
        except Exception as e:
            print(f"⚠️  Error adding image {img}: {e}")
            pdf.set_xy(x, y)
            pdf.multi_cell(image_width, 10, "[Image error]")
        x += image_width + spacing
        count += 1
    pdf.set_y(y + row_height)
def main():
    print("=== Org to PDF (16:9 Landscape Image Grid) ===")
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
