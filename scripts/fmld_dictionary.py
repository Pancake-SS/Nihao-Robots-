"""Pinned FMLD text -> pronunciation-matched teaching records.

Only dictionary definitions, usage notes and selected references are imported.
Editorial comments and example sentences (including AI-authored examples) are
not imported. Existing lesson examples, recordings and quiz answers stay intact.
"""
from dataclasses import dataclass, field
import hashlib
import json
from pathlib import Path
import re
import shutil
import sqlite3
import tempfile
import uuid

ROOT = Path(__file__).resolve().parents[1]
RELATIONS = {'C': 'Measure words', '=': 'Similar words', '!': 'Opposites',
             '?': 'Compare', '{': 'Often before', '}': 'Often after'}


def reading(value):
    return re.sub(r"[\s'’·-]", '', value.lower().replace('ü', 'v').replace('u:', 'v'))


def simplified(value):
    return value.split('／')[-1]


def clean(value):
    value = re.sub(r'#D\d+', '', value)
    value = re.sub(r'[\w\u3400-\u9fff]+／[\w\u3400-\u9fff]+',
                   lambda m: simplified(m[0]), value)
    return re.sub(r'\[([^\[\]]+)\]', r'\1', value).strip()


@dataclass
class Node:
    text: str
    depth: int
    children: list = field(default_factory=list)

    def walk(self):
        yield self
        for child in self.children:
            yield from child.walk()


def trees(text):
    roots, stack = [], []
    for raw in text.splitlines():
        line = raw.lstrip(' \t')
        depth = len(raw.expandtabs(1)) - len(line)
        if line.startswith('W|') and depth == 0:
            node = Node(line, depth)
            roots.append(node)
            stack = [node]
            continue
        if not stack or not line:
            continue
        # Continuation lines are two spaces deeper than their owner. Keep only
        # definition/note text; never turn comments or translations into notes.
        if depth >= stack[-1].depth + 2:
            if re.match(r'^(N\d+ |D\d+\|)', stack[-1].text):
                stack[-1].text += '\n' + line
            continue
        while stack and stack[-1].depth >= depth:
            stack.pop()
        if not stack:
            continue
        node = Node(line, depth)
        stack[-1].children.append(node)
        stack.append(node)
    return roots


class FmldDictionary:
    def __init__(self, text=None):
        if text is None:
            lock = json.loads((ROOT/'content/fmld.lock.json').read_text(encoding='utf-8'))
            source = next(f for f in lock['files'] if f['path'] == 'dict/fmld.en.txt')
            data = (ROOT/source['cache']).read_bytes()
            if hashlib.sha256(data).hexdigest() != source['sha256']:
                raise ValueError('FMLD checksum mismatch')
            text = data.decode('utf-8')
        self.entries = trees(text)
        self.notes = {}
        self.index = {}
        for entry in self.entries:
            for node in entry.walk():
                if m := re.match(r'^N(\d+) (.*)', node.text, re.S):
                    if m[1] in self.notes and self.notes[m[1]] != clean(m[2]):
                        raise ValueError('Conflicting FMLD note ID')
                    self.notes[m[1]] = clean(m[2])
            for variant in entry.text.split('|', 2)[2].split(';'):
                self.index.setdefault(simplified(variant), []).append(entry)

    def note_text(self, node):
        if m := re.match(r'^N(\d+) ', node.text):
            return self.notes[m[1]]
        if m := re.fullmatch(r'N->(\d+)', node.text):
            return self.notes.get(m[1], '')
        return ''

    def references(self, node):
        result = []
        seen = {}
        for ref in node.children:
            if not ref.text.startswith('X') or ref.text[1:2] not in RELATIONS:
                continue
            fields = ref.text.split('|')
            for i in range(1, len(fields)-1, 2):
                tags = fields[i].strip()
                for target in fields[i+1].strip().split(';'):
                    kind = RELATIONS[ref.text[1]]
                    words = seen.setdefault(kind, set())
                    if clean(target) in words or len(words) >= 4:
                        continue
                    words.add(clean(target))
                    result.append(dict(kind=RELATIONS[ref.text[1]], word=clean(target),
                                       sourceTarget=target, aiAssisted='a' in tags.lower()))
        return result

    def lookup(self, hanzi, pinyin):
        result = []
        for entry in self.index.get(hanzi, []):
            entry_id = 'fmld.' + hashlib.sha256(entry.text.split('|', 2)[2].encode()).hexdigest()[:20]
            general_notes = [self.note_text(n) for c in entry.children
                             if not c.text.startswith('P|') for n in c.walk()]
            for pron in entry.children:
                if not pron.text.startswith('P|'):
                    continue
                pronunciations = []
                for p in [pron] + [c for c in pron.children if c.text.startswith('P|')]:
                    fields = p.text.split('|')
                    for i in range(1, len(fields)-1, 2):
                        if 'x' not in fields[i]:
                            pronunciations.extend(fields[i+1].strip().split(';'))
                if reading(pinyin) not in {reading(p) for p in pronunciations}:
                    continue
                pron_notes = [self.note_text(n) for n in pron.children if n.text.startswith('N')]

                def visit(node, parents=(), inherited_tags='', pos=''):
                    if node.text.startswith('C '):
                        pos = node.text[2:]
                    match = re.match(r'^D(\d+)\|([^|]*)\|(.*)', node.text, re.S)
                    if match:
                        local_id, tags, definition = match.groups()
                        if not clean(definition):
                            # Upstream occasionally contains an unfilled sense.
                            # Do not turn it into an empty learner explanation.
                            return
                        tags = inherited_tags + ' ' + tags
                        # Historical/dialectal senses remain in the pinned source,
                        # not the beginner lesson. Preserve modern usage labels.
                        if 'x' in tags.split('#')[0] or re.search(r'#(?:archaic|obsolete|historical|dialectal|literary)', tags):
                            return
                        notes = general_notes + pron_notes + [self.note_text(n)
                            for c in node.children if not c.text.startswith('D') for n in c.walk()]
                        labels = re.findall(r'#([\w-]+)', tags)
                        result.append(dict(id=f'{entry_id}.D{local_id}',
                            meaning=clean(' — '.join((*parents, definition))),
                            partOfSpeech='' if pos == 'character' else pos,
                            common='+' in tags or '*' in tags,
                            labels=labels,
                            notes=list(dict.fromkeys(n for n in notes if n)),
                            related=self.references(node),
                            sourceTags=tags.strip()))
                        parents = (*parents, definition)
                        inherited_tags = tags
                    for child in node.children:
                        if child.text.startswith(('D', 'C ')):
                            visit(child, parents, inherited_tags, pos)

                for child in pron.children:
                    if child.text.startswith('C '):
                        visit(child)
        unique = {sense['id']: sense for sense in result}
        return sorted(unique.values(), key=lambda s: not s['common'])


