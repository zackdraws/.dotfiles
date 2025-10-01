import re

from datetime import datetime, timedelta



def parse_applications(raw_text):

    entries = []

    # Split entries based on "Applied" or "Not selected" to isolate job chunks

    job_blocks = re.split(r"\n(?=Applied|Not selected)", raw_text)



    current_date = datetime.now()

    time_increment = timedelta(minutes=1)

    timestamp = datetime(current_date.year, current_date.month, current_date.day, 10, 0)



    for block in job_blocks:

        job = {}



        # Status

        if "Not selected" in block:

            job["status"] = "Not selected"

        else:

            job["status"] = "Applied"



        # Position and Company

        match = re.search(r"(?P<position>.+?)job description.*?\n(?P<company>.+)", block, re.IGNORECASE)

        if match:

            job["position"] = match.group("position").strip()

            job["company"] = match.group("company").strip()



        # Location

        location_match = re.search(r"\n(?P<location>[\w\s\-,]+, CA)", block)

        if location_match:

            job["location"] = location_match.group("location").strip()

        else:

            job["location"] = "California"  # Default fallback



        # Response Time

        response_match = re.search(r"This employer typically responds within .+? day", block)

        if response_match:

            job["response_time"] = response_match.group(0).strip()



        # Notes

        if "Job closed or expired" in block:

            job["notes"] = "Job closed or expired on Indeed"

        if "Application viewed" in block:

            job["notes"] = "Application viewed"



        # Applied date parsing (best effort)

        if "Applied today" in block:

            job["applied_date"] = timestamp.strftime("%Y-%m-%d %H:%M")

        elif "Applied on Mon" in block or "Applied on Monday" in block:

            date = current_date - timedelta(days=(current_date.weekday() - 0) % 7)

            job["applied_date"] = date.strftime("%Y-%m-%d 10:00")

        elif "Applied on Wed" in block or "Applied on Wednesday" in block:

            date = current_date - timedelta(days=(current_date.weekday() - 2) % 7)

            job["applied_date"] = date.strftime("%Y-%m-%d 10:00")

        elif match := re.search(r"Applied on (Aug \d{1,2})", block):

            raw_date = match.group(1) + f" {current_date.year}"

            date_obj = datetime.strptime(raw_date, "%b %d %Y")

            job["applied_date"] = date_obj.strftime("%Y-%m-%d 10:00")

        else:

            job["applied_date"] = timestamp.strftime("%Y-%m-%d %H:%M")



        entries.append(job)

        timestamp += time_increment  # Add 1 minute for next entry to keep unique timestamps



    return entries





def format_org_entry(job):

    header = f"** {job['position']} at {job['company']} <{job['applied_date']}>"

    body = [

        f"- Location: {job.get('location', 'N/A')}",

        f"- Status: {job.get('status', 'N/A')}"

    ]

    if 'response_time' in job:

        body.append(f"- {job['response_time']}")

    if 'notes' in job:

        body.append(f"- Note: {job['notes']}")

    return header + "\n" + "\n".join(body)





def main():

    print("Paste your raw job application data below. End with an empty line (press Enter twice):\n")

    lines = []

    while True:

        line = input()

        if line.strip() == "":

            break

        lines.append(line)

    raw_input_text = "\n".join(lines)



    parsed_jobs = parse_applications(raw_input_text)

    org_output = "\n\n".join(format_org_entry(job) for job in parsed_jobs)



    print("\n--- Org Mode Output ---\n")

    print(org_output)



    # Optionally write to file

    with open("job_applications.org", "w") as f:

        f.write(org_output)





if __name__ == "__main__":

    main()
