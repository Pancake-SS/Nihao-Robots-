"""Build the app's relational, offline curriculum from pinned imported records.

No learner data or upstream code is read/executed. Missing examples stay missing.
"""
import hashlib
import json
from pathlib import Path
import sqlite3
import tempfile

from question_generation import Word, Example, QuestionBankGenerator, normalized, semantic_category
from corpus_examples import CorpusExamples
from fmld_dictionary import enrich

ROOT = Path(__file__).resolve().parents[1]

SCHEMA = '''
PRAGMA foreign_keys=ON;
CREATE TABLE curriculum_words(id TEXT PRIMARY KEY, pack_id TEXT NOT NULL, revision INTEGER NOT NULL,
 content_schema INTEGER NOT NULL, hanzi TEXT NOT NULL, pinyin TEXT NOT NULL, meaning TEXT NOT NULL,
 search_text TEXT NOT NULL, default_position INTEGER NOT NULL, metadata_json TEXT NOT NULL);
CREATE TABLE curriculum_sentences(id TEXT PRIMARY KEY, payload_json TEXT NOT NULL);
CREATE TABLE curriculum_examples(word_id TEXT NOT NULL REFERENCES curriculum_words(id),
 sentence_id TEXT NOT NULL REFERENCES curriculum_sentences(id), position INTEGER NOT NULL,
 PRIMARY KEY(word_id,position), UNIQUE(word_id,sentence_id));
CREATE TABLE curriculum_audio(id TEXT PRIMARY KEY, sentence_id TEXT NOT NULL REFERENCES curriculum_sentences(id),
 payload_json TEXT NOT NULL, local_available INTEGER NOT NULL);
CREATE TABLE curriculum_questions(id TEXT PRIMARY KEY, word_id TEXT NOT NULL REFERENCES curriculum_words(id),
 position INTEGER NOT NULL, payload_json TEXT NOT NULL, UNIQUE(word_id,position));
CREATE INDEX curriculum_question_word ON curriculum_questions(word_id,position);
CREATE INDEX curriculum_audio_sentence ON curriculum_audio(sentence_id);
'''


def encode(v):
    return json.dumps(v, ensure_ascii=False, separators=(',', ':'))


