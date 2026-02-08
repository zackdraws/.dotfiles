#!/usr/bin/env python3
import cv2
import numpy as np
import mss
import os
from datetime import datetime
from shutil import copy2
def main():
    # Set primary and backup directories
    primary_dir = "C:/Users/zacha/Desktop/2025"
    backup_dir = "D:/Backup/Videos"  # Change to your actual backup path
    # Create directories if they don't exist
    os.makedirs(primary_dir, exist_ok=True)
    os.makedirs(backup_dir, exist_ok=True)
    # Timestamped filename
    timestamp = datetime.now().strftime("%Y%m%d%H%M")
    filename = f"screen_recording_{timestamp}.mp4"
    # Full file paths
    primary_path = os.path.join(primary_dir, filename)
    backup_path = os.path.join(backup_dir, filename)
    # Set up screen capture
    with mss.mss() as sct:
        monitor = sct.monitors[1]  # Primary monitor
        # Get screen size
        width = monitor["width"]
        height = monitor["height"]
        # Define the codec and create VideoWriter object
        fourcc = cv2.VideoWriter_fourcc(*"mp4v")  # For mp4
        out = cv2.VideoWriter(primary_path, fourcc, 20.0, (width, height))
        print(f"Recording started. Press Ctrl+C to stop.")
        print(f"Saving to: {primary_path}")
        try:
            while True:
                img = sct.grab(monitor)
                frame = np.array(img)

                # Convert BGRA to BGR
                frame = cv2.cvtColor(frame, cv2.COLOR_BGRA2BGR)
                out.write(frame)
        except KeyboardInterrupt:
            print("\nRecording stopped by user.")
        finally:
            out.release()
            cv2.destroyAllWindows()
    # Copy recording to backup location
    try:
        copy2(primary_path, backup_path)
        print(f"Copied recording to backup location: {backup_path}")
    except Exception as e:
        print(f"Failed to copy to backup location: {e}")
if __name__ == "__main__":
    main()
