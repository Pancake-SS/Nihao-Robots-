import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/app_brand.dart';
import '../../shared/cozy_ui.dart';
import '../../shared/learning_card.dart';
import '../vocabulary/vocabulary_repository.dart';
import 'master_repository.dart';
import 'practice_deck.dart';
import 'practice_session_screen.dart';

class MasteredWordsScreen extends ConsumerStatefulWidget {
  const MasteredWordsScreen({
    required this.profileId,
    required this.showPinyin,
    super.key,
  });

  final int profileId;
  final bool showPinyin;

  @override
  ConsumerState<MasteredWordsScreen> createState() =>
      _MasteredWordsScreenState();
}

class _MasteredWordsScreenState extends ConsumerState<MasteredWordsScreen> {
  int _page = 0;

  Future<void> _practice(String id) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PracticeSessionScreen(
          profileId: widget.profileId,
          mode: PracticeMode.singleWord,
          wordIds: [id],
          masterPractice: true,
        ),
      ),
    );
    if (mounted) ref.invalidate(masteredIdsProvider(widget.profileId));
  }

  @override
  Widget build(BuildContext context) {
    final saved = ref.watch(masteredIdsProvider(widget.profileId));
    return Scaffold(
      appBar: AppBar(title: const AppScreenTitle('Mastered words')),
      body: WarmPageBackground(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 820),
            child: saved.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => Center(
                child: TextButton(
                  onPressed: () =>
                      ref.invalidate(masteredIdsProvider(widget.profileId)),
                  child: const Text('Reload mastered words'),
                ),
              ),
              data: (ids) {
                final sorted = ids.toList()..sort();
                final maxPage = sorted.isEmpty ? 0 : (sorted.length - 1) ~/ 20;
                if (_page > maxPage) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) setState(() => _page = maxPage);
                  });
                }
                final page = sorted.skip(_page * 20).take(20);
                return ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Text(
                      '${sorted.length} mastered words',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 10),
                    const Text('Select a word to practice its full test.'),
                    const SizedBox(height: 16),
                    if (ids.isEmpty)
                      const LearningCard(
                        child: Text(
                          'No mastered words yet. Take a Master test when a word reaches $masterPointGoal points, or choose Instant master.',
                        ),
                      ),
                    for (final id in page)
                      Card(
                        child: ListTile(
                          key: ValueKey('mastered-word-$id'),
                          title: Text(
                            ref
                                    .watch(vocabularyLessonProvider(id))
                                    .asData
                                    ?.value
                                    ?.entry
                                    .hanzi ??
                                'Loading word…',
                          ),
                          subtitle: Text(
                            [
                              if (widget.showPinyin)
                                ref
                                        .watch(vocabularyLessonProvider(id))
                                        .asData
                                        ?.value
                                        ?.entry
                                        .pinyin ??
                                    '',
                              ref
                                      .watch(vocabularyLessonProvider(id))
                                      .asData
                                      ?.value
                                      ?.entry
                                      .meaning ??
                                  'Practice this word',
                            ].where((text) => text.isNotEmpty).join(' · '),
                          ),
                          trailing: const Icon(Icons.play_arrow_outlined),
                          onTap: () => _practice(id),
                        ),
                      ),
                    if (sorted.length > 20)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: _page == 0
                                ? null
                                : () => setState(() => _page--),
                            child: const Text('Previous 20'),
                          ),
                          Text('Page ${_page + 1}'),
                          TextButton(
                            onPressed: _page >= maxPage
                                ? null
                                : () => setState(() => _page++),
                            child: const Text('Next 20'),
                          ),
                        ],
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
