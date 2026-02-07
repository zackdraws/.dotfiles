#!/usr/bin/env python3
import os
import re
# Function to clean the title by removing unwanted characters
def clean_filename(filename):
    # Separate the filename and extension
    name, ext = os.path.splitext(filename)
    # Replace underscores, dashes with spaces
    name = name.replace('_', ' ').replace('-', ' ')
    # Remove unwanted characters (keeping only letters, numbers, underscores, parentheses, and dashes)
    name = re.sub(r'[^\w\s\(\)\[\]\-]', '', name)
    # Replace spaces with underscores
    name = name.replace(' ', '_')
    # Capitalize words for nicer formatting (Optional)
    name = '_'.join([word.capitalize() for word in name.split('_')])
    # Add the extension back to the cleaned name
    cleaned_filename = name + ext
    
    return cleaned_filename
# Function to rename files in the folder
def rename_files_in_folder(folder_path):
    print(f"Starting to clean filenames in: {folder_path}")
    
    for filename in os.listdir(folder_path):
        file_path = os.path.join(folder_path, filename)
        if os.path.isfile(file_path):
            # Clean the filename
            cleaned_filename = clean_filename(filename)
            # If the filename was modified, rename it
            if filename != cleaned_filename:
                new_file_path = os.path.join(folder_path, cleaned_filename)
                
                # Rename the file
                if not os.path.exists(new_file_path):  # Avoid conflicts with existing files
                    os.rename(file_path, new_file_path)
                    print(f"Renamed: {filename} -> {cleaned_filename}")
                else:
                    print(f"File with name {cleaned_filename} already exists. Skipping renaming.")
            else:
                print(f"File '{filename}' is already clean. Skipping.")
# Main function
def main():
    import argparse
    parser = argparse.ArgumentParser(description="Clean MP3 filenames")
    parser.add_argument("folder", help="Folder containing MP3 files")
    
    args = parser.parse_args()
    # Run the renaming function
    rename_files_in_folder(args.folder)
if __name__ == "__main__":
    main()
