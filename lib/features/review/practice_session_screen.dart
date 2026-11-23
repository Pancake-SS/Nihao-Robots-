import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/app_brand.dart';
import '../../shared/cozy_ui.dart';
import '../../shared/learning_card.dart';
import '../vocabulary/content_pack.dart';
import '../vocabulary/vocabulary_repository.dart';
import 'chinese_answer_input.dart';
import 'learning.dart';
import 'learning_providers.dart';
import '../dashboard/daily_streak.dart';
import 'practice_deck.dart';
import 'practice_repository.dart';
import 'master_repository.dart';
import 'quiz_practice.dart';

class PracticeSessionScreen extends ConsumerStatefulWidget {
  const PracticeSessionScreen({
    required this.profileId,
    required this.mode,
    required this.wordIds,
    this.count = 0,
    this.masterChallenge = false,
    this.masterPractice = false,
    super.key,
  }) : assert(!masterChallenge || !masterPractice);
  final int profileId, count;
  final PracticeMode mode;
  final List<String> wordIds;
  final bool masterChallenge, masterPractice;
  @override
  ConsumerState<PracticeSessionScreen> createState() =>
      _PracticeSessionScreenState();
}

class _PracticeSessionScreenState extends ConsumerState<PracticeSessionScreen> {
  late final PracticeDeck _deck;
  QuizPractice? _quiz;
  Map<String, PracticeItem> _items = {};
  final _events = <String, String>{};
  final _savedEvents = <String>{};
  final _masterMisses = <String, int>{};
  final _penaltyAppliedVisits = <String>{};
  bool _loading = true, _saving = false, _finished = false;
  int _seen = 0, _pointsAdded = 0;
  String? _error, _demotedWordId;

  @override
  void initState() {
    super.initState();
    _deck = PracticeDeck(
      mode: widget.mode,
      wordIds: widget.wordIds,
      count: widget.count,
    );
    _loadBatch();
  }

