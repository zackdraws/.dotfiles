import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin, urlparse
import sys
def extract_artwork_urls(group_url):
    print(f"Fetching page: {group_url}")
    headers = {
        "User-Agent": "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)"
    }
    resp = requests.get(group_url, headers=headers)
    if resp.status_code != 200:
        print(f"Error fetching page: {resp.status_code}")
        return []
    soup = BeautifulSoup(resp.text, "html.parser")
    # Find all <a> tags that link to /asset/ (individual artwork)
    artwork_links = set()
    for a in soup.find_all("a", href=True):
        href = a['href']
        # Normalize relative URLs
        full_url = urljoin(group_url, href)
        # Check if URL path contains /asset/
        parsed = urlparse(full_url)
        if "/asset/" in parsed.path:
            artwork_links.add(full_url.split("?")[0])  # Remove any query params for cleanliness
    return sorted(artwork_links)
if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python extract_artwork_urls.py <GAC group URL>")
        sys.exit(1)
    group_page_url = sys.argv[1]
    urls = extract_artwork_urls(group_page_url)
    if not urls:
        print("No artwork URLs found.")
    else:
        print(f"Found {len(urls)} artwork URLs:")
        for url in urls:
            print(url)
