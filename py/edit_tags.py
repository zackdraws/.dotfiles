import os
from mutagen.mp3 import MP3
from mutagen.id3 import ID3, TIT2, TPE1, TALB

# Function to update the tags of a given MP3 file
def update_tags(file_path, title, artist, album):
    audio = MP3(file_path, ID3=ID3)
    audio["TIT2"] = TIT2(encoding=3, text=title)  # Title
    audio["TPE1"] = TPE1(encoding=3, text=artist)  # Artist
    audio["TALB"] = TALB(encoding=3, text=album)   # Album
    audio.save()

# Function to rename the MP3 file based on its tags
def rename_file(file_path):
    audio = MP3(file_path, ID3=ID3)
    artist = audio.get("TPE1", "Unknown Artist").text[0]
    title = audio.get("TIT2", "Unknown Title").text[0]
    
    # Construct the new file name (Artist - Title.mp3)
    new_name = f"{artist} - {title}.mp3"
    new_file_path = os.path.join(os.path.dirname(file_path), new_name)
    
    # Rename the file if the new name is different from the old one
    if file_path != new_file_path:
        os.rename(file_path, new_file_path)
        print(f"Renamed: {file_path} -> {new_file_path}")
    else:
        print(f"File already named correctly: {file_path}")

# Function to process the files in a directory
def process_directory(directory):
    for file_name in os.listdir(directory):
        if file_name.endswith(".mp3"):
            file_path = os.path.join(directory, file_name)
            
            # Ask for user input for each MP3 file
            print(f"Processing {file_name}:")
            artist = input("  Enter Artist: ")
            title = input("  Enter Title: ")
            album = input("  Enter Album: ")

            # Update the tags and rename the file
            update_tags(file_path, title, artist, album)
            rename_file(file_path)
            print(f"Processed: {file_name}\n")

# Main function
def main():
    # Ask the user for the directory containing the MP3 files
    directory = input("Enter the directory path containing MP3 files: ")

    # Check if the directory exists
    if not os.path.isdir(directory):
        print("Invalid directory path. Please try again.")
        return

    # Process all MP3 files in the specified directory
    process_directory(directory)
    print("Finished processing files.")

if __name__ == "__main__":
    main()
