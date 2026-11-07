import hashlib
from contextlib import closing
import json
from pathlib import Path
import sqlite3
import unittest

ROOT=Path(__file__).resolve().parents[1]


class CurriculumBundleTests(unittest.TestCase):
    def test_manifest_full_coverage_and_foreign_keys(self):
        path=ROOT/'assets/content/curriculum.sqlite'
        manifest=json.loads(path.with_suffix('.manifest.json').read_bytes())
        self.assertEqual(hashlib.sha256(path.read_bytes()).hexdigest(),manifest['sha256'])
        with closing(sqlite3.connect(f'{path.as_uri()}?mode=ro',uri=True)) as db:
            self.assertEqual(db.execute('PRAGMA integrity_check').fetchone()[0],'ok')
            self.assertEqual(db.execute('PRAGMA foreign_key_check').fetchall(),[])
            self.assertEqual(db.execute('SELECT count(*) FROM curriculum_words').fetchone()[0],11147)
            self.assertEqual(db.execute('SELECT count(*) FROM curriculum_questions').fetchone()[0],82595)
            missing=db.execute('SELECT w.id FROM curriculum_words w LEFT JOIN curriculum_questions q ON q.word_id=w.id GROUP BY w.id HAVING count(q.id)<7').fetchall()
            self.assertEqual(missing,[])

    def test_every_linked_local_audio_record_has_matching_file_and_pinned_source(self):
        with closing(sqlite3.connect(f'{(ROOT/"assets/content/curriculum.sqlite").as_uri()}?mode=ro',uri=True)) as db:
            seen=set()
            for raw, in db.execute('SELECT payload_json FROM curriculum_audio WHERE local_available=1'):
                audio=json.loads(raw)
                if audio['asset'] in seen: continue
                seen.add(audio['asset'])
                self.assertRegex(audio['asset'],r'^assets/audio/hsk[1-6]-[0-9]{4}\.mp3$')
                data=(ROOT/audio['asset']).read_bytes()
                self.assertEqual(len(data),audio['bytes'])
                self.assertEqual(hashlib.sha256(data).hexdigest(),audio['sha256'])
                self.assertIn('/857dfbab91027ebd97df01260e91b817cb6b4854/dist/audio/',audio['url'])
            self.assertEqual(len(seen),4118)
