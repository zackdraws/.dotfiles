#!/usr/bin/env python3

"""
Usage 
  blender --background --python py/download.py -- \
    https://www.models-resource.com/link

"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path
from urllib.parse import urljoin, urlparse

import requests
from bs4 import BeautifulSoup

ALLOWED_HOSTS = {
    "www.models-resource.com",
    "models-resource.com",
    "models.spriters-resource.com",
}
CHUNK_SIZE = 1024 * 1024


def model_id_from_url(page_url: str) -> str:
    parsed = urlparse(page_url)
    if parsed.scheme not in {"http", "https"} or parsed.netloc.lower() not in ALLOWED_HOSTS:
        raise ValueError("URL must be an http(s) page on models.spriters-resource.com or www.models-resource.com")

    match = re.search(r"/(?:model|asset)/(\d+)/?$", parsed.path)
    if not match:
        raise ValueError("URL must point to one page ending in /model/<id>/ or /asset/<id>/")
    return match.group(1)


def find_archive_url(page_url: str, html: str) -> str:
    soup = BeautifulSoup(html, "html.parser")
    for anchor in soup.find_all("a", href=True):
        candidate = urljoin(page_url, anchor["href"])
        parsed = urlparse(candidate)
        if (
            parsed.scheme in {"http", "https"}
            and parsed.netloc.lower() in ALLOWED_HOSTS
            and parsed.path.lower().endswith(".zip")
        ):
            return candidate
    raise RuntimeError("No ZIP download link was found on this model page.")


def download_model(
    page_url: str, output_dir: Path, dry_run: bool = False, force: bool = False
) -> Path | None:
    model_id = model_id_from_url(page_url)
    session = requests.Session()
    session.headers["User-Agent"] = "Mozilla/5.0 (Model Resource single-model downloader)"

    response = session.get(page_url, timeout=30)
    response.raise_for_status()
    archive_url = find_archive_url(page_url, response.text)

    destination = output_dir / f"models-resource-{model_id}.zip"
    print(f"Model page: {page_url}")
    print(f"Archive: {archive_url}")
    print(f"Destination: {destination}")
    if dry_run:
        return None
    if destination.exists() and not force:
        raise FileExistsError(f"{destination} already exists (use --force to replace it)")

    output_dir.mkdir(parents=True, exist_ok=True)
    temporary = destination.with_suffix(".zip.part")
    try:
        with session.get(archive_url, stream=True, timeout=(30, 120)) as download:
            download.raise_for_status()
            with temporary.open("wb") as file:
                for chunk in download.iter_content(CHUNK_SIZE):
                    if chunk:
                        file.write(chunk)
        temporary.replace(destination)
    except Exception:
        temporary.unlink(missing_ok=True)
        raise

    print(f"Downloaded {destination.stat().st_size:,} bytes.")
    return destination


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("model_page_url", help="A single The Models Resource /model/<id>/ URL")
    parser.add_argument(
        "-o",
        "--output-dir",
        type=Path,
        default=Path.cwd(),
        help="Directory for the ZIP archive (default: current directory)",
    )
    parser.add_argument("--dry-run", action="store_true", help="Show the discovered ZIP URL without downloading it")
    parser.add_argument("--force", action="store_true", help="Replace an existing archive with the same model ID")
    # Blender leaves its own options in sys.argv; arguments after "--" belong
    # to this script. Normal Python invocation has no separator.
    script_args = sys.argv[sys.argv.index("--") + 1 :] if "--" in sys.argv else None
    return parser.parse_args(script_args)


if __name__ == "__main__":
    try:
        arguments = parse_args()
        download_model(arguments.model_page_url, arguments.output_dir, arguments.dry_run, arguments.force)
    except (ValueError, requests.RequestException, RuntimeError, OSError) as error:
        print(f"Error: {error}", file=sys.stderr)
        raise SystemExit(1)
