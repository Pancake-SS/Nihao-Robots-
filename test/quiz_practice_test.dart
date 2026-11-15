import 'package:flutter_test/flutter_test.dart';
import 'package:ni_hao_robot/features/review/quiz_practice.dart';

import 'pilot_fixture.dart';

void main() {
  test('missed question returns after the others until answered correctly', () {
    final questions = loadPilot().entry.questions;
    final practice = QuizPractice(questions);
    final first = questions.first;
    final wrong = first.options.keys.firstWhere(
      (id) => id != first.correctOptionId,
    );

    expect(practice.canCheck, isFalse);
    expect(() => practice.check(), throwsStateError);
    practice.choose(wrong);
    practice.check();
    expect(practice.correct, isFalse);
    expect(practice.complete, isFalse);
    expect(practice.firstAnswers[first.id], wrong);
    expect(() => practice.choose(first.correctOptionId), throwsStateError);

    practice.next();
    expect(practice.current.id, questions[1].id);
    practice.choose(questions[1].correctOptionId);
    practice.check();
    expect(practice.complete, isFalse);

    practice.next();
    expect(practice.isRetry, isTrue);
    expect(practice.current.id, first.id);
    expect(practice.answer, isNull);
    practice.choose(wrong);
    practice.check();
    expect(practice.complete, isFalse);

    practice.next();
    practice.choose(first.correctOptionId);
    practice.check();
    expect(practice.complete, isTrue);
    expect(practice.firstCorrectCount, questions.length - 1);
    expect(practice.firstAnswers[first.id], wrong);
    expect(() => practice.next(), throwsStateError);
  });
}
