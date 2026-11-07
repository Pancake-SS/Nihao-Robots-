import json
from pathlib import Path
import sqlite3
from contextlib import closing
import unittest

from corpus_examples import CorpusExamples

ROOT = Path(__file__).resolve().parents[1]


@unittest.skipUnless((ROOT / '.content-cache/roxaleen').exists(), 'Run fetch_corpus.py --fetch for source-level corpus integration tests')
class CorpusTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.corpus = CorpusExamples()

    def test_exact_pairs_have_original_ids_and_translations(self):
        with closing(sqlite3.connect(f'{(ROOT/"assets/content/curriculum.sqlite").as_uri()}?mode=ro',uri=True)) as db:
            count = 0
            for raw, in db.execute('SELECT payload_json FROM curriculum_sentences'):
                example = json.loads(raw)
                if not example['sourceId'].startswith('tatoeba.'):
                    continue
                cn,en,traditional = self.corpus.pairs[(example['hanzi'],example['meaning'])]
                self.assertEqual(example['sourceId'], f'tatoeba.{cn}.{en}')
                self.assertEqual(example['traditional'], traditional)
                self.assertTrue(example['sourceUrl'].endswith('/'+cn))
                self.assertTrue(example['translationSourceUrl'].endswith('/'+en))
                self.assertIn('CC BY 2.0 FR',example['credit'])
                self.assertIn('pypinyin',example['annotation'])
                count += 1
            self.assertEqual(count,13846)

    def test_matches_pronunciation_and_never_replaces_existing_examples(self):
        # Wrong reading must not match merely because the Hanzi is the same.
        self.assertEqual(self.corpus.examples('我们','invalid',[]),[])
        examples=self.corpus.examples('我们','wǒ men',[])
        self.assertTrue(examples)
        before=json.dumps(examples,ensure_ascii=False)
        self.assertEqual(self.corpus.examples('我们','wǒ men',examples,limit=len(examples)),[])
        self.assertEqual(json.dumps(examples,ensure_ascii=False),before)
        rest=self.corpus.examples('我们','wǒ men',examples[:1])
        self.assertNotIn(examples[0]['hanzi'],[e['hanzi'] for e in rest])
