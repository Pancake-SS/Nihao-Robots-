import '../vocabulary/content_pack.dart';

/// Checks each response and returns missed questions to the end of the session.
/// First responses remain immutable evidence for the saved score/review schedule.
class QuizPractice {
  QuizPractice(Iterable<VocabularyQuestion> source)
    : questions = List.unmodifiable(source) {
    if (questions.isEmpty ||
        questions.map((q) => q.id).toSet().length != questions.length) {
      throw ArgumentError('A practice session needs distinct questions.');
    }
    _queue.addAll(List.generate(questions.length, (i) => i));
  }

  final List<VocabularyQuestion> questions;
  final _queue = <int>[];
  final _firstAnswers = <String, String>{};
  int _position = 0;
  String? _answer;
  bool? _correct;

  VocabularyQuestion get current => questions[_queue[_position]];
  int get questionNumber => _queue[_position] + 1;
  int get visit => _position;
  bool get isRetry => _position >= questions.length;
  String? get answer => _answer;
  bool? get correct => _correct;
  bool get checked => _correct != null;
  bool get canCheck => !checked && current.accepts(_answer);
  bool get complete => _correct == true && _position == _queue.length - 1;
  Map<String, String> get firstAnswers => Map.unmodifiable(_firstAnswers);
  int get firstCorrectCount =>
      questions.where((q) => q.isCorrect(_firstAnswers[q.id])).length;

  void choose(String answer) {
    if (checked) throw StateError('This response has already been checked.');
    _answer = answer;
  }

  void check() {
    if (!canCheck) throw StateError('Enter an answer before checking.');
    _firstAnswers.putIfAbsent(current.id, () => _answer!);
    _correct = current.isCorrect(_answer);
    if (!_correct!) _queue.add(_queue[_position]);
  }

  void next() {
    if (!checked || complete)
      throw StateError('No next question is available.');
    _position++;
    _answer = null;
    _correct = null;
  }
}
