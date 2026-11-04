// Synthetic parser data only. These strings are not a language lesson or a
// declaration that any reviewer has approved production curriculum.
Map<String, Object?> fixture() => {
  'schemaVersion': 1,
  'id': 'test.pack',
  'revision': 1,
  'words': [word('test.sense.1')],
};

Map<String, Object?> word(String id) => {
  'id': id,
  'hanzi': '测试',
  'pinyin': 'cèshì',
  'meaning': 'test fixture',
  'examples': List.generate(
    5,
    (i) => {'hanzi': '测试$i', 'pinyin': 'synthetic $i', 'meaning': 'fixture $i'},
  ),
  'source': 'Synthetic unit-test fixture, including all examples',
  'license': 'Test data only',
  'reviewedBy': 'Synthetic test reviewer',
  'reviewedOn': '2026-11-04',
  'reviewStatus': 'approved',
  'audio': null,
};
