"""Traceable Tatoeba examples from the user-requested Roxaleen corpus.

Import only sentence/translation pairs whose original IDs can be recovered.
No upstream scripts or models are executed. Pinyin is a local annotation.
"""
import csv
import hashlib
import json
from pathlib import Path

from opencc import OpenCC
from pypinyin import lazy_pinyin, Style

from question_generation import normalized

ROOT = Path(__file__).resolve().parents[1]


class CorpusExamples:
    def __init__(self, root=ROOT):
        lock = json.loads((root / 'content/roxaleen.lock.json').read_bytes())
        paths = {}
        for name, record in lock['files'].items():
            path = root / record['cache']
            if hashlib.sha256(path.read_bytes()).hexdigest() != record['sha256']:
                raise ValueError(f'Corpus checksum mismatch: {name}')
            paths[name] = path
        convert = OpenCC('t2s').convert
        self.pairs = {}
        with paths['data/raw/sentences/tatoeba_cmn_sentence-pairs.tsv'].open(encoding='utf-8-sig', newline='') as source:
            for row in csv.reader(source, delimiter='\t'):
                if len(row) != 4 or not row[0].isdigit() or not row[2].isdigit():
                    continue
                self.pairs.setdefault((convert(row[1]), row[3]), (row[0], row[2], row[1]))
        words = json.loads(paths['export/json/words.json'].read_bytes())
        sentences = json.loads(paths['data/tagged/sentences_tatoeba.json'].read_bytes())
        self.by_word = {}
        self.matched_pairs = 0
        for text, sentence in sentences.items():
            translation = sentence.get('translation', '')
            if (text, translation) not in self.pairs or not sentence.get('tags'):
                continue
            if not 4 <= len(text) <= 100 or not 1 <= len(translation) <= 500:
                continue
            if any(ord(c) < 32 for c in text + translation):
                continue
            self.matched_pairs += 1
            for hanzi, pos in sentence['tags']:
                form = words.get(hanzi, {}).get('forms', {}).get(pos, {})
                for reading in form.get('pinyin', []):
                    key = (hanzi, normalized(reading).replace("'", ''))
                    self.by_word.setdefault(key, {})[text] = sentence

    def examples(self, hanzi, pinyin, existing, limit=5):
        """Append candidates without replacing any existing example or recording."""
        remaining = max(0, limit - len(existing))
        if not remaining:
            return []
        key = (hanzi, normalized(pinyin).replace("'", ''))
        candidates = self.by_word.get(key, {})
        seen = {e['hanzi'] for e in existing}
        selected = []
        for text, record in sorted(candidates.items(), key=lambda item: (item[1].get('level', 99), len(item[0]), item[0])):
            if text in seen or text.count(hanzi) != 1:
                continue
            # Check the reading in context too, rather than accepting every homograph.
            syllables = lazy_pinyin(text, style=Style.TONE, errors=lambda value: list(value))
            if len(syllables) != len(text):
                continue
            start = text.index(hanzi)
            if normalized(''.join(syllables[start:start + len(hanzi)])) != key[1]:
                continue
            chinese_id, english_id, traditional = self.pairs[(text, record['translation'])]
            example = dict(
                hanzi=text, traditional=traditional, pinyin=' '.join(syllables),
                meaning=record['translation'], sourceId=f'tatoeba.{chinese_id}.{english_id}',
                sourceUrl=f'https://tatoeba.org/en/sentences/show/{chinese_id}', grammarTags=[],
                translationSourceUrl=f'https://tatoeba.org/en/sentences/show/{english_id}',
                credit='Tatoeba contributors via Roxaleen/hsk-annotated-corpus; CC BY 2.0 FR.',
                annotation='Pinyin generated with pypinyin 0.55.0; sentence sense and pronunciation await independent review.',
            )
            selected.append(example)
            seen.add(text)
            if len(selected) == remaining:
                break
        return selected
