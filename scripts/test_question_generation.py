from dataclasses import replace
import unittest

from question_generation import (Choice, DistractorSelector, InsufficientDistractors,
                                 QuestionBankGenerator, QuestionPattern, Word, Example)


class QuestionGenerationTests(unittest.TestCase):
    def setUp(self):
        self.target = Word('target', '书', 'shū', 'book', 1, 'noun', (Example('这是书。', 'This is a book.', 'sentence-1'),))
        self.pool = [self.target,
            Word('teacher', '老师', 'lǎoshī', 'teacher', 1, 'noun'),
            Word('student', '学生', 'xuéshēng', 'student', 1, 'noun'),
            Word('school', '学校', 'xuéxiào', 'school', 1, 'noun'),
            Word('eat', '吃', 'chī', 'to eat', 1, 'verb')]

    def test_templates_use_source_answers_and_real_distinct_distractors(self):
        generator = QuestionBankGenerator(self.pool)
        first = generator.generate(self.target)
        self.assertEqual(first, generator.generate(self.target))
        self.assertEqual(len(first), 8)
        fields = dict(meaning='meaning', hanzi='hanzi', pinyin='pinyin', pinyin_hanzi='hanzi',
                      meaning_pinyin='pinyin', pinyin_meaning='meaning', cloze='hanzi', typed_hanzi='hanzi')
        for question in first:
            options = question['options']
            field = fields[question['kind']]
            correct = next(o['text'] for o in options if o['id'] == question['correctOptionId'])
            self.assertEqual(correct, getattr(self.target, field))
            self.assertTrue(all(o['text'] in {getattr(w, field) for w in self.pool} for o in options))
            self.assertEqual(len({o['text'] for o in options}), len(options))

    def test_rejects_homophones_synonyms_duplicates_and_higher_level_choices(self):
        unsafe = [Word('homophone', '输', 'shū', 'to lose', 1, 'noun'),
                  Word('same-meaning', '书籍', 'shūjí', 'book; books', 1, 'noun'),
                  Word('same-hanzi', '书', 'shù', 'another reading', 1, 'noun'),
                  Word('advanced', '论文', 'lùnwén', 'thesis', 6, 'noun')]
        chosen = DistractorSelector(self.pool+unsafe).choose(self.target, 'pinyin')
        self.assertEqual({w.id for w in chosen}, {'teacher', 'student', 'school'})
        with self.assertRaises(ValueError): DistractorSelector(self.pool+[self.target])

    def test_insufficient_pool_reports_skip_without_fabricating_answers(self):
        generator = QuestionBankGenerator([self.target])
        with self.assertRaises(InsufficientDistractors): generator.generate(self.target)
        bank, skipped = generator.generate_many([self.target])
        self.assertFalse(bank)
        self.assertIn('target', skipped)

    def test_no_sentence_means_no_invented_cloze(self):
        questions = QuestionBankGenerator(self.pool).generate(replace(self.target, examples=()))
        self.assertEqual(len(questions), 7)
        self.assertNotIn('cloze', [q['kind'] for q in questions])

    def test_new_pattern_can_be_registered_without_editing_generator(self):
        class CustomPattern(QuestionPattern):
            kind = 'custom-test'
            def generate(self, word, selector):
                return self.make(word, 'Fixture prompt', [Choice('correct', word.hanzi)])
        questions = QuestionBankGenerator(self.pool, [CustomPattern()]).generate(self.target)
        self.assertEqual(questions[0]['kind'], 'custom-test')
        with self.assertRaises(ValueError): QuestionBankGenerator(self.pool, [CustomPattern(), CustomPattern()])


if __name__ == '__main__':
    unittest.main()
