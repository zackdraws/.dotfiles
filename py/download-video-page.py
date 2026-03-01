#!/usr/bin/env python3
import sys
import os
import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin, urlparse

def download_file(url):
    filename = os.path.basename(urlparse(url).path)
    if not filename:
        filename = "video.mp4"

    print(f"Downloading {filename}...")

    with requests.get(url, stream=True) as r:
        r.raise_for_status()
        with open(filename, "wb") as f:
            for chunk in r.iter_content(8192):
                f.write(chunk)

    print("Done.")

def download_videos_from_page(page_url):
    response = requests.get(page_url)
    soup = BeautifulSoup(response.text, "html.parser")

    videos = soup.find_all("video")

    if not videos:
        print("No <video> tags found.")
        return

    for video in videos:
        src = video.get("src")
        if not src:
            source_tag = video.find("source")
            if source_tag:
                src = source_tag.get("src")

        if src:
            full_url = urljoin(page_url, src)
            download_file(full_url)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python script.py <page_url>")
        sys.exit(1)

    download_videos_from_page(sys.argv[1])
