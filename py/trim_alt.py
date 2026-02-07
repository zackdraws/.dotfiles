import subprocess
def main():
    input_path = input("Enter the path to your MP4 video: ").strip()
    start_time = input("Enter the start time (in seconds or HH:MM:SS): ").strip()
    end_time = input("Enter the end time (in seconds or HH:MM:SS): ").strip()
    output_path = input("Enter output file name (e.g., output.mp4): ").strip()
    try:
        command = [
            "ffmpeg",
            "-i", input_path,
            "-ss", start_time,
            "-to", end_time,
            "-c", "copy",
            output_path
        ]
        subprocess.run(command, check=True)
        print(f"Trimmed video saved to: {output_path}")
    except subprocess.CalledProcessError as e:
        print("An error occurred while trimming the video:", e)
if __name__ == "__main__":
    main()
