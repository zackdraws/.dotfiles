#!/usr/bin/env python3
import os
import sys
from fpdf import FPDF
class UnicodePDF(FPDF):
    def __init__(self):
        super().__init__()
        font_path = "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf"
        print("🔎 Checking for font at:", font_path)
        if not os.path.isfile(font_path):
            print(f"❌ Error: Font file not found at {font_path}")
            sys.exit(1)
            print("✅ Font found. Adding to PDF...")
            self.add_font("DejaVu", "", font_path, uni=True)
            self.set_font("DejaVu", size=12)
def create_pdf_from_org(org_file_path, output_pdf_path="output.pdf"):
    """
    Converts a .org file to a PDF, with support for images.
    Supports image lines like [[./path/to/image.jpg]] or #+IMAGE: ./path/to/image.jpg
    """
    try:
        print(f"📄 Reading org file: {org_file_path}")
        with open(org_file_path, 'r', encoding='utf-8') as f:
            lines = f.readlines()
            print("📝 Creating PDF...")
            pdf = UnicodePDF()
            pdf.add_page()
        for line in lines:
            line = line.strip()
            # Detect image syntax
            if line.startswith("[[") and line.endswith("]]"):
                image_path = line[2:-2].strip()
            elif line.lower().startswith("#+image:"):
                image_path = line[8:].strip()
            else:
                image_path = None
            # Insert image if detected and file exists
            if image_path:
                if os.path.isfile(image_path):
                    print(f"🖼️  Adding image: {image_path}")
                    try:
                        # Auto-fit image width to page (leave some margin)
                        page_width = pdf.w - 20
                        pdf.image(image_path, w=page_width)
                        pdf.ln(5)  # Add spacing after image
                    except Exception as e:
                        print(f"⚠️  Could not insert image: {e}")
                        pdf.multi_cell(0, 10, f"[Image error: {image_path}]")
                else:
                    print(f"⚠️  Image not found: {image_path}")
                    pdf.multi_cell(0, 10, f"[Image not found: {image_path}]")
            else:
                # Regular text
                pdf.multi_cell(0, 10, line)
        print(f"💾 Saving PDF to: {output_pdf_path}")
        pdf.output(output_pdf_path)
        print(f"✅ PDF created successfully at: {output_pdf_path}")
    except FileNotFoundError:
        print(f"❌ Error: File not found - {org_file_path}")
    except Exception as e:
        print(f"❌ An error occurred: {e}")
def main():
    print("=== Org to PDF Converter ===")
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
def create_pdf_from_org(org_file_path, output_pdf_path="output.pdf"):
    """
    Converts a .org file to a PDF, with support for images.
    Supports image lines like [[./path/to/image.jpg]] or #+IMAGE: ./path/to/image.jpg
    """
    try:
        print(f"📄 Reading org file: {org_file_path}")
        with open(org_file_path, 'r', encoding='utf-8') as f:
            lines = f.readlines()
        print("📝 Creating PDF...")
        pdf = UnicodePDF()
        pdf.add_page()
        for line in lines:
            line = line.strip()
            # Detect image syntax
            if line.startswith("[[") and line.endswith("]]"):
                image_path = line[2:-2].strip()
            elif line.lower().startswith("#+image:"):
                image_path = line[8:].strip()
            else:
                image_path = None
            # Insert image if detected and file exists
            if image_path:
                if os.path.isfile(image_path):
                    print(f"🖼️  Adding image: {image_path}")
                    try:
                        # Resize if needed (you can tweak width/height)
                        pdf.image(image_path, w=100)
                        pdf.ln(5)  # Add spacing after image
                    except Exception as e:
                        print(f"⚠️  Could not insert image: {e}")
                else:
                    print(f"⚠️  Image not found: {image_path}")
                    pdf.multi_cell(0, 10, f"[Image not found: {image_path}]")
            else:
                # Regular text
                pdf.multi_cell(0, 10, line)
        print(f"💾 Saving PDF to: {output_pdf_path}")
        pdf.output(output_pdf_path)
        print(f"✅ PDF created successfully at: {output_pdf_path}")
    except FileNotFoundError:
        print(f"❌ Error: File not found - {org_file_path}")
    except Exception as e:
        print(f"❌ An error occurred: {e}")
