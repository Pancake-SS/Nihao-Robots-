"""Build an attributed English companion pack for all offline classics.

Baiyu translations: Shi Huijing, Waken, CC BY-NC-SA 4.0.
Zhuangzi: James Legge (1891), public domain.
Liezi: Lionel Giles and Anton Forke (1912), public domain.
"""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import re
import time
from urllib.request import Request, urlopen

from lxml import html


ROOT = Path(__file__).resolve().parents[1]
CHINESE = ROOT / 'assets/content/classics_v1.json'
OUTPUT = ROOT / 'assets/content/classics_english_v1.json'
CACHE = ROOT / '.content-cache/classics_english'
WAKEN = 'https://waken.org/translations/han/piyu/baiyujing/'
LEGGE_1 = 'http://www.theology101.org/tao/sbe39/'
LEGGE_2 = 'http://www.theology101.org/tao/sbe40/'
GILES = 'http://www.theology101.org/tao/tt/'
FORKE = 'http://www.theology101.org/tao/ycgp/'


def fetch(url: str, *, from_cache: bool) -> bytes:
    cache = CACHE / hashlib.sha256(url.encode()).hexdigest()
    if cache.exists():
        return cache.read_bytes()
    if from_cache:
        raise FileNotFoundError(f'Missing cached source: {url}')
    for attempt in range(5):
        try:
            with urlopen(Request(url, headers={
                'User-Agent': 'NihaoRobotEducationalImporter/1.0 (offline, attributed reader)',
            }), timeout=35) as response:
                data = response.read()
            cache.parent.mkdir(parents=True, exist_ok=True)
            cache.write_bytes(data)
            return data
        except Exception:
            if attempt == 4:
                raise
            time.sleep(2 ** attempt)
    raise AssertionError('unreachable')


def clean(text: str) -> str:
    return re.sub(r'\s+', ' ', text).strip()


def body_paragraphs(url: str, *, from_cache: bool) -> list[str]:
    root = html.fromstring(fetch(url, from_cache=from_cache))
    children = list(root.xpath('//body')[0])
    first = next(i for i, node in enumerate(children) if node.tag in {'h1', 'h2'})
    end = next((i for i in range(first + 1, len(children))
                if children[i].tag == 'h3' and clean(children[i].text_content()).lower() == 'footnotes'),
               len(children))
    # At these historical HTML mirrors, the final horizontal rule begins
    # footer navigation. Earlier rules mark page boundaries.
    if end == len(children):
        rules = [i for i in range(first + 1, len(children)) if children[i].tag == 'hr']
        if rules:
            end = rules[-1]
    result = []
    for node in children[first + 1:end]:
        if node.tag not in {'p', 'blockquote'}:
            continue
        text = clean(node.text_content())
        if not text or re.fullmatch(r'\{?p\.\s*\d+\}?', text, re.I):
            continue
        result.append(text)
    if len(''.join(result)) < 100:
        raise ValueError(f'Translation unexpectedly short: {url}')
    return result


def baiyu(*, from_cache: bool) -> dict[str, dict]:
    found = {}
    for volume in range(1, 5):
        url = WAKEN + f'{volume:02d}_j{volume:02d}/'
        root = html.fromstring(fetch(url, from_cache=from_cache))
        sections = root.xpath('//section[@id="reg-bai"]//div[contains(@class, "han-unit__lang--en")]')
        if not sections:
            raise ValueError(f'No English plain reading: {url}')
        for section in sections:
            current = None
            for node in section.xpath('.//p'):
                text = clean(node.text_content())
                match = re.fullmatch(r'baiyujing-yu-(\d+)-en', node.get('id') or '')
                if match:
                    current = f'baiyu_{int(match.group(1)):03d}'
                    if current in found:
                        raise ValueError(f'Duplicate parable {current}')
                    found[current] = {
                        'id': current,
                        'paragraphs': [],
                        'credit': 'English translation by Shi Huijing (Waken, 2026)',
                        'sourceUrl': url + '#' + node.get('id'),
                        'license': 'CC BY-NC-SA 4.0',
                    }
                elif text.startswith('〔'):
                    current = None
                if current is not None:
                    if text:
                        found[current]['paragraphs'].append(text)
        print(f'Baiyu fascicle {volume}: {len(found)} parables', flush=True)
    if len(found) != 98:
        raise ValueError(f'Expected 98 English parables, found {len(found)}')
    return found


def zhuangzi(*, from_cache: bool) -> dict[str, dict]:
    found = {}
    for number in range(1, 34):
        url = (LEGGE_1 + f'sbe39{121 + number:03d}.htm') if number <= 17 else (LEGGE_2 + f'sbe40{number - 16:02d}.htm')
        paragraphs = body_paragraphs(url, from_cache=from_cache)
        found[f'zhuangzi_{number:03d}'] = {
            'id': f'zhuangzi_{number:03d}',
            'paragraphs': paragraphs,
            'credit': 'English translation by James Legge (1891)',
            'sourceUrl': url,
            'license': 'Public domain',
        }
        print(f'Zhuangzi {number}/33: {len(paragraphs)} paragraphs', flush=True)
    return found


def liezi(*, from_cache: bool) -> dict[str, dict]:
    found = {}
    for number in range(1, 9):
        if number == 7:
            source_urls = [FORKE + f'ycgp{i:02d}.htm' for i in range(1, 20)]
            credit = 'English translation by Anton Forke (1912)'
            source_url = FORKE + 'index.htm'
        else:
            source_urls = [GILES + f'tt{number + 3 if number < 7 else 10:02d}.htm']
            credit = 'English translation by Lionel Giles (1912)'
            source_url = source_urls[0]
        paragraphs = []
        for url in source_urls:
            paragraphs.extend(body_paragraphs(url, from_cache=from_cache))
        found[f'liezi_{number:03d}'] = {
            'id': f'liezi_{number:03d}',
            'paragraphs': paragraphs,
            'credit': credit,
            'sourceUrl': source_url,
            'license': 'Public domain',
        }
        print(f'Liezi {number}/8: {len(paragraphs)} paragraphs', flush=True)
    return found


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument('--from-cache', action='store_true')
    args = parser.parse_args()
    originals = json.loads(CHINESE.read_text(encoding='utf-8'))
    expected = {chapter['id'] for collection in originals['collections'] for chapter in collection['chapters']}
    translations = {**baiyu(from_cache=args.from_cache),
                    **zhuangzi(from_cache=args.from_cache),
                    **liezi(from_cache=args.from_cache)}
    if set(translations) != expected:
        raise ValueError(f'Chapter mismatch: missing={expected - set(translations)}, extra={set(translations) - expected}')
    for item in translations.values():
        if not item['paragraphs'] or any(not text for text in item['paragraphs']):
            raise ValueError(f'Empty English text: {item["id"]}')
    ordered = [translations[chapter['id']] for collection in originals['collections'] for chapter in collection['chapters']]
    OUTPUT.write_text(json.dumps({'schemaVersion': 1, 'translations': ordered}, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print(f'Wrote {len(ordered)} English chapters, {OUTPUT.stat().st_size} bytes', flush=True)


if __name__ == '__main__':
    main()