def enrich(db):
    dictionary = FmldDictionary()
    counts = dict(withTeaching=0, teachingSenses=0, teachingNotes=0)
    for word_id, payload in db.execute('SELECT id,metadata_json FROM curriculum_words').fetchall():
        word = json.loads(payload)
        word.pop('teaching', None)
        senses = dictionary.lookup(word['hanzi'], word['details']['pinyinNumbered'])
        if senses:
            word['teaching'] = senses
            counts['withTeaching'] += 1
            counts['teachingSenses'] += len(senses)
            counts['teachingNotes'] += sum(bool(s['notes']) for s in senses)
        db.execute('UPDATE curriculum_words SET metadata_json=? WHERE id=?',
                   (json.dumps(word, ensure_ascii=False, separators=(',', ':')), word_id))
    return counts


def update_seed():
    destination = ROOT/'assets/content/curriculum.sqlite'
    manifest_file = destination.with_suffix('.manifest.json')
    manifest = json.loads(manifest_file.read_text(encoding='utf-8'))
    with tempfile.TemporaryDirectory(prefix='fmld-', dir=ROOT/'.content-cache') as folder:
        temporary = Path(folder)/'curriculum.sqlite'
        shutil.copyfile(destination, temporary)
        db = sqlite3.connect(temporary)
        try:
            with db:
                counts = enrich(db)
            db.execute('VACUUM')
            assert db.execute('PRAGMA integrity_check').fetchone()[0] == 'ok'
            assert not db.execute('PRAGMA foreign_key_check').fetchall()
        finally:
            db.close()
        if temporary.stat().st_size >= 100 * 1024 * 1024:
            raise ValueError('Seed exceeds repository asset limit')
        digest = hashlib.sha256(temporary.read_bytes()).hexdigest()
        if digest == manifest['sha256']:
            return manifest
        manifest.update(revision=max(3, manifest['revision'] + 1), sha256=digest)
        manifest['counts'].update(counts)
        # Create the publishing file in the asset directory so Windows inherits
        # its normal read permissions, not TemporaryDirectory's private ACL.
        publish = destination.with_name(f'.fmld-{uuid.uuid4().hex}.sqlite')
        try:
            shutil.copyfile(temporary, publish)
            publish.replace(destination)
        finally:
            publish.unlink(missing_ok=True)
        manifest_file.write_text(json.dumps(manifest, indent=2)+'\n', encoding='utf-8')
        return manifest


if __name__ == '__main__':
    print(json.dumps(update_seed(), indent=2))
