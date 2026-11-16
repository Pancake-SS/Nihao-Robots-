"""Build the small offline grammar pack from the supplied HSK syllabus.

The ASG crosswalk is intentionally curated: broad HSK points are only linked to
articles about the same construction. Unmatched points keep their HSK lesson.
"""

from __future__ import annotations

import argparse
import csv
import hashlib
import html
import json
import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "reference" / "hsk-3.0-complete.json"
OUTPUT = ROOT / "assets" / "content" / "grammar_v1.json"

# HSK point -> AllSet article ID. Each pair was checked by topic, not fuzzy text.
ASG = {
    '前缀“第-”': 'ASGK904U',
    '离合词（睡觉、说话、上课……）': 'ASG4GVRX',
    '疑问代词（什么、谁、哪儿、几、多少……）': 'ASGJQPSC',
    '名量词（本、个、家、口、块、件、只、元；杯）': 'ASG64BTE',
    '范围副词“都”': 'ASG9YK09',
    '时间副词“在、正在”': 'ASG846EA',
    '否定副词“不”': 'ASGIPYFV',
    '否定副词“没（有）”': 'ASGAUCXK',
    '介词“在”（引出时间、处所）': 'ASGX0Z0N',
    '结构助词“的”': 'ASGUHQD2',
    '动态助词“了”': 'ASGAGDCQ',
    '语气助词“吗”': 'ASGQ2AZA',
    '语气助词“了”（变化）': 'ASGT185D',
    '主谓句1：动词谓语句': 'ASGETNCO',
    '主谓句2：形容词谓语句': 'ASG17BLH',
    '正反问句': 'ASGZH7K3',
    '“有”字句1（领有）': 'ASGOOCVO',
    '存现句1': 'ASG04ZCI',
    '时间表示法': 'ASGN6BBU',
}


def plain(value: str) -> str:
    value = re.sub(r'\[https?://[^ ]+ ([^]]+)\]', r'\1', value)
    value = re.sub(r'\[\[([^]|]+)\|([^]]+)\]\]', r'\2', value)
    value = re.sub(r'\[\[([^]]+)\]\]', r'\1', value)
    value = re.sub(r'\{\{[^{}]*\}\}', '', value)
    value = re.sub(r'<[^>]+>', '', value)
    value = html.unescape(value).replace("''", '')
    value = re.sub(r'\s+', ' ', value).strip(' *:;\t\r\n')
    return value


def asg_details(wiki: Path, article_id: str, titles: dict[str, str]) -> dict:
    raw = (wiki / f'{article_id}.txt').read_text(encoding='utf-8')
    title = titles[article_id]
    # The opening prose is a useful short teaching note; avoid copying whole articles.
    before_heading = re.split(r'^==', raw, maxsplit=1, flags=re.M)[0]
    paragraphs = [plain(p) for p in re.split(r'\n\s*\n', before_heading)]
    note = next((p for p in paragraphs if 30 <= len(p) <= 650 and
                 not p.startswith('<!--')), '')
    note = note[:420].rsplit(' ', 1)[0] if len(note) > 420 else note
    examples = []
    for line in raw.splitlines():
        if not line.lstrip().startswith('*') or 'class="pinyin"' not in line:
            continue
        if 'class="x"' in line or 'class="trans"' not in line:
            continue
        pin = re.search(r'<span class="pinyin">(.*?)</span>', line)
        eng = re.search(r'<span class="trans">(.*?)</span>', line)
        if not pin or not eng:
            continue
        chinese = plain(line.split('<span', 1)[0])
        pinyin, english = plain(pin.group(1)), plain(eng.group(1))
        chinese = re.sub(r'(?<=[\u3400-\u9fff])\s+(?=[\u3400-\u9fff])', '', chinese)
        if (re.search(r'[\u3400-\u9fff]', chinese) and
                re.search(r'[A-Za-z]', pinyin) and len(english) > 3 and
                len(chinese) <= 150 and len(english) <= 250 and
                chinese not in {e['chinese'] for e in examples}):
            examples.append({'chinese': chinese, 'pinyin': pinyin,
                             'english': english, 'source': 'allset'})
        if len(examples) == 2:
            break
    return {'id': article_id, 'title': title, 'note': note,
            'url': f'https://resources.allsetlearning.com/chinese/grammar/{article_id}',
            'examples': examples}