def build(destination=ROOT/'assets/content/curriculum.sqlite'):
    corpus = CorpusExamples()
    library = json.loads((ROOT/'assets/content/dictionary_v1.json').read_bytes())
    raw_sentences = json.loads((ROOT/'.content-cache/sentences.json').read_bytes())
    lock = json.loads((ROOT/'content/sources.lock.json').read_bytes())
    assert hashlib.sha256((ROOT/'.content-cache/sentences.json').read_bytes()).hexdigest() == lock['sentences']['sha256']
    audio = json.loads((ROOT/'content/audio.lock.json').read_bytes())
    extended_audio = ROOT/'content/curriculum_audio.lock.json'
    if extended_audio.exists():
        for sid, record in json.loads(extended_audio.read_bytes()).items():
            assert record['asset'] == f'assets/audio/{sid}.mp3'
            assert hashlib.sha256((ROOT/record['asset']).read_bytes()).hexdigest()==record['sha256']
            audio[sid] = record
    prepared = {}
    for file in ('starter_greeting_v2.json', 'starter_imported_v1.json'):
        pack = json.loads((ROOT/'assets/content'/file).read_bytes())
        for w in pack['words']:
            prepared[(normalized(w['hanzi']), normalized(w['pinyin']))] = (w, pack)
    candidates = {}
    for s in raw_sentences:
        for token in s['tokens']:
            key = (normalized(token['word']), normalized(token['pinyin']))
            candidates.setdefault(key, {})[s['id']] = s
    rows = sorted(library['words'], key=lambda w: (w['learningPriority']['tier'],
        w['band'] if w['band'] is not None else 99, w['learningPriority']['order'], w['id']))
    pool = [Word(w['id'], w['hanzi'], w['pinyin'], w['meaning'], w['band'] or 7, w['partOfSpeech']) for w in rows]
    # Bounded deterministic pools avoid sorting 11k candidates for every pattern.
    pools = {}
    for target in pool:
        category = semantic_category(target.meaning)
        key = (target.band, target.part_of_speech, category)
        if key not in pools:
            eligible = [w for w in pool if w.band <= target.band]
            eligible.sort(key=lambda w: (semantic_category(w.meaning) != category if category else False,
                w.part_of_speech != target.part_of_speech,
                hashlib.sha256(w.id.encode()).hexdigest()))
            pools[key] = QuestionBankGenerator(eligible[:128])
    destination.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile(dir=destination.parent, suffix='.sqlite', delete=False) as f:
        temporary = Path(f.name)
    db = sqlite3.connect(temporary)
    try:
        db.executescript(SCHEMA)
        counts = dict(words=0, questions=0, withExamples=0, withFiveExamples=0, withBundledAudio=0)
        with db:
            for position, row in enumerate(rows):
                key = (normalized(row['hanzi']), normalized(row['pinyin']))
                if key in prepared:
                    word, pack = prepared[key]
                    word = json.loads(encode(word))
                else:
                    examples = []
                    for s in sorted(candidates.get(key, {}).values(), key=lambda s: (s['hsk_level'], len(s['chinese']), s['id'])):
                        if any(e['hanzi'] == s['chinese'] for e in examples):
                            continue
                        example = dict(hanzi=s['chinese'], traditional=s['traditional'], pinyin=s['pinyin'],
                            meaning=s['translation']['en'], sourceId=s['id'], sourceUrl=lock['sentences']['url'],
                            grammarTags=s.get('grammar_tags', []))
                        if s['id'] in audio: example['audio'] = audio[s['id']]
                        examples.append(example)
                        if len(examples) == 5: break
                    examples.extend(corpus.examples(row['hanzi'], row['pinyin'], examples))
                    details = dict(traditional=row['traditional'], pinyinNumbered=row['pinyinNumbered'],
                        partOfSpeech=row['partOfSpeech'], band=row['band'] or 0, sourceId=row['id'].split('.')[1],
                        sourceVersion=library['source']['version'], sourceUrl=library['source']['url'],
                        licenseUrl=library['source']['licenseUrl'], learningPriority=row['learningPriority'])
                    word = dict(id=row['id'], hanzi=row['hanzi'], pinyin=row['pinyin'], meaning=row['meaning'],
                        details=details, examples=examples, audio=None, reviewStatus='source-imported',
                        reviewedBy='Automated source import; independent language review pending', reviewedOn='2026-11-07',
                        source='HearMandarin word data. Examples: no7z/hsk-sentences-audio, supplemented by traceable Tatoeba pairs from Roxaleen/hsk-annotated-corpus. Pinyin on supplemental examples is locally annotated; independent language review pending.',
                        license='HearMandarin: CC BY 4.0. no7z examples/recordings and question adaptations: CC BY-SA 4.0. Supplemental Tatoeba sentences/translations: CC BY 2.0 FR. See per-example credits and bundled ATTRIBUTION.txt.')
                    target = Word.from_lesson(word)
                    # Unranked words remain visibly unranked; band 7 is only a pool bound.
                    generator = pools[(row['band'] or 7, row['partOfSpeech'], semantic_category(row['meaning']))]
                    if target.band == 0:
                        target = Word(target.id,target.hanzi,target.pinyin,target.meaning,7,target.part_of_speech,target.examples)
                    word['questions'] = generator.generate(target)
                    pack = dict(id='curriculum.imported', revision=2, schemaVersion=4)
                examples, questions = word.pop('examples'), word.pop('questions')
                search = ' '.join((row['hanzi'],row['traditional'],row['pinyin'],row['pinyinNumbered'],row['meaning'],
                    ''.join(c for c in row['pinyinNumbered'] if c not in '12345 '))).lower()
                db.execute('INSERT INTO curriculum_words VALUES(?,?,?,?,?,?,?,?,?,?)',
                    (word['id'],pack['id'],pack['revision'],pack['schemaVersion'],word['hanzi'],word['pinyin'],word['meaning'],search,position,encode(word)))
                for i, example in enumerate(examples):
                    clip = example.pop('audio', None)
                    # Distinct editorial corrections of the same source sentence get distinct records.
                    sid = 'example.'+hashlib.sha256(encode(example).encode()).hexdigest()[:24]
                    db.execute('INSERT OR IGNORE INTO curriculum_sentences VALUES(?,?)',(sid,encode(example)))
                    db.execute('INSERT INTO curriculum_examples VALUES(?,?,?)',(word['id'],sid,i))
                    if clip:
                        db.execute('INSERT OR IGNORE INTO curriculum_audio VALUES(?,?,?,1)',(sid+'.normal',sid,encode(clip)))
                    else:
                        source = next((s for s in candidates.get(key, {}).values() if s['id']==example['sourceId']),None)
                        if source:
                            for speed, relative in source.get('audio',{}).items():
                                db.execute('INSERT OR IGNORE INTO curriculum_audio VALUES(?,?,?,0)',
                                    (sid+'.'+speed,sid,encode(dict(url=lock['sentences']['url'].rsplit('/',1)[0]+'/'+relative,
                                    speed=speed,license='CC BY-SA 4.0',sourceId=source['id']))))
                for i, q in enumerate(questions):
                    db.execute('INSERT INTO curriculum_questions VALUES(?,?,?,?)',(q['id'],word['id'],i,encode(q)))
                counts['words'] += 1
                counts['questions'] += len(questions)
                counts['withExamples'] += bool(examples)
                counts['withFiveExamples'] += len(examples)==5
                counts['withBundledAudio'] += any(e['sourceId'] in audio for e in examples)
        with db:
            counts.update(enrich(db))
        db.execute('VACUUM')
        assert not db.execute('PRAGMA foreign_key_check').fetchall()
        assert db.execute('PRAGMA integrity_check').fetchone()[0] == 'ok'
        assert counts['words'] == 11147
        assert not db.execute('SELECT w.id FROM curriculum_words w LEFT JOIN curriculum_questions q ON q.word_id=w.id GROUP BY w.id HAVING count(q.id)<7').fetchall()
        db.close()
        temporary.replace(destination)
        manifest = dict(revision=5, sha256=hashlib.sha256(destination.read_bytes()).hexdigest(), counts=counts)
        destination.with_suffix('.manifest.json').write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8')
        return manifest
    finally:
        db.close()
        temporary.unlink(missing_ok=True)


if __name__ == '__main__':
    print(json.dumps(build(),indent=2))
