"""Build the offline classical-story pack from Chinese Wikisource.

The source works are marked public domain on their Wikisource index pages.
Each chapter keeps its source revision and attribution URL. Run manually when
refreshing content; the app never scrapes Wikisource at runtime.
"""

from __future__ import annotations

import argparse
from collections import Counter
from datetime import date
from html.parser import HTMLParser
import json
from pathlib import Path
import re
import time
from urllib.error import HTTPError, URLError
from urllib.parse import unquote, urlencode, urlparse
from urllib.request import Request, urlopen

from opencc import OpenCC


ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "assets" / "content" / "classics_v1.json"
RAW_CACHE = ROOT / ".content-cache" / "wikisource_classics_raw.json"
API = "https://zh.wikisource.org/w/api.php"
USER_AGENT = "NihaoRobotEducationalImporter/1.0 (local, attributed reader)"
TO_SIMPLIFIED = OpenCC("t2s")
COLLECTIONS = (
    ("baiyu", "百句譬喻經", "百句譬喻经", "Buddhist parables", 98),
    ("zhuangzi", "莊子", "庄子", "Daoist stories and ideas", 33),
    ("liezi", "列子", "列子", "Daoist stories and ideas", 8),
)
CREDITS = {
    "baiyu": "Attributed to 伽斯那; Chinese translation by 求那毗地",
    "zhuangzi": "Inner chapters traditionally attributed to 庄子; later chapters have other contributors",
    "liezi": "Traditionally attributed to 列御寇",
}


def api_request(params: dict[str, str | int], *, post: bool = False) -> dict:
    data = urlencode(params).encode("utf-8")
    request = Request(
        API if post else f"{API}?{data.decode('utf-8')}",
        data=data if post else None,
        headers={"User-Agent": USER_AGENT},
    )
    for attempt in range(7):
        try:
            with urlopen(request, timeout=35) as response:
                payload = json.load(response)
            if "error" in payload:
                raise ValueError(f"Wikisource API: {payload['error']}")
            return payload
        except HTTPError as error:
            if attempt == 6 or error.code not in {429, 500, 502, 503, 504}:
                raise
            wait = int(error.headers.get("Retry-After", "0") or 0)
            time.sleep(max(wait, min(60, 2 ** attempt)))
        except (URLError, TimeoutError):
            if attempt == 6:
                raise
            time.sleep(min(60, 2 ** attempt))
    raise AssertionError("unreachable")


def parse_page(title: str) -> dict:
    params = {
        "action": "parse",
        "prop": "text|revid",
        "format": "json",
        "formatversion": "2",
        "variant": "zh-hans",
    }
    params["page"] = title
    return api_request(params)["parse"]


def query_pages(titles: list[str]) -> dict[str, dict]:
    pages = {}
    for offset in range(0, len(titles), 25):
        batch = titles[offset:offset + 25]
        payload = api_request({
            "action": "query",
            "prop": "revisions",
            "titles": "|".join(batch),
            "rvslots": "main",
            "rvprop": "ids|content",
            "format": "json",
            "formatversion": "2",
        }, post=True)
        for page in payload["query"]["pages"]:
            if "revisions" not in page:
                raise ValueError(f"Missing Wikisource page: {page['title']}")
            revision = page["revisions"][0]
            pages[page["title"]] = {
                "revision": revision["revid"],
                "raw": revision["slots"]["main"]["content"],
            }
        print(f"  fetched {min(offset + 25, len(titles))}/{len(titles)}", flush=True)
        time.sleep(2.5)
    return pages


class ChapterLinks(HTMLParser):
    def __init__(self, prefix: str):
        super().__init__()
        self.prefix = prefix + "/"
        self.titles: list[str] = []

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        if tag != "a":
            return
        href = dict(attrs).get("href") or ""
        path = urlparse(href).path
        if not path.startswith("/wiki/"):
            return
        title = unquote(path[len("/wiki/"):]).replace("_", " ")
        if (
            title.startswith(self.prefix)
            and title.count("/") == 1
            and title not in self.titles
        ):
            self.titles.append(title)


def source_url(title: str, revision: int) -> str:
    return f"https://zh.wikisource.org/w/index.php?{urlencode({'title': title, 'oldid': revision, 'variant': 'zh-hans'})}"


def strip_surrounding_templates(raw: str) -> str:
    """Remove Wikisource header/footer templates, including nested templates."""
    result = []
    cursor = 0
    while cursor < len(raw):
        start = raw.find("{{", cursor)
        if start < 0:
            result.append(raw[cursor:])
            break
        result.append(raw[cursor:start])
        name = re.match(r"{{\s*([^|}\n]+)", raw[start:])
        if not name or name.group(1).strip().lower() not in {"header", "header2", "footer"}:
            result.append("{{")
            cursor = start + 2
            continue
        depth = 1
        end = start + 2
        while end < len(raw) and depth:
            if raw.startswith("{{", end):
                depth += 1
                end += 2
            elif raw.startswith("}}", end):
                depth -= 1
                end += 2
            else:
                end += 1
        if depth:
            raise ValueError("Unclosed Wikisource header/footer template")
        cursor = end
    return "".join(result)


