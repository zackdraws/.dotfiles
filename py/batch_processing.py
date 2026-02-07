import os
import mutagen
from mutagen.mp3 import MP3
from mutagen.id3 import ID3, TIT2, TPE1, TALB
def update_tags(file_path, title, artist, album):
    audio = MP3(file_path, ID3=ID3)
    audio["TIT2"] = TIT2(encoding=3, text=title)
    audio["TPE1"] = TPE1(encoding=3, text=artist)
    audio["TALB"] = TALB(encoding=3, text=album)
    audio.save()
def batch_update_tags(directory):
    for file_name in os.listdir(directory):
        if file_name.endswith(".mp3"):
            file_path = os.path.join(directory, file_name)
            update_tags(file_path, "Sample Title", "Sample Artist", "Sample Album")
batch_update_tags("/path/to/your/music/folder")
