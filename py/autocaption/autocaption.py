import os

import subprocess

import json

from vosk import Model, KaldiRecognizer



VIDEO_PATH = "~/autocaption.mp4"

MODEL_PATH = "~/vosk-model-small-en-us-0.15"

AUDIO_PATH = "temp.wav"

SRT_PATH = "output_subtitles.srt"

OUTPUT_VIDEO = "video_with_subtitles.mp4"



# ----- Step 1: Extract Audio with ffmpeg -----

subprocess.run([

    "ffmpeg", "-y", "-i", VIDEO_PATH,

    "-ar", "16000", "-ac", "1", "-c:a", "pcm_s16le",

    AUDIO_PATH

])



# ----- Step 2: Transcribe Audio with Vosk -----

model = Model(MODEL_PATH)

rec = KaldiRecognizer(model, 16000)

rec.SetWords(True)



results = []

with open(AUDIO_PATH, "rb") as f:

    while True:

        data = f.read(4000)

        if len(data) == 0:

            break

        if rec.AcceptWaveform(data):

            results.append(json.loads(rec.Result()))

    results.append(json.loads(rec.FinalResult()))



# ----- Step 3: Write Subtitles to SRT -----

def format_time(seconds):

    h = int(seconds // 3600)

    m = int((seconds % 3600) // 60)

    s = int(seconds % 60)

    ms = int((seconds - int(seconds)) * 1000)

    return f"{h:02}:{m:02}:{s:02},{ms:03}"



with open(SRT_PATH, "w", encoding="utf-8") as srt_file:

    index = 1

    for result in results:

        if not result.get("result"):

            continue

        for word in result["result"]:

            srt_file.write(f"{index}\n")

            srt_file.write(f"{format_time(word['start'])} --> {format_time(word['end'])}\n")

            srt_file.write(f"{word['word']}\n\n")

            index += 1



# ----- Step 4: Burn Subtitles into Video -----

subprocess.run([

    "ffmpeg", "-y", "-i", VIDEO_PATH,

    "-vf", f"subtitles={SRT_PATH}",

    "-c:a", "copy", OUTPUT_VIDEO

])



print("✅ Done! Video with subtitles saved to:", OUTPUT_VIDEO)
