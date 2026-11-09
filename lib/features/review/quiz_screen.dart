import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/learning_card.dart';
import '../vocabulary/content_pack.dart';
import 'learning.dart';
import 'chinese_answer_input.dart';
import 'learning_providers.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({
    required this.profileId,
    required this.wordId,
    required this.review,
    super.key,
  });
  final int profileId;
  final String wordId;
  final bool review;
  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  QuizSession? _session;
  SavedAttempt? _receipt;
  final _answers = <String, String>{};
  bool _loading = true, _saving = false, _conflict = false;
  bool _submitted = false;
  String? _error;
  int _index = 0;
  final _scroll = ScrollController();

  List<MapEntry<String, String>> _choices(VocabularyQuestion question) =>
      question.options.entries.toList()
        ..shuffle(Random(_session!.eventId.hashCode ^ question.id.hashCode));

  @override
  void initState() {
    super.initState();
    _begin();
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _begin() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final session = await ref
          .read(learningRepositoryProvider)
          .begin(widget.profileId, widget.wordId, review: widget.review);
      if (mounted)
        setState(() {
          _session = session;
          _loading = false;
        });
    } catch (e) {
      if (mounted)
        setState(() {
          _loading = false;
          _error = e is LearningConflict
              ? e.message
              : 'Could not open this quiz. Try again.';
        });
    }
  }

  Future<void> _submit() async {
    if (_saving || _conflict || _receipt != null) return;
    setState(() {
      _saving = true;
      _submitted = true;
      _error = null;
    });
    try {
      final receipt = await ref
          .read(learningRepositoryProvider)
          .submit(_session!, _answers);
      if (!mounted) return;
      ref.invalidate(learningProgressProvider(widget.profileId));
      setState(() {
        _receipt = receipt;
        _saving = false;
      });
      _scroll.jumpTo(0);
    } catch (e) {
      if (!mounted) return;
      ref.invalidate(learningProgressProvider(widget.profileId));
      setState(() {
        _saving = false;
        _conflict = e is LearningConflict;
        _error = _conflict ? (e as LearningConflict).message : 'Could not confirm the save. Your answers are kept here; try saving again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = _session;
    final receipt = _receipt;
    return PopScope(
      canPop: !_saving,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.review ? 'Vocabulary review' : 'First word quiz'),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                controller: _scroll,
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 780),
                    child: LearningCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (receipt != null) ...[
                            Text(
                              'Attempt saved',
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              receipt.passed
                                  ? 'All ${session!.word.entry.questions.length} checks were correct.'
                                  : 'Keep practising. Your answers and next review are saved.',
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Next review: ${MaterialLocalizations.of(context).formatFullDate(receipt.nextDueAt.toLocal())}, '
                              '${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(receipt.nextDueAt.toLocal()))}',
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'This checkpoint does not award mastery. Return to Vocabulary Practice when the review is due.',
                            ),
                            for (final q in session!.word.entry.questions) ...[
                              const Divider(height: 32),
                              Text(q.prompt),
                              const SizedBox(height: 8),
                              Text(
                                'Your answer: ${q.displayAnswer(_answers[q.id]!)}',
                              ),
                              Text('Correct answer: ${q.correctAnswer}'),
                              const SizedBox(height: 8),
                              Text(q.explanation),
                            ],
                            const SizedBox(height: 24),
                            FilledButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Done'),
                            ),
                          ] else if (session != null) ...[
                            Text(
                              'Question ${_index + 1} of ${session.word.entry.questions.length}',
                            ),
                            const SizedBox(height: 16),
                            Text(
                              session.word.entry.questions[_index].prompt,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 24),
                            if (session.word.entry.questions[_index].isTyped)
                              ChineseAnswerInput(
                                key: ValueKey(
                                  'input-${session.word.entry.questions[_index].id}',
                                ),
                                answerKey: ValueKey(
                                  'typed-${session.word.entry.questions[_index].id}',
                                ),
                                initialValue:
                                    _answers[session
                                        .word
                                        .entry
                                        .questions[_index]
                                        .id] ??
                                    '',
                                enabled: !_submitted && !_conflict,
                                onChanged: (value) => setState(
                                  () =>
                                      _answers[session
                                              .word
                                              .entry
                                              .questions[_index]
                                              .id] =
                                          value,
                                ),
                              )
                            else
                              for (final option in _choices(
                                session.word.entry.questions[_index],
                              )) ...[
                                Semantics(
                                  selected:
                                      _answers[session
                                          .word
                                          .entry
                                          .questions[_index]
                                          .id] ==
                                      option.key,
                                  child: OutlinedButton(
                                    key: ValueKey('answer-${option.key}'),
                                    style: OutlinedButton.styleFrom(
                                      alignment: Alignment.centerLeft,
                                    ),
                                    onPressed: _submitted || _conflict
                                        ? null
                                        : () => setState(
                                            () =>
                                                _answers[session
                                                        .word
                                                        .entry
                                                        .questions[_index]
                                                        .id] =
                                                    option.key,
                                          ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          _answers[session
                                                      .word
                                                      .entry
                                                      .questions[_index]
                                                      .id] ==
                                                  option.key
                                              ? Icons.radio_button_checked
                                              : Icons.radio_button_off,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(child: Text(option.value)),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                              ],
                            FilledButton(
                              onPressed:
                                  _saving ||
                                      _conflict ||
                                      !session.word.entry.questions[_index]
                                          .accepts(
                                            _answers[session
                                                .word
                                                .entry
                                                .questions[_index]
                                                .id],
                                          )
                                  ? null
                                  : _index ==
                                        session.word.entry.questions.length - 1
                                  ? _submit
                                  : () {
                                      setState(() => _index++);
                                      _scroll.jumpTo(0);
                                    },
                              child: Text(
                                _saving
                                    ? 'Saving…'
                                    : _index ==
                                          session.word.entry.questions.length -
                                              1
                                    ? _error == null
                                          ? 'Save answers'
                                          : 'Try saving again'
                                    : 'Next question',
                              ),
                            ),
                          ],
                          if (_error != null) ...[
                            const SizedBox(height: 16),
                            Semantics(liveRegion: true, child: Text(_error!)),
                            if (session == null)
                              TextButton(
                                onPressed: _begin,
                                child: const Text('Try again'),
                              ),
                            if (_conflict)
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Return'),
                              ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
