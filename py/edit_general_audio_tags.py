from mutagen.mp3 import MP3
from mutagen.id3 import ID3, TIT2, TPE1, TALB
# Load the MP3 file
audio = MP3("path/to/your/file.mp3", ID3=ID3)
# Set the tags
audio["TIT2"] = TIT2(encoding=3, text="Song Title")  # Title
audio["TPE1"] = TPE1(encoding=3, text="Artist Name")  # Artist
audio["TALB"] = TALB(encoding=3, text="Album Name")  # Album
# Save the file
audio.save()
print("Tags updated!")
