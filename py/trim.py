from moviepy.video.io.VideoFileClip import VideoFileClip



def main():

    video_path = input("Enter the path to your MP4 video: ").strip()

    start_time = input("Enter the start time (in seconds or HH:MM:SS): ").strip()

    end_time = input("Enter the end time (in seconds or HH:MM:SS): ").strip()



    output_path = input("Enter output file name (e.g., output.mp4): ").strip()



    try:

        clip = VideoFileClip(video_path).subclip(start_time, end_time)

        clip.write_videofile(output_path, codec='libx264')

        print(f"Trimmed video saved to: {output_path}")

    except Exception as e:

        print(f"Error: {e}")



if __name__ == "__main__":

    main()
