import unittest
from learning_priority import priority_for


class PriorityTests(unittest.TestCase):
    def test_foundations_then_bands_without_calling_source_order_difficulty(self):
        self.assertEqual(priority_for('你好', 1, 120).tier, 0)
        self.assertLess(priority_for('我', 1, 260).order, priority_for('吃', 1, 20).order)
        self.assertEqual([priority_for('other', b, 5).tier for b in (1, 2, 3, 4, 5, 6, 7)],
                         [1, 1, 2, 2, 3, 3, 3])
        self.assertEqual(priority_for('other', None, None).tier, 4)
        self.assertNotEqual(priority_for('我', 6, 3).tier, 0)

    def test_malformed_priority_metadata_fails(self):
        for band, sequence in ((True, 1), (9, 2), (1, -1), (None, 2), (1, True)):
            with self.assertRaises(ValueError):
                priority_for('other', band, sequence)
