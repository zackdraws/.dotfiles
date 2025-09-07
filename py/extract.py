import pytesseract
from PIL import Image
import re
from datetime import datetime

# If Tesseract is not in PATH, set the full path here
# pytesseract.pytesseract.tesseract_cmd = r'C:\Program Files\Tesseract-OCR\tesseract.exe'

def extract_schedule(image_path):
    image = Image.open(image_path)
    text = pytesseract.image_to_string(image)

    # Regex pattern to match date, time, and job title
    pattern = re.compile(
        r'(?P<day>\w{3}), (?P<month>\w{3}) (?P<date>\d{1,2})\s+'
        r'(?P<time>(?:\d{1,2}:\d{2} (?:AM|PM)))\s+'
        r'(?P<role>[\w\- ]+)\s+\|\s+(?P<details>[\w\- ]+)'
    )

    entries = []
    for match in pattern.finditer(text):
        data = match.groupdict()

        # Convert date to ISO format for org-mode
        full_date_str = f"{data['month']} {data['date']} 2025 {data['time']}"
        dt = datetime.strptime(full_date_str, "%b %d %Y %I:%M %p")
        org_date = dt.strftime("<%Y-%m-%d %a %H:%M>")

        entries.append(f"** {data['role'].strip()} | {data['details'].strip()}\n{org_date}\n")

    return "* Schedule\n\n" + "\n".join(entries)


if __name__ == "__main__":
    import sys
    if len(sys.argv) != 2:
        print("Usage: python schedule_extractor.py image.jpg")
        sys.exit(1)

    image_path = sys.argv[1]
    output = extract_schedule(image_path)

    with open("schedule.org", "w") as f:
        f.write(output)

    print("Schedule extracted to 'schedule.org'")
