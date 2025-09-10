import subprocess

import sys



def m4a_to_mp4(audio_file, image_file, output_file):

    command = [

        "ffmpeg",

        "-loop", "1",

        "-i", image_file,

        "-i", audio_file,

        "-c:v", "libx264",

        "-c:a", "aac",

        "-b:a", "192k",

        "-shortest",

        "-movflags", "+faststart",

        output_file

    ]



    subprocess.run(command, check=True)



# Example usage:

# python convert.py input.m4a image.jpg output.mp4



if __name__ == "__main__":

    if len(sys.argv) != 4:

        print("Usage: python convert.py input.m4a image.jpg output.mp4")

        sys.exit(1)



    audio = sys.argv[1]

    image = sys.argv[2]

    output = sys.argv[3]



    m4a_to_mp4(audio, image, output)
