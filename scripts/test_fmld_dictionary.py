import unittest

from fmld_dictionary import FmldDictionary


class FmldTests(unittest.TestCase):
    def test_pronunciation_scope_modern_senses_and_comment_separation(self):
        source = '''W|w|行
 P||xing2
  C verb
   D1|+|to go
    # Editorial TODO: do not show this
      or this continuation
    D2||to travel
   D3|x #obsolete|old use
   D6|#slang|
 P||hang2
  C noun
   D4||row
'''
        dictionary = FmldDictionary(source)
        senses = dictionary.lookup('行', 'xing2')
        self.assertEqual([s['meaning'] for s in senses], ['to go', 'to go — to travel'])
        self.assertEqual(dictionary.lookup('行', 'hang2')[0]['meaning'], 'row')
        self.assertEqual(dictionary.lookup('行', 'hang4'), [])
        self.assertNotIn('Editorial', str(senses))
        self.assertEqual(len({s['id'] for s in senses}), 2)

    def test_notes_references_variants_and_numbered_readings(self):
        source = '''W|w|書／书
 P||shu1
  C noun
   D1|*|book
    XC||本#D9;冊／册#D5
    X=|A|書籍／书籍#D1
     N100 Use [書／书#D1] here.
       A second line.
W|w|冊／册
 P||ce4
  C noun
   D1||volume
    X?||書／书#D1
     N->100
'''
        dictionary = FmldDictionary(source)
        book = dictionary.lookup('书', 'shu1')[0]
        self.assertEqual(book['related'][1]['word'], '册')
        self.assertFalse(book['related'][0]['aiAssisted'])
        self.assertTrue(book['related'][2]['aiAssisted'])
        self.assertEqual(book['notes'], ['Use 书 here.\nA second line.'])
        self.assertEqual(dictionary.lookup('册', 'ce4')[0]['notes'], book['notes'])
        self.assertEqual(dictionary.lookup('书', 'shū'), [])


if __name__ == '__main__':
    unittest.main()