  Future<void> _loadBatch() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final items = await _deck.nextBatch(
        (id) => ref.read(vocabularyLessonProvider(id).future),
      );
      if (!mounted) return;
      setState(() {
        _items = {for (final item in items) item.question.id: item};
        _quiz = items.isEmpty
            ? null
            : QuizPractice(items.map((item) => item.question));
        _finished = items.isEmpty;
        _loading = false;
      });
    } catch (_) {
      if (mounted)
        setState(() {
          _loading = false;
          _error = 'Could not load practice questions. Try again.';
        });
    }
  }

  Future<bool> _saveChecked() async {
    final quiz = _quiz!;
    if (quiz.isRetry) return true;
    final item = _items[quiz.current.id]!;
    final event = _events.putIfAbsent(quiz.current.id, () => newAttemptId());
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final correct = await ref
          .read(practiceRepositoryProvider)
          .recordFirstResponse(
            eventId: event,
            profileId: widget.profileId,
            wordId: item.wordId,
            questionId: item.question.id,
            answer: quiz.firstAnswers[item.question.id]!,
            allowUnlearned: widget.masterChallenge,
          );
      if (!mounted) return false;
      if (_savedEvents.add(event)) {
        if (correct) _pointsAdded++;
        _seen++;
      }
      ref.invalidate(learningProgressProvider(widget.profileId));
      ref.invalidate(dailyStreakProvider(widget.profileId));
      setState(() => _saving = false);
      return true;
    } catch (e) {
      if (mounted)
        setState(() {
          _saving = false;
          _error = e is LearningConflict
              ? e.message
              : 'Could not save this answer. Try saving again.';
        });
      return false;
    }
  }

  Future<void> _applyMasterMiss() async {
    final quiz = _quiz!;
    final wordId = _items[quiz.current.id]!.wordId;
    if (_penaltyAppliedVisits.add('${quiz.current.id}:${quiz.visit}')) {
      setState(() => _masterMisses[wordId] = (_masterMisses[wordId] ?? 0) + 1);
    }
    if (_masterMisses[wordId]! < 3) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref
          .read(masterRepositoryProvider)
          .returnToLearn(widget.profileId, wordId);
      if (!mounted) return;
      ref.invalidate(masteredIdsProvider(widget.profileId));
      ref.invalidate(learningProgressProvider(widget.profileId));
      setState(() {
        _saving = false;
        _demotedWordId = wordId;
        _finished = true;
      });
    } catch (_) {
      if (mounted)
        setState(() {
          _saving = false;
          _error = 'Could not move this word to Learn. Try again.';
        });
    }
  }

  Future<void> _check() async {
    final quiz = _quiz!;
    final retry = quiz.isRetry;
    setState(quiz.check);
    if (!retry && !await _saveChecked()) return;
    if (widget.masterPractice && !quiz.correct!) await _applyMasterMiss();
  }

  Future<void> _retrySave() async {
    final quiz = _quiz!;
    if (!await _saveChecked()) return;
    if (widget.masterPractice && !quiz.correct!) await _applyMasterMiss();
  }

  Future<void> _next() async {
    final quiz = _quiz!;
    if (quiz.complete) {
      if (widget.masterChallenge) {
        Navigator.of(context).pop(true);
        return;
      }
      if (widget.mode != PracticeMode.singleWord) {
        await _loadBatch();
      } else {
        setState(() => _finished = true);
      }
      return;
    }
    setState(quiz.next);
  }

  List<MapEntry<String, String>> _choices(VocabularyQuestion question) =>
      question.options.entries.toList()..shuffle(Random(question.id.hashCode));

  @override
  Widget build(BuildContext context) {
    final quiz = _quiz;
    final eligible =
        ref
            .watch(learningProgressProvider(widget.profileId))
            .asData
            ?.value
            .any(
              (word) =>
                  widget.wordIds.contains(word.wordId) &&
                  word.correctCount >= masterPointGoal,
            ) ??
        false;
    return PopScope(
      canPop: !_saving,
      child: Scaffold(
        appBar: AppBar(
          title: AppScreenTitle(
            widget.masterChallenge
                ? 'Master test'
                : widget.masterPractice
                ? 'Master practice'
                : 'Practice',
          ),
        ),
        body: WarmPageBackground(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  LearningCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (_loading)
                          const LinearProgressIndicator()
                        else if (_finished) ...[
                          Text(
                            _demotedWordId == null
                                ? 'Session complete'
                                : 'Word returned to Learn',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _demotedWordId == null
                                ? '$_seen questions answered · $_pointsAdded correctness points earned'
                                : 'Three missed answers used this word’s chances. Its correctness points are saved.',
                          ),
                          if (eligible &&
                              !widget.masterPractice &&
                              !widget.masterChallenge) ...[
                            const SizedBox(height: 10),
                            const Text(
                              'A word in this session is ready for its Master test. Open Vocabulary > Master to continue.',
                            ),
                          ],
                          const SizedBox(height: 18),
                          FilledButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              widget.masterPractice
                                  ? 'Back to Master'
                                  : 'Back to Practice',
                            ),
                          ),
                        ] else if (quiz != null) ...[
                          Text(
                            widget.mode == PracticeMode.singleWord
                                ? 'Question ${quiz.questionNumber} of ${quiz.questions.length}'
                                : quiz.isRetry
                                ? 'Correction · ${widget.mode == PracticeMode.endless ? 'endless' : 'random'} mode'
                                : 'Question ${_seen + (quiz.checked ? 0 : 1)}${widget.mode == PracticeMode.randomWords ? ' of ${widget.count}' : ''} · ${widget.mode == PracticeMode.endless ? 'endless' : 'random'} mode',
                          ),
                          const SizedBox(height: 14),
                          Text(
                            quiz.current.prompt,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 20),
                          if (quiz.current.isTyped)
                            ChineseAnswerInput(
                              key: ValueKey('practice-input-${quiz.visit}'),
                              answerKey: const ValueKey(
                                'practice-typed-answer',
                              ),
                              initialValue: quiz.answer ?? '',
                              enabled: !quiz.checked && !_saving,
                              onChanged: (value) =>
                                  setState(() => quiz.choose(value)),
                            )
                          else
                            for (final option in _choices(quiz.current)) ...[
                              OutlinedButton(
                                key: ValueKey('practice-answer-${option.key}'),
                                onPressed: quiz.checked || _saving
                                    ? null
                                    : () => setState(
                                        () => quiz.choose(option.key),
                                      ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(option.value),
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          if (quiz.checked) ...[
                            const SizedBox(height: 12),
                            Text(
                              quiz.correct!
                                  ? quiz.isRetry
                                        ? 'Correct! This question is complete.'
                                        : _saving
                                        ? 'Correct! Saving your point…'
                                        : _error != null
                                        ? 'Correct! Save again to earn the point.'
                                        : 'Correct! +1 point'
                                  : 'Not quite. Try this again at the end of this round.',
                            ),
                            if (!quiz.correct! && !widget.masterPractice)
                              Text(
                                'Correct answer: ${quiz.current.correctAnswer}',
                              ),
                            if (!quiz.correct! && widget.masterPractice)
                              Text(
                                '${3 - (_masterMisses[_items[quiz.current.id]!.wordId] ?? 0)} chances left for this word.',
                              ),
                            Text(quiz.current.explanation),
                          ],
                          const SizedBox(height: 16),
                          FilledButton(
                            onPressed: _saving
                                ? null
                                : _error != null && quiz.checked
                                ? _retrySave
                                : !quiz.checked
                                ? quiz.canCheck
                                      ? _check
                                      : null
                                : _next,
                            child: Text(
                              _saving
                                  ? 'Saving…'
                                  : _error != null && quiz.checked
                                  ? 'Try saving again'
                                  : quiz.checked
                                  ? quiz.complete
                                        ? 'Finish round'
                                        : 'Next question'
                                  : 'Check answer',
                            ),
                          ),
                        ],
                        if (_error != null) ...[
                          const SizedBox(height: 12),
                          Text(_error!, key: const ValueKey('practice-error')),
                          if (quiz == null && !_loading)
                            TextButton(
                              onPressed: _loadBatch,
                              child: const Text('Try again'),
                            ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