def build(source: Path, wiki: Path, output: Path) -> dict:
    original = source.read_bytes()
    data = json.loads(original)
    points = data['grammar']
    if len(points) != 428 or len({p['point'] for p in points}) != 428:
        raise ValueError('Expected 428 distinct grammar points')
    with (wiki / 'index.tsv').open(encoding='utf-8', newline='') as handle:
        titles = {row['ID']: row['Title'] for row in csv.DictReader(handle, delimiter='\t')}
    if not set(ASG).issubset({p['point'] for p in points}):
        raise ValueError('ASG crosswalk contains an unknown HSK point')
    if not set(ASG.values()).issubset(titles):
        raise ValueError('ASG crosswalk contains an unknown article')

    first = [
        '主谓句1：动词谓语句', '“是”字句1（等同或类属）',
        '“有”字句1（领有）', '否定副词“不”', '否定副词“没（有）”',
        '语气助词“吗”', '疑问代词（什么、谁、哪儿、几、多少……）',
        '正反问句', '结构助词“的”',
        '名量词（本、个、家、口、块、件、只、元；杯）',
        '主谓句2：形容词谓语句', '时间表示法',
    ]
    rank = {point: i for i, point in enumerate(first)}
    ordered = sorted(enumerate(points), key=lambda item: (
        0 if item[1]['point'] in rank else 1,
        rank.get(item[1]['point'], 0), item[1]['level'], item[0]))
    lessons = []
    for position, (_, point) in enumerate(ordered):
        for field in ('point', 'categoryEnglish', 'explanation',
                      'exampleChinese', 'exampleEnglish'):
            if not isinstance(point.get(field), str) or not point[field].strip():
                raise ValueError(f'Missing {field} for {point.get("point")}')
        if not 1 <= point['level'] <= 9:
            raise ValueError('Invalid HSK level')
        article = asg_details(wiki, ASG[point['point']], titles) if point['point'] in ASG else None
        key = hashlib.sha256(point['point'].encode('utf-8')).hexdigest()[:16]
        examples = [{'chinese': point['exampleChinese'], 'pinyin': '',
                     'english': point['exampleEnglish'], 'source': 'gushi'}]
        if article:
            examples.extend(e for e in article.pop('examples')
                            if e['chinese'] != point['exampleChinese'])
        lessons.append({
            'id': f'hsk3.grammar.{key}', 'position': position,
            'level': point['level'], 'title': point['point'],
            'category': point['categoryEnglish'], 'pattern': point.get('pattern', ''),
            'explanation': point['explanation'], 'examples': examples,
            'allset': article,
        })
    pack = {
        'revision': 1,
        'sourceSha256': hashlib.sha256(original).hexdigest(),
        'source': data['attribution'],
        'allsetSource': 'AllSet Learning Chinese Grammar Wiki (CC BY-NC-SA 3.0)',
        'lessons': lessons,
    }
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(pack, ensure_ascii=False, indent=2) + '\n',
                      encoding='utf-8')
    return pack


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--source', type=Path, default=SOURCE)
    parser.add_argument('--wiki', type=Path, required=True)
    parser.add_argument('--output', type=Path, default=OUTPUT)
    args = parser.parse_args()
    pack = build(args.source, args.wiki, args.output)
    print(f"Built {len(pack['lessons'])} grammar lessons with "
          f"{sum(bool(p['allset']) for p in pack['lessons'])} AllSet guides and "
          f"{sum(len(p['examples']) for p in pack['lessons'])} examples")