def reading_paragraphs(raw: str, title: str) -> list[str]:
    text = strip_surrounding_templates(raw)
    text = re.sub(
        r"{{\s*另\s*\|\s*([^|{}]+)\|[^{}]*}}",
        lambda match: match.group(1).strip(),
        text,
    )
    text = re.sub(r"\[\[[^\]|]+\|([^\]]+)]]", r"\1", text)
    text = re.sub(r"\[\[([^\]]+)]]", r"\1", text)
    if any(marker in text for marker in ("{{", "}}", "[[", "]]", "{|")):
        raise ValueError(f"Unprocessed Wikisource markup in {title}")
    paragraphs = [
        TO_SIMPLIFIED.convert(" ".join(part.split()))
        for part in re.split(r"\n\s*\n", text)
        if part.strip()
    ]
    chars = sum(len(part) for part in paragraphs)
    if chars < 40 or not re.search(r"[\u3400-\u9fff]", "".join(paragraphs)):
        raise ValueError(f"{title}: suspiciously short or non-Chinese body ({chars})")
    return paragraphs


def build_from_raw(raw: dict) -> dict:
    collections = []
    for collection in raw["collections"]:
        chapters = []
        for index_in_book, chapter in enumerate(collection["chapters"], 1):
            title = chapter["title"]
            revision = chapter["revision"]
            chapters.append({
                "id": f"{collection['id']}_{index_in_book:03d}",
                "title": TO_SIMPLIFIED.convert(title.split("/", 1)[1]),
                "revision": revision,
                "sourceUrl": source_url(title, revision),
                "paragraphs": reading_paragraphs(chapter["raw"], title),
            })
        collections.append({
            "id": collection["id"],
            "title": collection["title"],
            "description": collection["description"],
            "credit": CREDITS[collection["id"]],
            "sourceRevision": collection["sourceRevision"],
            "sourceUrl": collection["sourceUrl"],
            "chapters": chapters,
        })
        print(f"{collection['id']}: prepared {len(chapters)} readings", flush=True)
    return {**raw, "collections": collections}


def fetch_raw(list_only: bool = False) -> dict:
    collections = []
    for collection_id, source_title, display_title, description, expected in COLLECTIONS:
        index = parse_page(source_title)
        links = ChapterLinks(source_title)
        links.feed(index["text"])
        titles = links.titles
        if len(titles) != expected:
            raise ValueError(
                f"{source_title}: expected {expected} chapters, found {len(titles)}: "
                f"{titles[:4]}"
            )
        print(f"{collection_id}: {len(titles)} chapters", flush=True)
        if list_only:
            continue
        pages = query_pages(titles)
        missing = [title for title in titles if title not in pages]
        if missing:
            raise ValueError(f"Missing canonical pages: {missing[:4]}")
        chapters = [
            {"title": title, **pages[title]} for title in titles
        ]
        collections.append({
            "id": collection_id,
            "title": display_title,
            "description": description,
            "sourceRevision": index["revid"],
            "sourceUrl": source_url(source_title, index["revid"]),
            "chapters": chapters,
        })
        time.sleep(2.5)
    return {
        "schemaVersion": 1,
        "source": "Chinese Wikisource",
        "retrieved": date.today().isoformat(),
        "license": "Public-domain original works; Wikisource page contributions CC BY-SA 4.0",
        "collections": collections,
    }


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--list-only", action="store_true")
    parser.add_argument("--fetch-raw", action="store_true")
    parser.add_argument("--from-cache", action="store_true")
    args = parser.parse_args()
    if args.from_cache:
        raw = json.loads(RAW_CACHE.read_text(encoding="utf-8"))
    else:
        raw = fetch_raw(list_only=args.list_only)
    if args.list_only:
        return
    RAW_CACHE.parent.mkdir(exist_ok=True)
    RAW_CACHE.write_text(json.dumps(raw, ensure_ascii=False) + "\n", encoding="utf-8")
    print(f"Saved raw source cache: {RAW_CACHE}", flush=True)
    if args.fetch_raw:
        templates = Counter(
            match.group(1).split("|", 1)[0].strip()
            for collection in raw["collections"]
            for chapter in collection["chapters"]
            for match in re.finditer(r"{{\s*([^{}]+)}}", chapter["raw"])
        )
        print(f"Inline templates: {[(ascii(name), count) for name, count in templates.most_common(20)]}", flush=True)
        return
    pack = build_from_raw(raw)
    OUTPUT.write_text(json.dumps(pack, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"Wrote {OUTPUT} ({OUTPUT.stat().st_size} bytes)", flush=True)


if __name__ == "__main__":
    main()
