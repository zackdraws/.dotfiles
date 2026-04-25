def add_masonry_layout(pdf, image_paths):
    margin_mm = 5.3        # ~20px
    spacing_mm = 3
    header_offset = 15
    columns = 4            # ← changed to 4

    pdf.add_page()

    usable_width = pdf.w - 2 * margin_mm
    usable_height = pdf.h - margin_mm

    # Each column is exactly 1/4 of usable width
    column_width = (usable_width - (columns - 1) * spacing_mm) / columns

    column_heights = [margin_mm + header_offset] * columns

    px_to_mm = 25.4 / 96.0

    for img in image_paths:
        try:
            with Image.open(img) as im:
                orig_w, orig_h = im.size

            orig_w_mm = orig_w * px_to_mm
            orig_h_mm = orig_h * px_to_mm

            # Scale so width = exactly 1/4 page width
            scale = column_width / orig_w_mm
            disp_w = column_width
            disp_h = orig_h_mm * scale

            # Pick shortest column
            col = column_heights.index(min(column_heights))
            x = margin_mm + col * (column_width + spacing_mm)
            y = column_heights[col]

            # If overflow → new page
            if y + disp_h > pdf.h - margin_mm:
                pdf.add_page()
                column_heights = [margin_mm + header_offset] * columns
                col = 0
                x = margin_mm
                y = column_heights[col]

            pdf.image(img, x=x, y=y, w=disp_w, h=disp_h)

            column_heights[col] += disp_h + spacing_mm

        except Exception as e:
            print(f"Could not add image {img}: {e}")
