import 'package:flutter_test/flutter_test.dart';
import 'package:ni_hao_robot/features/profiles/profile.dart';

void main() {
  test('accepts Mandarin, tone marks, apostrophes and emoji names', () {
    for (final name in ['小明', 'Lǐ Míng', "O'Connor", 'Mei 🤖']) {
      expect(validateProfileName(name), isNull);
    }
    expect(const ProfileDraft(name: '  小明  ').validatedName, '小明');
  });

  test(
    'rejects empty, hidden/control, oversized and invalid Unicode input',
    () {
      for (final name in [
        '',
        '   ',
        'A\nB',
        'A\u0000B',
        '\u202Ename',
        '\u200B',
        'a' * 41,
        'a${'\u0301' * 160}',
        String.fromCharCode(0xD800),
      ]) {
        expect(validateProfileName(name), isNotNull);
      }
    },
  );

  test('repository boundary validates the daily goal', () {
    expect(
      () => const ProfileDraft(name: 'Mei', dailyMinutes: -1).validatedName,
      throwsFormatException,
    );
    expect(
      () => const ProfileDraft(name: '\u2066Mei').validatedName,
      throwsFormatException,
    );
  });
}
