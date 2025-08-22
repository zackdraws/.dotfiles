#!/usr/bin/env python3
import os
import shutil
# Get current working directory (child folder)
cwd = os.getcwd()
# Get parent directory
parent = os.path.dirname(cwd)
# List all files (ignore subdirectories)
for filename in os.listdir(cwd):
    source = os.path.join(cwd, filename)
    destination = os.path.join(parent, filename)

    if os.path.isfile(source):
        try:
            shutil.move(source, destination)
            print(f"📁 Moved: {filename}")
        except Exception as e:
            print(f"❌ Error moving {filename}: {e}")

print("\n✅ Done! All files moved to the parent folder.")
