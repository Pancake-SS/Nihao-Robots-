import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/app_brand.dart';
import '../../shared/cozy_ui.dart';
import '../../shared/context_tour.dart';
import '../../shared/learning_card.dart';
import '../dashboard/daily_streak.dart';
import 'learning_providers.dart';
import 'master_repository.dart';
import 'practice_deck.dart';
import 'practice_session_screen.dart';

/// Asks before bypassing the 25-point path, then opens the same full test.
Future<bool> offerInstantMaster(
  BuildContext context, {
  required int profileId,
  required String wordId,
  required String hanzi,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text('Instant master $hanzi?'),
      content: const Text(
        'Already know this word? You can try its Master test now without collecting 25 correct points. You still need to pass the full quiz, and missed questions return at the end.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text('Not now'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: const Text('Start Master test'),
        ),
      ],
    ),
  );
  if (!context.mounted || confirmed != true) return false;
  final completed = await Navigator.of(context).push<bool>(
    MaterialPageRoute(
      builder: (_) => MasterTestScreen(
        profileId: profileId,
        wordId: wordId,
        hanzi: hanzi,
        instant: true,
      ),
    ),
  );
  return completed == true;
}

class MasterTestScreen extends ConsumerStatefulWidget {
  const MasterTestScreen({
    required this.profileId,
    required this.wordId,
    required this.hanzi,
    required this.instant,
    super.key,
  });
  final int profileId;
  final String wordId, hanzi;
  final bool instant;

  @override
  ConsumerState<MasterTestScreen> createState() => _MasterTestScreenState();
}

class _MasterTestScreenState extends ConsumerState<MasterTestScreen> {
  final _testTarget = GlobalKey();
  bool _testPassed = false, _saving = false, _done = false;
  String? _error;

  Future<void> _takeTest() async {
    final passed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => PracticeSessionScreen(
          profileId: widget.profileId,
          mode: PracticeMode.singleWord,
          wordIds: [widget.wordId],
          masterChallenge: true,
        ),
      ),
    );
    if (!mounted || passed != true) return;
    setState(() => _testPassed = true);
    await _complete();
  }

  Future<void> _complete() async {
    if (_saving || !_testPassed) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref
          .read(masterRepositoryProvider)
          .completeTest(
            profileId: widget.profileId,
            wordId: widget.wordId,
            instant: widget.instant,
          );
      if (!mounted) return;
      ref.invalidate(masteredIdsProvider(widget.profileId));
      ref.invalidate(dailyStreakProvider(widget.profileId));
      ref.invalidate(learningProgressProvider(widget.profileId));
      setState(() => _done = true);
    } catch (error) {
      if (mounted) {
        setState(
          () => _error = error is MasterConflict
              ? error.message
              : 'Could not save Master status. Try again.',
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_saving,
    child: Scaffold(
      appBar: AppBar(
        title: const AppScreenTitle('Master test'),
        actions: [
          if (!_done)
            IconButton(
              tooltip: 'Page tutorial',
              onPressed: () => showContextTour(context, [
                TourStop(
                  _testTarget,
                  'Take the full test',
                  'Answer every question. Missed questions return at the end. Passing moves this word straight into Master.',
                ),
              ]),
              icon: const Icon(Icons.help_outline),
            ),
        ],
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
                      Text(
                        widget.hanzi,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 8),
                      if (_done) ...[
                        Text(
                          'Mastered!',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'This word is now in Master. You can practice it anytime.',
                        ),
                        const SizedBox(height: 20),
                        FilledButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Done'),
                        ),
                      ] else if (!_testPassed) ...[
                        const Text(
                          'Complete the full word test. Missed questions return at the end.',
                        ),
                        const SizedBox(height: 18),
                        FilledButton(
                          key: _testTarget,
                          onPressed: _takeTest,
                          child: const Text('Start full word test'),
                        ),
                      ] else ...[
                        const Text('Test passed. Saving Master status…'),
                        const SizedBox(height: 16),
                        FilledButton(
                          key: _testTarget,
                          onPressed: _saving ? null : _complete,
                          child: Text(_saving ? 'Saving…' : 'Finish mastering'),
                        ),
                      ],
                      if (_error != null) ...[
                        const SizedBox(height: 10),
                        Text(_error!, key: const ValueKey('master-test-error')),
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
