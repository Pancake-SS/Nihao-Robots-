"""Fetch the locked Roxaleen data files, never upstream executable code."""
import argparse
import hashlib
import json
from pathlib import Path
import urllib.request

ROOT = Path(__file__).resolve().parents[1]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--fetch', action='store_true', required=True)
    parser.parse_args()
    lock = json.loads((ROOT / 'content/roxaleen.lock.json').read_bytes())
    prefix = f"https://raw.githubusercontent.com/Roxaleen/hsk-annotated-corpus/{lock['commit']}/"
    cache_root = (ROOT / '.content-cache/roxaleen').resolve()
    cache_root.mkdir(parents=True, exist_ok=True)
    for name, record in lock['files'].items():
        path = (ROOT / record['cache']).resolve()
        if not path.is_relative_to(cache_root) or record['url'] != prefix + name:
            raise ValueError('Invalid corpus lock path or URL')
        if path.exists() and hashlib.sha256(path.read_bytes()).hexdigest() == record['sha256']:
            continue
        with urllib.request.urlopen(record['url'], timeout=60) as response:
            data = response.read(record['bytes'] + 1)
        if len(data) != record['bytes'] or hashlib.sha256(data).hexdigest() != record['sha256']:
            raise ValueError(f'Corpus checksum mismatch: {name}')
        temporary = path.with_suffix('.part')
        temporary.write_bytes(data)
        temporary.replace(path)
    print('All pinned corpus files verified.')


if __name__ == '__main__':
    main()
