import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../shared/app_brand.dart';
import '../../shared/learning_card.dart';
import '../../shared/robot_art.dart';
import '../../shared/cozy_ui.dart';
import '../../shared/context_tour.dart';
import '../vocabulary/content_pack.dart';
import 'learning.dart';
import 'chinese_answer_input.dart';
import 'learning_providers.dart';
import '../dashboard/daily_streak.dart';
import 'quiz_practice.dart';

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
  final _questionTarget = GlobalKey();
  final _checkTarget = GlobalKey();
  QuizSession? _session;
  SavedAttempt? _receipt;
  QuizPractice? _practice;
  bool _loading = true, _saving = false, _conflict = false;
  bool _submitted = false;
  String? _error;

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
          _practice = QuizPractice(session.word.entry.questions);
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
    if (_saving || _conflict || _receipt != null || _practice?.complete != true)
      return;
    setState(() {
      _saving = true;
      _submitted = true;
      _error = null;
    });
    try {
      final receipt = await ref
          .read(learningRepositoryProvider)
          .submit(_session!, _practice!.firstAnswers);
      if (!mounted) return;
      ref.invalidate(learningProgressProvider(widget.profileId));
      ref.invalidate(dailyStreakProvider(widget.profileId));
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
    final practice = _practice;
    return PopScope(
      canPop: !_saving,
      child: Scaffold(
        appBar: AppBar(
          title: AppScreenTitle(
            widget.review ? 'Vocabulary review' : 'First word quiz',
          ),
          actions: [
            if (session != null && practice != null && receipt == null)
              IconButton(
                tooltip: 'Page tutorial',
                onPressed: () => showContextTour(context, [
                  TourStop(
                    _questionTarget,
                    'Read the question',
                    'Choose an answer or type it in the Chinese answer box.',
                  ),
                  TourStop(
                    _checkTarget,
                    'Check and continue',
                    'Wrong answers return at the end. Your first correct answer earns a point.',
                  ),
                ]),
                icon: const Icon(Icons.help_outline),
              ),
          ],
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : WarmPageBackground(
                child: SingleChildScrollView(
                  controller: _scroll,
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 780),
                      child: LearningCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(9),
                                  decoration: BoxDecoration(
                                    color: AppColors.yellow,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.auto_stories_rounded,
                                    size: 23,
                                  ),
                                ),
                                const SizedBox(width: 11),
                                Expanded(
                                  child: Text(
                                    widget.review
                                        ? 'YOUR REVIEW SESSION'
                                        : 'WORD CHECKPOINT',
                                    style: const TextStyle(
                                      letterSpacing: 1,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.mutedInk,
                                    ),
                                  ),
                                ),
                                const RobotArt(
                                  artwork: RobotArtwork.shyOnPaper,
                                  size: 62,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            if (receipt != null) ...[
                              Text(
                                'Attempt saved',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                receipt.passed
                                    ? 'All ${session!.word.entry.questions.length} answers were correct on your first try.'
                                    : 'You corrected every missed question. ${practice!.firstCorrectCount} of ${practice.questions.length} answers were correct on your first try.',
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '${practice!.firstCorrectCount} correctness points earned. You can practise this word again at any time.',
                              ),
                              if (!receipt.passed) ...[
                                const SizedBox(height: 20),
                                Text(
                                  'Questions to revisit',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ],
                              for (final q
                                  in session!.word.entry.questions.where(
                                    (q) => !q.isCorrect(
                                      practice.firstAnswers[q.id],
                                    ),
                                  )) ...[
                                const Divider(height: 32),
                                Text(q.prompt),
                                const SizedBox(height: 8),
                                Text(
                                  'First answer: ${q.displayAnswer(practice.firstAnswers[q.id]!)}',
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
                            ] else if (session != null && practice != null) ...[
                              Text(
                                '${practice.isRetry ? 'Try again \u00b7 ' : ''}Question ${practice.questionNumber} of ${practice.questions.length}',
                              ),
                              const SizedBox(height: 16),
                              Text(
                                practice.current.prompt,
                                key: _questionTarget,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall,
                              ),
                              const SizedBox(height: 24),
                              if (practice.current.isTyped)
                                ChineseAnswerInput(
                                  key: ValueKey(
                                    'input-${practice.visit}-${practice.current.id}',
                                  ),
                                  answerKey: ValueKey(
                                    'typed-${practice.current.id}',
                                  ),
                                  initialValue: practice.answer ?? '',
                                  enabled:
                                      !practice.checked &&
                                      !_submitted &&
                                      !_conflict,
                                  onChanged: (value) =>
                                      setState(() => practice.choose(value)),
                                )
                              else
                                for (final option in _choices(
                                  practice.current,
                                )) ...[
                                  Semantics(
                                    selected: practice.answer == option.key,
                                    child: OutlinedButton(
                                      key: ValueKey('answer-${option.key}'),
                                      style: OutlinedButton.styleFrom(
                                        alignment: Alignment.centerLeft,
                                      ),
                                      onPressed:
                                          practice.checked ||
                                              _submitted ||
                                              _conflict
                                          ? null
                                          : () => setState(
                                              () => practice.choose(option.key),
                                            ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            practice.answer == option.key
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
                              if (practice.checked) ...[
                                Semantics(
                                  liveRegion: true,
                                  child: Text(
                                    practice.correct! ? 'Correct!' : 'Not quite. You will try this question again at the end.',
                                    key: const ValueKey('answer-feedback'),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium,
                                  ),
                                ),
                                if (!practice.correct!)
                                  Text(
                                    'Correct answer: ${practice.current.correctAnswer}',
                                  ),
                                Text(practice.current.explanation),
                                const SizedBox(height: 16),
                              ],
                              FilledButton(
                                key: _checkTarget,
                                onPressed: _saving || _conflict
                                    ? null
                                    : !practice.checked
                                    ? practice.canCheck
                                          ? () => setState(practice.check)
                                          : null
                                    : practice.complete
                                    ? _submit
                                    : () {
                                        setState(practice.next);
                                        _scroll.jumpTo(0);
                                      },
                                child: Text(
                                  _saving
                                      ? 'Saving\u2026'
                                      : !practice.checked
                                      ? 'Check answer'
                                      : practice.complete
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
      ),
    );
  }
}
