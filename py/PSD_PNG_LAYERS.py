#!/usr/bin/env python3
import os
import sys
from psd_tools import PSDImage
from PIL import Image
def export_psd_layers_to_png(psd_filename):
    current_dir = os.getcwd()
    psd_path = os.path.join(current_dir, psd_filename)
    output_dir = os.path.join(current_dir, 'exported_layers')
    if not os.path.isfile(psd_path):
        print(f"❌ File not found: {psd_path}")
        return
    try:
        psd = PSDImage.open(psd_path)
    except Exception as e:
        print(f"❌ Failed to open PSD file: {e}")
        return
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
    exported_count = 0
    skipped_invisible = 0
    skipped_errors = 0
    for index, layer in enumerate(psd.descendants()):
        if layer.is_group():
            continue  # Skip groups entirely
        if not layer.visible:
            print(f"🚫 Skipping invisible layer: {layer.name}")
            skipped_invisible += 1
            continue
        try:
            image = layer.composite()
            if image is None:
                print(f"⚠️ Skipping empty layer: {layer.name}")
                continue
            if image.mode != 'RGBA':
                image = image.convert('RGBA')
            # Sanitize and build filename
            layer_name = layer.name.strip().replace('/', '_').replace('\\', '_')
            if not layer_name:
                layer_name = f"layer_{index}"
            filename = f"{index:02d}_{layer_name}.png"
            filepath = os.path.join(output_dir, filename)
            image.save(filepath, 'PNG')
            print(f"✅ Exported: {filename}")
            exported_count += 1
        except Exception as e:
            print(f"⚠️ Skipping layer '{layer.name}' due to error: {e}")
            skipped_errors += 1
            continue
    print("\n🎉 Export complete!")
    print(f"   ✅ Exported layers:    {exported_count}")
    print(f"   🚫 Skipped invisible:  {skipped_invisible}")
    print(f"   ⚠️ Skipped due to error: {skipped_errors}")
    print(f"   📁 Output directory:    {output_dir}")
if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: export-psd-layers <your_file.psd>")
        sys.exit(1)
    export_psd_layers_to_png(sys.argv[1])
