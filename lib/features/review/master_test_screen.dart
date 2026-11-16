import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/app_brand.dart';
import '../../shared/cozy_ui.dart';
import '../../shared/learning_card.dart';
import '../vocabulary/learning_keyboard.dart';
import 'learning.dart';
import 'learning_providers.dart';
import 'master_repository.dart';
import 'practice_deck.dart';
import 'practice_session_screen.dart';
import 'master_gallery_screen.dart';

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
  final _writing = TextEditingController();
  final _writingId = newAttemptId();
  late final String _prompt;
  bool _testPassed = false, _saving = false, _done = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _prompt = MasterPrompts.choose(widget.hanzi);
  }

  @override
  void dispose() {
    _writing.dispose();
    super.dispose();
  }

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
    if (mounted && passed == true) setState(() => _testPassed = true);
  }

  Future<void> _save() async {
    if (_saving || _writing.text.trim().isEmpty) {
      setState(() => _error = 'Write something using the word first.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref
          .read(masterRepositoryProvider)
          .completeTest(
            writingId: _writingId,
            profileId: widget.profileId,
            wordId: widget.wordId,
            prompt: _prompt,
            sentence: _writing.text,
            instant: widget.instant,
          );
      if (!mounted) return;
      ref.invalidate(masteredIdsProvider(widget.profileId));
      ref.invalidate(learningProgressProvider(widget.profileId));
      setState(() {
        _saving = false;
        _done = true;
      });
    } catch (e) {
      if (mounted)
        setState(() {
          _saving = false;
          _error = e is MasterConflict
              ? e.message
              : 'Could not save Master status. Try again.';
        });
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_saving,
    child: Scaffold(
      appBar: AppBar(title: const AppScreenTitle('Master test')),
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
                          'Your writing is saved in this word’s gallery.',
                        ),
                        const SizedBox(height: 12),
                        Text(_prompt),
                        Text(_writing.text),
                        const SizedBox(height: 20),
                        FilledButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => MasterGalleryDetailScreen(
                                profileId: widget.profileId,
                                wordId: widget.wordId,
                                hanzi: widget.hanzi,
                              ),
                            ),
                          ),
                          child: const Text('View writing gallery'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Done'),
                        ),
                      ] else if (!_testPassed) ...[
                        const Text(
                          'Step 1 of 2 · Complete the full word test. Missed questions return at the end.',
                        ),
                        const SizedBox(height: 18),
                        FilledButton(
                          onPressed: _takeTest,
                          child: const Text('Start full word test'),
                        ),
                      ] else ...[
                        const Text(
                          'Step 2 of 2 · Write something using this word. This part is not graded.',
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _prompt,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        LearningKeyboard(
                          hanzi: _writing,
                          enabled: !_saving,
                          hanziLabel: 'Your writing',
                          hanziHint: 'Write here using the word',
                          hanziMaxLength: 1000,
                          hanziMaxLines: 5,
                          onHanziChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 12),
                        FilledButton(
                          onPressed: _saving ? null : _save,
                          child: Text(
                            _saving ? 'Saving…' : 'Save and master word',
                          ),
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
