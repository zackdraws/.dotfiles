#!/usr/bin/env python3
"""
PC-friendly duplicate of ../sh/export/export_org_to_pdf.sh.

Interactive:
    python export_org_to_pdf_pc.py

Direct:
    python export_org_to_pdf_pc.py input.org output.pdf
"""

from __future__ import annotations

import argparse
import os
import platform
import shlex
import shutil
import subprocess
import sys
from pathlib import Path


DEFAULT_GEOMETRY = "left=0.90in, right=0.90in, top=0.50in, bottom=0.35in"
PDF_ENGINE_CANDIDATES = ("xelatex", "lualatex", "pdflatex", "typst", "tectonic", "wkhtmltopdf", "weasyprint")


def msys2_root() -> Path | None:
    if os.name != "nt":
        return None

    candidates: list[Path] = []

    env_root = os.environ.get("MSYS2_ROOT")
    if env_root:
        candidates.append(Path(env_root))

    for base in (Path(sys.executable), Path.cwd(), Path(__file__).resolve()):
        candidates.extend(base.parents)

    default_root = Path(r"C:\msys64")
    if default_root not in candidates:
        candidates.append(default_root)

    for candidate in candidates:
        if (candidate / "usr" / "bin" / "pacman.exe").is_file():
            return candidate

    return None


def normalize_path(raw_path: str) -> Path:
    text = raw_path.strip().strip("\"'")

    if os.name == "nt":
        text = text.replace("\\", "/")
        lower_text = text.lower()

        if text.startswith("//"):
            return Path(text).expanduser()
        if len(text) >= 3 and text[0] == "/" and text[1].isalpha() and text[2] == "/":
            text = f"{text[1].upper()}:{text[2:]}"
        elif len(text) >= 7 and lower_text.startswith("/mnt/") and text[5].isalpha() and text[6] == "/":
            text = f"{text[5].upper()}:{text[6:]}"
        elif text.startswith("/"):
            root = msys2_root()
            if root:
                text = str(root / text.lstrip("/"))

    return Path(text).expanduser()


def ensure_suffix(path: Path, suffix: str) -> Path:
    if path.suffix.lower() != suffix:
        return path.with_name(path.name + suffix)
    return path


def default_font() -> str:
    if platform.system() == "Windows":
        return "Arial"
    return "Europa"


def find_pandoc(explicit_path: str | None) -> str | None:
    if explicit_path:
        path = normalize_path(explicit_path)
        return str(path) if path.is_file() else explicit_path

    return find_executable("pandoc")


def executable_candidates(command: str) -> list[Path]:
    candidates: list[Path] = []

    path = normalize_path(command)
    candidates.append(path)
    if os.name == "nt" and not path.suffix:
        candidates.append(path.with_suffix(".exe"))

    if os.name == "nt" and not path.is_absolute():
        root = msys2_root()
        if root:
            for prefix in ("ucrt64", "mingw64", "clang64", "usr"):
                candidate = root / prefix / "bin" / command
                candidates.append(candidate)
                if not candidate.suffix:
                    candidates.append(candidate.with_suffix(".exe"))

        program_files = Path(os.environ.get("ProgramFiles", r"C:\Program Files"))
        local_appdata = os.environ.get("LOCALAPPDATA")
        if command.lower().startswith("pandoc"):
            candidates.append(program_files / "Pandoc" / "pandoc.exe")
            if local_appdata:
                candidates.append(Path(local_appdata) / "Pandoc" / "pandoc.exe")

    unique_candidates = []
    seen = set()
    for candidate in candidates:
        key = str(candidate).lower()
        if key not in seen:
            unique_candidates.append(candidate)
            seen.add(key)

    return unique_candidates


def find_executable(command: str) -> str | None:
    for candidate in executable_candidates(command):
        if candidate.is_file():
            return str(candidate)

    found = shutil.which(command)
    if found:
        return found

    return None


def resolve_pdf_engine(engine: str, dry_run: bool) -> str | None:
    if engine != "auto":
        found = find_executable(engine)
        if found:
            return found
        return engine if dry_run else None

    for candidate in PDF_ENGINE_CANDIDATES:
        found = find_executable(candidate)
        if found:
            return found

    return PDF_ENGINE_CANDIDATES[0] if dry_run else None


def command_string(command: list[str]) -> str:
    if os.name == "nt":
        return subprocess.list2cmdline(command)
    return shlex.join(command)


def build_command(
    pandoc: str,
    input_file: Path,
    output_file: Path,
    pdf_engine: str,
    mainfont: str | None,
    geometry: str | None,
) -> list[str]:
    command = [
        pandoc,
        str(input_file),
        "-o",
        str(output_file),
        "--pdf-engine",
        pdf_engine,
    ]

    if mainfont:
        command.extend(["--variable", f"mainfont={mainfont}"])

    if geometry:
        command.extend(["--variable", f"geometry:{geometry}"])

    return command


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Export an Org file to PDF with Pandoc using PC-friendly path handling.",
    )
    parser.add_argument("input_file", nargs="?", help="Input .org file.")
    parser.add_argument("output_file", nargs="?", help="Output .pdf file.")
    parser.add_argument("--font", default=default_font(), help="Main PDF font. Default: %(default)s")
    parser.add_argument("--no-mainfont", action="store_true", help="Do not pass a mainfont to Pandoc.")
    parser.add_argument(
        "--pdf-engine",
        default="auto",
        help="Pandoc PDF engine, or 'auto' to use the first available engine. Default: %(default)s",
    )
    parser.add_argument("--geometry", default=DEFAULT_GEOMETRY, help="Pandoc geometry value.")
    parser.add_argument("--pandoc", help="Path to pandoc.exe if it is not on PATH.")
    parser.add_argument("--dry-run", action="store_true", help="Print the Pandoc command without running it.")
    return parser.parse_args()


def main() -> int:
    args = parse_args()

    input_text = args.input_file or input("org file name? ").strip()
    output_text = args.output_file or input("save as? ").strip() or "output.pdf"

    input_file = ensure_suffix(normalize_path(input_text), ".org")
    output_file = ensure_suffix(normalize_path(output_text), ".pdf")
    mainfont = None if args.no_mainfont else args.font

    if not input_file.is_file():
        print(f"Input file not found: {input_file}", file=sys.stderr)
        return 1

    pandoc = find_pandoc(args.pandoc)
    if not pandoc:
        if args.dry_run:
            pandoc = args.pandoc or "pandoc"
        else:
            print("Pandoc was not found.", file=sys.stderr)
            print("On Windows, install it with: winget install --id JohnMacFarlane.Pandoc", file=sys.stderr)
            return 1

    pdf_engine = resolve_pdf_engine(args.pdf_engine, args.dry_run)
    if not pdf_engine:
        print(f"PDF engine was not found: {args.pdf_engine}", file=sys.stderr)
        print("Install one of these engines, or pass --pdf-engine with its full path:", file=sys.stderr)
        print(", ".join(PDF_ENGINE_CANDIDATES), file=sys.stderr)
        return 1

    output_file.parent.mkdir(parents=True, exist_ok=True)

    command = build_command(
        pandoc=pandoc,
        input_file=input_file,
        output_file=output_file,
        pdf_engine=pdf_engine,
        mainfont=mainfont,
        geometry=args.geometry,
    )

    print(command_string(command))

    if args.dry_run:
        return 0

    result = subprocess.run(command, check=False)
    if result.returncode != 0:
        print(f"Export failed with exit code {result.returncode}.", file=sys.stderr)
        return result.returncode

    print(f"Export complete. Output saved to {output_file}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
