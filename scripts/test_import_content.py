import copy
from contextlib import closing
import hashlib
import json
from pathlib import Path
import sqlite3
import tempfile
import unittest

from import_content import publish, read_source, stage, validate_sources


def fixtures():
    words = {'license': 'CC BY 4.0', 'words': []}
    sentences = []
    selection = {'reviewedOn': '2026-11-04', 'reviewedBy': 'Test fixture only',
                 'words': {}, 'sentencePinyinOverrides': {}}
    for i in range(4):
        wid = f'w{i}'
        words['words'].append(dict(id=wid, simplified=f'target{i}', traditional=f'target{i}',
            pinyin=f'reading{i}', pinyin_num=f'reading{i}', gloss_en=f'meaning{i}',
            hsk3_band=1, hsk3_seq=i, pos_en='test', pos_zh='test'))
        selection['words'][wid] = []
        for j in range(5):
            sid = f's{i}-{j}'
            selection['words'][wid].append(sid)
            sentences.append(dict(id=sid, chinese=f'target{i} example {j}', traditional=f'target{i} example {j}',
                pinyin=f'reading{i} example {j}', translation={'en': f'meaning{i} example {j}'},
                hsk_level=1, topic='test', tokens=[{'word': f'target{i}', 'pinyin': f'reading{i}'}], grammar_tags=['test']))
    source = dict(url='https://example.org/source', sha256='0'*64, version='test', license='CC BY 4.0',
                  attribution='Synthetic fixture', licenseUrl='https://creativecommons.org/licenses/by/4.0/')
    return words, sentences, selection, {'words': source, 'sentences': source}


class ImportTests(unittest.TestCase):
    def test_staging_is_normalized_and_reproducible(self):
        w, s, selection, lock = fixtures()
        validate_sources(w, s)
        pack = publish(w, s, selection, lock)
        self.assertEqual(pack, publish(w, s, selection, lock))
        self.assertEqual(len(pack['words'][0]['questions']), 8)
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory)/'stage.sqlite'
            counts = stage(path, w, s, pack, lock)
            self.assertEqual(counts['words'], 4)
            self.assertEqual(counts['exercises'], 32)
            with closing(sqlite3.connect(path)) as db:
                self.assertEqual(db.execute('PRAGMA foreign_key_check').fetchall(), [])
                self.assertEqual(db.execute("SELECT count(*) FROM word_sentence_links WHERE link_status='selected'").fetchone()[0], 20)

    def test_bad_source_ids_duplicates_and_controls_are_rejected(self):
        for kind in ['duplicate', 'path', 'control', 'license']:
            w, s, _, _ = fixtures()
            if kind == 'duplicate': w['words'].append(copy.deepcopy(w['words'][0]))
            if kind == 'path': w['words'][0]['id'] = '../escape'
            if kind == 'control': s[0]['chinese'] += '\x00'
            if kind == 'license': w['license'] = 'unknown'
            with self.assertRaises(ValueError): validate_sources(w, s)

    def test_invalid_selection_cannot_publish(self):
        w, s, selected, lock = fixtures()
        selected['words']['w0'][0] = selected['words']['w1'][0]
        with self.assertRaises(ValueError): publish(w, s, selected, lock)
        selected['words']['w0'].pop()
        with self.assertRaises(ValueError): publish(w, s, selected, lock)

    def test_checksum_change_requires_explicit_review(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory)/'words.json'
            path.write_bytes(b'{"test":true}')
            lock = {'sha256': hashlib.sha256(path.read_bytes()).hexdigest()}
            self.assertEqual(read_source('words', lock, Path(directory)), {'test': True})
            path.write_bytes(b'{"test":false}')
            with self.assertRaises(ValueError): read_source('words', lock, Path(directory))

    def test_failed_staging_preserves_previous_database(self):
        w, s, selected, lock = fixtures()
        pack = publish(w, s, selected, lock)
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory)/'stage.sqlite'
            stage(path, w, s, pack, lock)
            old = path.read_bytes()
            pack['words'][0]['questions'].append(pack['words'][0]['questions'][0])
            with self.assertRaises(sqlite3.IntegrityError): stage(path, w, s, pack, lock)
            self.assertEqual(path.read_bytes(), old)


if __name__ == '__main__':
    unittest.main()
