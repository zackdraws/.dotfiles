#!/usr/bin/env python3
import cv2
import numpy as np
import mss
import time
import os
from datetime import datetime
def main():
    with mss.mss() as sct:
        monitor = sct.monitors[1]  # Primary monitor (full screen)
        mon = {
            "top": monitor["top"],
            "left": monitor["left"],
            "width": monitor["width"],
            "height": monitor["height"],
        }
        # Get timestamp for unique filename
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        filename = f"screen_recording_{timestamp}.mp4"
        # Save to Windows Desktop (edit this if needed)
        save_dir = "C:/Users/zacha/Desktop"  # Replace with your actual username
        os.makedirs(save_dir, exist_ok=True)
        filepath = os.path.join(save_dir, filename)
        # Video writer setup
        fourcc = cv2.VideoWriter_fourcc(*"mp4v")
        out = cv2.VideoWriter(filepath, fourcc, 20.0, (mon["width"], mon["height"]))
        print(f"📹 Recording started: {filepath}")
        print("⏹️ Press Ctrl+C to stop...")
        try:
            while True:
                img = np.array(sct.grab(mon))
                frame = cv2.cvtColor(img, cv2.COLOR_BGRA2BGR)
                out.write(frame)
                time.sleep(1/20)  # Match frame rate (~20 FPS)
        except KeyboardInterrupt:
            print("\n⛔ Recording stopped by user.")
        finally:
            out.release()
            cv2.destroyAllWindows()
            print(f"✅ Recording saved to: {filepath}")
if __name__ == "__main__":
    main()
