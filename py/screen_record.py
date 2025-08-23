#!/usr/bin/env python3
import cv2
import numpy as np
import mss
import time
import os
from datetime import datetime

def main():
    with mss.mss() as sct:
        monitor = sct.monitors[1]  # Primary monitor

        mon = {
            "top": monitor["top"],
            "left": monitor["left"],
            "width": monitor["width"],
            "height": monitor["height"],
        }

        # Get current timestamp for filename
        timestamp = datetime.now().strftime("%Y%m%d%H%M")
        filename = f"screen_recording_{timestamp}.mp4"

        # Save to Windows Desktop
	save_dir = "C:/Users/zacha/Desktop/2025"
	os.makedirs(save_dir, exist_ok=True)  # Create the folder if it doesn't exist
	filepath = os.path.join(save_dir, filename)


        # Use mp4v codec for mp4 files
        fourcc = cv2.VideoWriter_fourcc(*"mp4v")
        out = cv2.VideoWriter(filepath, fourcc, 20.0, (mon["width"], mon["height"]))

        print(f"Recording started. Saving to {filepath}")
        print("Press Ctrl+C to stop recording.")

        try:
            while True:
                img = np.array(sct.grab(mon))
                frame = cv2.cvtColor(img, cv2.COLOR_BGRA2BGR)
                out.write(frame)
        except KeyboardInterrupt:
            # When you press Ctrl+C, stop recording gracefully
            print("\nRecording stopped by user.")
        finally:
            out.release()
            cv2.destroyAllWindows()
            print(f"Recording saved to {filepath}")

if __name__ == "__main__":
    main()
