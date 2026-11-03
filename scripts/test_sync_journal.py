"""Regression checks for the Markdown-to-Word project memory mirror.

Run: python -m unittest discover -s scripts -p 'test_sync_journal.py'
"""

from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

from docx import Document
from docx.oxml.ns import qn

from sync_journal import build_document, sync_journal


class JournalTests(unittest.TestCase):
    def test_unicode_and_inline_content_survive_round_trip(self):
        markdown = '# Memory\n## Chinese\n- **学习** — `xuéxí`: to study\n'
        with tempfile.TemporaryDirectory() as directory:
            source = Path(directory) / 'memory.md'
            output = Path(directory) / 'journal.docx'
            source.write_text(markdown, encoding='utf-8')
            sync_journal(source, output)
            doc = Document(output)
        self.assertEqual(
            [p.text for p in doc.paragraphs],
            ['Memory', 'Chinese', '学习 — xuéxí: to study'],
        )
        runs = {run.text: run for run in doc.paragraphs[2].runs}
        self.assertTrue(runs['学习'].bold)
        self.assertEqual(runs['xuéxí'].font.name, 'Consolas')
        self.assertEqual(doc.paragraphs[2].style.name, 'List Bullet')

    def test_numbered_lists_use_word_numbering_and_restart(self):
        doc = build_document('1. First\n2. Second\n\n## Next\n1. Restart\n')
        first, second, _, restart = doc.paragraphs
        first_id = first._p.pPr.numPr.numId.val
        self.assertEqual(second._p.pPr.numPr.numId.val, first_id)
        self.assertNotEqual(restart._p.pPr.numPr.numId.val, first_id)
        self.assertEqual([first.text, second.text, restart.text],
                         ['First', 'Second', 'Restart'])
        numbering = doc.part.numbering_part.element
        abstracts = numbering.findall(qn('w:abstractNum'))
        self.assertTrue(any(
            node.find('.//' + qn('w:numFmt')).get(qn('w:val')) == 'decimal'
            for node in abstracts
        ))

    def test_headings_stay_with_following_paragraph(self):
        doc = build_document('# Memory\n## Status\nPending\n')
        for paragraph in doc.paragraphs[:2]:
            self.assertTrue(paragraph.style.paragraph_format.keep_with_next)
            self.assertTrue(paragraph.style.paragraph_format.keep_together)

    def test_failed_serialization_preserves_existing_mirror(self):
        with tempfile.TemporaryDirectory() as directory:
            source = Path(directory) / 'memory.md'
            output = Path(directory) / 'journal.docx'
            source.write_text('# Memory\n', encoding='utf-8')
            output.write_bytes(b'existing mirror')
            with patch('docx.document.Document.save', side_effect=OSError('full')):
                with self.assertRaises(OSError):
                    sync_journal(source, output)
            self.assertEqual(output.read_bytes(), b'existing mirror')
            self.assertEqual(sorted(p.name for p in Path(directory).iterdir()),
                             ['journal.docx', 'memory.md'])

    def test_missing_source_does_not_replace_mirror(self):
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / 'journal.docx'
            output.write_bytes(b'existing mirror')
            with self.assertRaises(FileNotFoundError):
                sync_journal(Path(directory) / 'missing.md', output)
            self.assertEqual(output.read_bytes(), b'existing mirror')


if __name__ == '__main__':
    unittest.main()
