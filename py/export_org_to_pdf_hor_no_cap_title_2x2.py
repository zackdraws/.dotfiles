#!/usr/bin/env python3
import os
import sys
from PIL import Image
from fpdf import FPDF

def is_image_line(line):
    line = line.strip()
    if line.startswith("[[") and line.endswith("]]"):
        path = line[2:-2].strip()
        if any(path.lower().endswith(ext) for ext in ['.jpg', '.jpeg', '.png', '.gif']):
            return path
    return None

def load_images(image_paths):
    images = []
    for path in image_paths:
        if os.path.isfile(path):
            try:
                im = Image.open(path)
                images.append(im.copy())
                im.close()
            except Exception as e:
                print(f"Error opening {path}: {e}")
        else:
            print(f"Image not found: {path}")
    return images

def create_grid_layout(images, columns, rows, page_width_mm=406.4, page_height_mm=228.6,
                       margin_mm=10, spacing_mm=2, header_offset_mm=15, bottom_margin_mm=15):
    """Return a list of canvases for each page in a strict grid layout"""
    dpi = 72
    mm_to_px = dpi / 25.4
    page_width_px = int(page_width_mm * mm_to_px)
    page_height_px = int(page_height_mm * mm_to_px)
    margin_px = int(margin_mm * mm_to_px)
    spacing_px = int(spacing_mm * mm_to_px)
    header_px = int(header_offset_mm * mm_to_px)
    bottom_px = int(bottom_margin_mm * mm_to_px)

    usable_width = page_width_px - 2*margin_px - (columns-1)*spacing_px
    usable_height = page_height_px - 2*margin_px - (rows-1)*spacing_px - header_px - bottom_px

    cell_width = usable_width // columns
    cell_height = usable_height // rows

    pages = []
    canvas = Image.new("RGB", (page_width_px, page_height_px), "white")
    img_index = 0

    for img in images:
        row_in_page = (img_index // columns) % rows
        col_in_page = img_index % columns

        # If starting a new page
        if img_index > 0 and img_index % (columns*rows) == 0:
            pages.append(canvas)
            canvas = Image.new("RGB", (page_width_px, page_height_px), "white")

        x = margin_px + col_in_page * (cell_width + spacing_px)
        y = margin_px + header_px + row_in_page * (cell_height + spacing_px)

        # Resize image to fit cell, preserving aspect ratio
        w, h = img.size
        scale = min(cell_width / w, cell_height / h, 1)
        new_w = int(w * scale)
        new_h = int(h * scale)
        im_resized = img.resize((new_w, new_h), Image.LANCZOS)

        # Center image in cell
        x_centered = x + (cell_width - new_w)//2
        y_centered = y + (cell_height - new_h)//2

        canvas.paste(im_resized, (x_centered, y_centered))
        img_index += 1

    pages.append(canvas)
    return pages, mm_to_px

def save_pages_as_pdf(pages, output_pdf_path, mm_to_px):
    pdf = FPDF(unit="mm", format=[pages[0].width / mm_to_px, pages[0].height / mm_to_px])
    for page in pages:
        pdf.add_page()
        tmp_path = "_temp_page.png"
        page.save(tmp_path)
        pdf.image(tmp_path, x=0, y=0, w=page.width / mm_to_px, h=page.height / mm_to_px)
        os.remove(tmp_path)
    pdf.output(output_pdf_path)
    print(f"PDF saved as {output_pdf_path}")

def main():
    print("=== Grid-style PDF generator ===")
    org_file = input("Enter .org filename: ").strip()
    if not org_file.lower().endswith(".org"):
        org_file += ".org"
    if not os.path.isfile(org_file):
        print(f"File '{org_file}' not found.")
        sys.exit(1)
    output_file = input("Enter output PDF filename (default output.pdf): ").strip() or "output.pdf"

    try:
        columns = int(input("Enter number of columns per page: ").strip())
        rows = int(input("Enter number of rows per page: ").strip())
        if columns <=0 or rows <=0:
            raise ValueError
    except ValueError:
        print("Invalid columns/rows. Must be positive integers.")
        sys.exit(1)

    # Collect images from org file
    with open(org_file, 'r', encoding='utf-8') as f:
        lines = f.readlines()
    image_paths = [is_image_line(line) for line in lines if is_image_line(line)]
    images = load_images(image_paths)

    if not images:
        print("No images found in .org file.")
        sys.exit(1)

    pages, mm_to_px = create_grid_layout(images, columns, rows)
    save_pages_as_pdf(pages, output_file, mm_to_px)
    print("Done! All images arranged in grid.")

if __name__ == "__main__":
    main()
