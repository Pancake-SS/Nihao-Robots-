"""Pinned, offline-reproducible content staging and starter-pack publication.

Only --fetch uses the network, for pinned data and selected audio recordings.
No upstream scripts are executed.
Raw data and the generated staging SQLite database stay in .content-cache/.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import re
import sqlite3
import tempfile
import urllib.request

from question_generation import QuestionBankGenerator, Word, Example, normalized
from learning_priority import priority_for

ROOT = Path(__file__).resolve().parents[1]
CACHE = ROOT / '.content-cache'
MAX_BYTES = 35_000_000


def encode(value):
    return json.dumps(value, ensure_ascii=False, indent=2) + '\n'


def text(value, limit=2000):
    if (not isinstance(value, str) or not value.strip() or len(value) > limit
            or re.search(r'[\x00-\x1f\x7f-\x9f\u200b\u202a-\u202e\u2066-\u2069\ufeff]', value)):
        raise ValueError('Invalid content text')
    return value.strip()


def identity(value):
    value = text(value, 100)
    if not re.fullmatch(r'[a-z0-9]+(?:[._-][a-z0-9]+)*', value):
        raise ValueError('Invalid source identity')
    return value


def read_source(name, lock, cache=CACHE, fetch=False):
    filename = lock.get('cacheFile', f'{name}.json')
    if Path(filename).name != filename or '/' in filename or '\\' in filename:
        raise ValueError('Unsafe cache filename')
    path = cache / filename
    if fetch:
        url = lock['url']
        if not url.startswith(('https://hearmandarin.com/datasets/',
                               'https://raw.githubusercontent.com/no7z/hsk-sentences-audio/',
                               'https://raw.githubusercontent.com/saymei/zhongdex/')):
            raise ValueError('Source URL is outside the download allowlist')
        request = urllib.request.Request(url, headers={'User-Agent': 'NiHaoRobot-content-import'})
        with urllib.request.urlopen(request, timeout=60) as response:
            if not response.url.startswith('https://'):
                raise ValueError('Insecure source redirect')
            data = response.read(MAX_BYTES + 1)
        if len(data) > MAX_BYTES or hashlib.sha256(data).hexdigest() != lock['sha256']:
            raise ValueError(f'{name}: source changed; review and update the lock explicitly')
        cache.mkdir(parents=True, exist_ok=True)
        path.write_bytes(data)
    if path.stat().st_size > MAX_BYTES:
        raise ValueError(f'{name}: cached source exceeds size limit')
    data = path.read_bytes()
    if len(data) > MAX_BYTES or hashlib.sha256(data).hexdigest() != lock['sha256']:
        raise ValueError(f'{name}: cached source checksum mismatch')
    return [json.loads(line) for line in data.splitlines() if line.strip()] if lock.get('format') == 'jsonl' else json.loads(data)


def validate_sources(words, sentences):
    if words.get('license') != 'CC BY 4.0' or not isinstance(words.get('words'), list):
        raise ValueError('Unexpected word dataset contract/license')
    if len(words['words']) > 20000 or not isinstance(sentences, list) or len(sentences) > 10000:
        raise ValueError('Unexpected source size')
    for rows, fields in [(words['words'], ('simplified', 'traditional', 'pinyin', 'pinyin_num', 'gloss_en')),
                         (sentences, ('chinese', 'traditional', 'pinyin'))]:
        ids = set()
        for row in rows:
            key = identity(row['id'])
            if key in ids:
                raise ValueError('Duplicate source ID')
            ids.add(key)
            for field in fields:
                text(row[field])
    for row in sentences:
        text(row['translation']['en'])
        if type(row['hsk_level']) is not int or row['hsk_level'] not in range(1, 7):
            raise ValueError('Invalid sentence level')
        if not isinstance(row['tokens'], list) or len(row['tokens']) > 300:
            raise ValueError('Invalid segmentation')
        for token in row['tokens']:
            text(token['word'], 100)
            text(token['pinyin'], 300)
        for tag in row.get('grammar_tags', []):
            text(tag, 100)


def questions(word, pool):
    return QuestionBankGenerator(Word.from_lesson(w) for w in pool).generate(Word.from_lesson(word))


def publish(words, sentences, selection, lock, audio=None):
    source_words = {w['id']: w for w in words['words']}
    source_sentences = {s['id']: s for s in sentences}
    entries = []
    for wid, sentence_ids in selection['words'].items():
        w = source_words[wid]
        if len(sentence_ids) != 5 or len(set(sentence_ids)) != 5:
            raise ValueError('Exactly five distinct selected examples required')
        examples = []
        for sid in sentence_ids:
            s = source_sentences[sid]
            if s['hsk_level'] != 1 or not any(t['word'] == w['simplified'] for t in s['tokens']):
                raise ValueError('Selected example does not contain the segmented target')
            examples.append(dict(hanzi=s['chinese'], traditional=s['traditional'],
                                 pinyin=selection['sentencePinyinOverrides'].get(sid, s['pinyin']),
                                 meaning=s['translation']['en'], sourceId=sid,
                                 sourceUrl=lock['sentences']['url'], grammarTags=s.get('grammar_tags', [])))
            if audio and sid in audio:
                examples[-1]['audio'] = audio[sid]
        entries.append(dict(
            id=f'hearmandarin.{wid}.1', hanzi=w['simplified'], pinyin=w['pinyin'], meaning=w['gloss_en'],
            examples=examples,
            details=dict(traditional=w['traditional'], pinyinNumbered=w['pinyin_num'],
                         partOfSpeech=w['pos_en'] or w['pos_zh'] or 'unspecified', band=w['hsk3_band'],
                         learningPriority=priority_for(w['simplified'], w['hsk3_band'], w['hsk3_seq']).to_record(),
                         sourceId=wid, sourceVersion=lock['words']['version'],
                         sourceUrl=lock['words']['url'], licenseUrl=lock['words']['licenseUrl']),
            source=f'{lock["words"]["attribution"]}; words: {lock["words"]["url"]}. '
                   f'Examples: {lock["sentences"]["attribution"]}; revision {lock["sentences"]["version"]}. '
                   'Selected and adapted by Ni Hao Robot!; Pinyin corrections and exact source IDs are recorded in docs/CONTENT_DATABASE.md.',
            license='Adapted lesson/question pack: CC BY-SA 4.0, https://creativecommons.org/licenses/by-sa/4.0/. '
                    'Original word data: CC BY 4.0, https://creativecommons.org/licenses/by/4.0/. '
                    'Sentence data and recordings: CC BY-SA 4.0. Audio is synthetic (CosyVoice2); attribution retained.',
            reviewedBy=selection['reviewedBy'], reviewedOn=selection['reviewedOn'],
            reviewStatus='source-checked-pilot', audio=None))
    generator = QuestionBankGenerator(Word.from_lesson(w) for w in entries)
    for word in entries:
        word['questions'] = generator.generate(Word.from_lesson(word))
    return dict(schemaVersion=3, id='starter.imported', revision=2, words=entries)


SCHEMA = '''
PRAGMA foreign_keys=ON;
CREATE TABLE sources(id TEXT PRIMARY KEY, version TEXT NOT NULL, url TEXT NOT NULL,
 license TEXT NOT NULL, attribution TEXT NOT NULL, sha256 TEXT NOT NULL);
CREATE TABLE words(id TEXT PRIMARY KEY, source_id TEXT NOT NULL REFERENCES sources(id),
 original_id TEXT NOT NULL, simplified TEXT NOT NULL, traditional TEXT NOT NULL,
 pinyin TEXT NOT NULL, pinyin_numbered TEXT NOT NULL, band INTEGER, sequence INTEGER,
 pos TEXT NOT NULL, raw_json TEXT NOT NULL, UNIQUE(source_id, original_id));
CREATE TABLE word_senses(id TEXT PRIMARY KEY, word_id TEXT NOT NULL REFERENCES words(id),
 meaning TEXT NOT NULL, review_status TEXT NOT NULL CHECK(review_status IN ('staged','source-checked-pilot')));
CREATE TABLE word_priorities(word_id TEXT PRIMARY KEY REFERENCES words(id),
 tier INTEGER NOT NULL CHECK(tier BETWEEN 0 AND 4), rank INTEGER NOT NULL, basis TEXT NOT NULL);
CREATE TABLE sentences(id TEXT PRIMARY KEY, source_id TEXT NOT NULL REFERENCES sources(id),
 original_id TEXT NOT NULL, chinese TEXT NOT NULL, traditional TEXT NOT NULL,
 pinyin TEXT NOT NULL, translation TEXT NOT NULL, level INTEGER NOT NULL,
 topic TEXT NOT NULL, raw_json TEXT NOT NULL, UNIQUE(source_id,original_id));
CREATE TABLE sentence_tokens(sentence_id TEXT NOT NULL REFERENCES sentences(id), position INTEGER NOT NULL,
 word TEXT NOT NULL, pinyin TEXT NOT NULL, PRIMARY KEY(sentence_id,position));
CREATE TABLE sentence_grammar_tags(sentence_id TEXT NOT NULL REFERENCES sentences(id),
 tag TEXT NOT NULL, PRIMARY KEY(sentence_id,tag));
CREATE TABLE word_sentence_links(sense_id TEXT NOT NULL REFERENCES word_senses(id),
 sentence_id TEXT NOT NULL REFERENCES sentences(id),
 link_status TEXT NOT NULL CHECK(link_status IN ('candidate','selected')),
 PRIMARY KEY(sense_id,sentence_id));
CREATE TABLE exercises(id TEXT PRIMARY KEY, sense_id TEXT NOT NULL REFERENCES word_senses(id),
 kind TEXT NOT NULL, prompt TEXT NOT NULL, correct_option_id TEXT NOT NULL, explanation TEXT NOT NULL);
CREATE TABLE exercise_options(exercise_id TEXT NOT NULL REFERENCES exercises(id), id TEXT NOT NULL,
 position INTEGER NOT NULL, label TEXT NOT NULL, PRIMARY KEY(exercise_id,id), UNIQUE(exercise_id,position));
CREATE TABLE draft_exercises(id TEXT PRIMARY KEY, sense_id TEXT NOT NULL REFERENCES word_senses(id),
 kind TEXT NOT NULL, payload_json TEXT NOT NULL, status TEXT NOT NULL DEFAULT 'draft');
CREATE TABLE external_words(id TEXT PRIMARY KEY, source_id TEXT NOT NULL REFERENCES sources(id),
 hanzi TEXT NOT NULL, pinyin TEXT NOT NULL, raw_json TEXT NOT NULL, status TEXT NOT NULL DEFAULT 'quarantined');
CREATE TABLE external_sentences(id TEXT PRIMARY KEY, source_id TEXT NOT NULL REFERENCES sources(id),
 hanzi TEXT NOT NULL, pinyin TEXT NOT NULL, translation TEXT NOT NULL, raw_json TEXT NOT NULL,
 status TEXT NOT NULL DEFAULT 'quarantined');
CREATE TABLE word_crosswalk(word_id TEXT NOT NULL REFERENCES words(id), external_id TEXT NOT NULL REFERENCES external_words(id),
 match_method TEXT NOT NULL, PRIMARY KEY(word_id,external_id));
CREATE TABLE audio_assets(id TEXT PRIMARY KEY, sentence_id TEXT NOT NULL REFERENCES sentences(id),
 speed TEXT NOT NULL, url TEXT NOT NULL, license TEXT NOT NULL, voice TEXT NOT NULL,
 synthetic INTEGER NOT NULL, local_path TEXT, sha256 TEXT, status TEXT NOT NULL);
'''


def stage(path, words, sentences, pack, lock, external=None, audio=None):
    """Build separately and replace only after complete integrity validation."""
    path.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile(dir=path.parent, suffix='.sqlite', delete=False) as tmp:
        temporary = Path(tmp.name)
    db = sqlite3.connect(temporary)
    try:
        db.executescript(SCHEMA)
        with db:
            for sid, source in lock.items():
                db.execute('INSERT INTO sources VALUES(?,?,?,?,?,?)',
                           (sid, source['version'], source['url'], source['license'], source['attribution'], source['sha256']))
            by_hanzi = {}
            selected = {w['id']: w for w in pack['words']}
            for w in words['words']:
                wid = f'hearmandarin.{w["id"]}'
                sense = wid + '.1'
                by_hanzi.setdefault(w['simplified'], []).append(sense)
                db.execute('INSERT INTO words VALUES(?,?,?,?,?,?,?,?,?,?,?)',
                           (wid, 'words', w['id'], w['simplified'], w['traditional'], w['pinyin'], w['pinyin_num'],
                            w['hsk3_band'], w['hsk3_seq'], w['pos_en'], encode(w)))
                db.execute('INSERT INTO word_senses VALUES(?,?,?,?)',
                           (sense, wid, w['gloss_en'], 'source-checked-pilot' if sense in selected else 'staged'))
                priority = priority_for(w['simplified'], w['hsk3_band'], w['hsk3_seq'])
                db.execute('INSERT INTO word_priorities VALUES(?,?,?,?)',
                           (wid, priority.tier, priority.order, priority.basis))
            for s in sentences:
                sid = 'hsk-sentences.' + s['id']
                db.execute('INSERT INTO sentences VALUES(?,?,?,?,?,?,?,?,?,?)',
                           (sid, 'sentences', s['id'], s['chinese'], s['traditional'], s['pinyin'],
                            s['translation']['en'], s['hsk_level'], s['topic'], encode(s)))
                for i, t in enumerate(s['tokens']):
                    db.execute('INSERT INTO sentence_tokens VALUES(?,?,?,?)', (sid, i, t['word'], t['pinyin']))
                    for sense in by_hanzi.get(t['word'], []):
                        reviewed = sense in selected and any(e['sourceId'] == s['id'] for e in selected[sense]['examples'])
                        db.execute('INSERT OR IGNORE INTO word_sentence_links VALUES(?,?,?)',
                                   (sense, sid, 'selected' if reviewed else 'candidate'))
                for tag in set(s.get('grammar_tags', [])):
                    db.execute('INSERT INTO sentence_grammar_tags VALUES(?,?)', (sid, tag))
            for w in pack['words']:
                for q in w['questions']:
                    db.execute('INSERT INTO exercises VALUES(?,?,?,?,?,?)',
                               (q['id'], w['id'], q['kind'], q['prompt'], q['correctOptionId'], q['explanation']))
                    for i, o in enumerate(q['options']):
                        db.execute('INSERT INTO exercise_options VALUES(?,?,?,?)', (q['id'], o['id'], i, o['text']))
            # Bulk generation remains draft until explicit curriculum selection/review.
            examples_by_word = {}
            for s in sentences:
                if s['hsk_level'] != 1:
                    continue
                for token in s['tokens']:
                    examples_by_word.setdefault(token['word'], []).append(Example(s['chinese'], s['translation']['en'], s['id']))
            draft_words = [Word(f'hearmandarin.{w["id"]}.1', w['simplified'], w['pinyin'], w['gloss_en'],
                                w['hsk3_band'], w['pos_en'], tuple(examples_by_word.get(w['simplified'], [])[:5]))
                           for w in words['words'] if w['hsk3_band'] == 1]
            bank, skipped = QuestionBankGenerator(draft_words).generate_many(draft_words)
            for sid, questions in bank.items():
                for q in questions:
                    db.execute('INSERT INTO draft_exercises(id,sense_id,kind,payload_json) VALUES(?,?,?,?)',
                               (q['id'], sid, q['kind'], encode(q)))
            for s in sentences:
                for speed, relative in s.get('audio', {}).items():
                    if speed not in ('normal', 'slow') or not re.fullmatch(r'audio/hsk[1-6]-[0-9]{4}(?:_slow)?\.mp3', relative):
                        raise ValueError('Invalid source audio path')
                    local = (audio or {}).get(s['id']) if speed == 'normal' else None
                    url = lock['sentences']['url'].rsplit('/', 1)[0] + '/' + relative
                    db.execute('INSERT INTO audio_assets VALUES(?,?,?,?,?,?,?,?,?,?)',
                               (s['id']+'.'+speed, 'hsk-sentences.'+s['id'], speed, url, 'CC BY-SA 4.0',
                                s.get('audio_meta', {}).get('voice', 'unspecified'), 1,
                                local['asset'] if local else None, local['sha256'] if local else None,
                                'bundled' if local else 'reference-only'))
            if external:
                by_reading = {}
                for w in words['words']:
                    by_reading.setdefault((w['simplified'], normalized(w['pinyin'])), []).append('hearmandarin.'+w['id'])
                for w in external['words']:
                    key = text(w['id'], 300)
                    hanzi, pinyin = text(w['simplified']), text(w['pinyin']['marked'])
                    db.execute('INSERT INTO external_words(id,source_id,hanzi,pinyin,raw_json) VALUES(?,?,?,?,?)',
                               (key, 'zhongdex_words', hanzi, pinyin, encode(w)))
                    for wid in by_reading.get((hanzi, normalized(pinyin)), []):
                        db.execute('INSERT INTO word_crosswalk VALUES(?,?,?)', (wid,key,'exact-hanzi-and-reading-candidate'))
                for s in external['sentences']:
                    db.execute('INSERT INTO external_sentences(id,source_id,hanzi,pinyin,translation,raw_json) VALUES(?,?,?,?,?,?)',
                               (text(s['id'],300), 'zhongdex_sentences', text(s['hanzi']),text(s['pinyin']),text(s['english']),encode(s)))
        if db.execute('PRAGMA integrity_check').fetchone()[0] != 'ok' or db.execute('PRAGMA foreign_key_check').fetchall():
            raise ValueError('Staging integrity failed')
        counts = {table: db.execute(f'SELECT count(*) FROM {table}').fetchone()[0]
                  for table in ('words', 'word_senses', 'sentences', 'word_sentence_links', 'exercises',
                                'draft_exercises', 'external_words', 'external_sentences', 'word_crosswalk', 'audio_assets')}
        counts['draft_words_skipped'] = len(skipped)
        db.close()
        temporary.replace(path)
        return counts
    finally:
        db.close()
        temporary.unlink(missing_ok=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--fetch', action='store_true', help='Fetch checksum-pinned data and missing selected audio')
    args = parser.parse_args()
    lock = json.loads((ROOT / 'content/sources.lock.json').read_text(encoding='utf-8'))
    selection = json.loads((ROOT / 'content/starter_selection.json').read_text(encoding='utf-8'))
    words = read_source('words', lock['words'], fetch=args.fetch)
    sentences = read_source('sentences', lock['sentences'], fetch=args.fetch)
    external = {'words': read_source('zhongdex_words', lock['zhongdex_words'], fetch=args.fetch),
                'sentences': read_source('zhongdex_sentences', lock['zhongdex_sentences'], fetch=args.fetch)}
    audio = json.loads((ROOT / 'content/audio.lock.json').read_bytes())
    for record in audio.values():
        if not re.fullmatch(r'assets/audio/hsk[1-6]-[0-9]{4}\.mp3', record['asset']):
            raise ValueError('Unsafe audio asset path')
        file = ROOT / record['asset']
        if args.fetch and not file.exists():
            if not record['url'].startswith(lock['sentences']['url'].rsplit('/',1)[0]+'/audio/'):
                raise ValueError('Audio URL outside pinned source')
            data = urllib.request.urlopen(record['url'],timeout=60).read(2_000_001)
            if len(data) > 2_000_000 or hashlib.sha256(data).hexdigest() != record['sha256']:
                raise ValueError('Audio download checksum mismatch')
            file.parent.mkdir(parents=True,exist_ok=True)
            file.write_bytes(data)
        if hashlib.sha256(file.read_bytes()).hexdigest() != record['sha256']:
            raise ValueError('Audio checksum mismatch')
    validate_sources(words, sentences)
    pack = publish(words, sentences, selection, lock, audio)
    counts = stage(CACHE / 'content_staging.sqlite', words, sentences, pack, lock, external, audio)
    output = ROOT / 'assets/content/starter_imported_v1.json'
    output.write_text(encode(pack), encoding='utf-8')
    library = dict(schemaVersion=1, revision=1, source=lock['words'], words=[
        dict(id=f'hearmandarin.{w["id"]}.1', hanzi=w['simplified'], traditional=w['traditional'],
             pinyin=w['pinyin'], pinyinNumbered=w['pinyin_num'], meaning=w['gloss_en'],
             band=w['hsk3_band'], partOfSpeech=w['pos_en'] or w['pos_zh'] or 'unspecified',
             learningPriority=priority_for(w['simplified'], w['hsk3_band'], w['hsk3_seq']).to_record())
        for w in words['words']])
    (ROOT / 'assets/content/dictionary_v1.json').write_text(encode(library), encoding='utf-8')
    # Preserve the existing greeting's sense ID, upgrading only its content revision.
    pilot = json.loads((ROOT / 'assets/content/starter_greeting_v1.json').read_text(encoding='utf-8'))
    pilot['schemaVersion'], pilot['revision'] = 3, 3
    greeting = pilot['words'][0]
    greeting['meaning'] = 'hello (greeting one person)'
    greeting['reviewedOn'] = '2026-11-06'
    greeting['details'] = dict(traditional='你好', pinyinNumbered='ni3 hao3', partOfSpeech='greeting', band=0,
                               learningPriority=priority_for('你好', 0, 0).to_record(),
                               sourceId='nihao-greeting', sourceVersion='3',
                               sourceUrl='https://www.open.edu/openlearn/languages/beginners-chinese-taster-course/content-section-4',
                               licenseUrl='https://creativecommons.org/licenses/by-sa/4.0/')
    for i, example in enumerate(greeting['examples']):
        example.update(traditional=example['hanzi'].replace('兴', '興').replace('认', '認').replace('识', '識').replace('请', '請').replace('进', '進'),
                       sourceId=f'nihao-original-{i + 1}', sourceUrl=greeting['details']['sourceUrl'], grammarTags=[])
    greeting['source'] += ' Question distractors adapted from HearMandarin (https://hearmandarin.com/datasets/).'
    greeting['license'] = 'Revision 3 lesson/question adaptation: CC BY-SA 4.0, https://creativecommons.org/licenses/by-sa/4.0/. HearMandarin word distractors: CC BY 4.0. No audio imported.'
    greeting['questions'] = questions(greeting, pack['words'])
    (ROOT / 'assets/content/starter_greeting_v2.json').write_text(encode(pilot), encoding='utf-8')
    print(encode({'staging': counts, 'publishedWords': len(pack['words']), 'pack': str(output)}))


if __name__ == '__main__':
    main()
