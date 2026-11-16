import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/app_brand.dart';
import '../../shared/cozy_ui.dart';
import '../../shared/learning_card.dart';
import '../vocabulary/vocabulary_repository.dart';
import 'master_repository.dart';
import 'practice_deck.dart';
import 'practice_session_screen.dart';

class MasterGalleryScreen extends ConsumerStatefulWidget {
  const MasterGalleryScreen({required this.profileId, super.key});
  final int profileId;
  @override
  ConsumerState<MasterGalleryScreen> createState() =>
      _MasterGalleryScreenState();
}

class _MasterGalleryScreenState extends ConsumerState<MasterGalleryScreen> {
  int _page = 0;
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
                final page = sorted.skip(_page * 20).take(20);
                return ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Text(
                      '${sorted.length} mastered words',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Open a word to see the writing you saved when you mastered it.',
                    ),
                    const SizedBox(height: 16),
                    if (ids.isEmpty)
                      const LearningCard(
                        child: Text(
                          'No mastered words yet. Take a Master test when a word reaches 25 points, or choose Instant master.',
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
                          subtitle: const Text('Writing gallery'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () async {
                            final word = await ref.read(
                              vocabularyLessonProvider(id).future,
                            );
                            if (!context.mounted || word == null) return;
                            await Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => MasterGalleryDetailScreen(
                                  profileId: widget.profileId,
                                  wordId: id,
                                  hanzi: word.entry.hanzi,
                                ),
                              ),
                            );
                            if (mounted)
                              ref.invalidate(
                                masteredIdsProvider(widget.profileId),
                              );
                          },
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
                            onPressed: (_page + 1) * 20 >= sorted.length
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

class MasterGalleryDetailScreen extends ConsumerStatefulWidget {
  const MasterGalleryDetailScreen({
    required this.profileId,
    required this.wordId,
    required this.hanzi,
    super.key,
  });
  final int profileId;
  final String wordId, hanzi;
  @override
  ConsumerState<MasterGalleryDetailScreen> createState() =>
      _MasterGalleryDetailScreenState();
}

class _MasterGalleryDetailScreenState
    extends ConsumerState<MasterGalleryDetailScreen> {
  late Future<List<MasterWriting>> _writings;
  @override
  void initState() {
    super.initState();
    _writings = ref
        .read(masterRepositoryProvider)
        .writings(widget.profileId, widget.wordId);
  }

  @override
  Widget build(BuildContext context) {
    final mastered = ref.watch(masteredIdsProvider(widget.profileId));
    final stillMastered =
        mastered.asData?.value.contains(widget.wordId) == true;
    return Scaffold(
      appBar: AppBar(title: const AppScreenTitle('Writing gallery')),
      body: WarmPageBackground(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 780),
            child: FutureBuilder<List<MasterWriting>>(
              future: _writings,
              builder: (context, snapshot) => ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Text(
                    widget.hanzi,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(stillMastered ? 'Mastered word' : 'Writing history'),
                  const SizedBox(height: 16),
                  if (stillMastered)
                    FilledButton(
                      onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => PracticeSessionScreen(
                              profileId: widget.profileId,
                              mode: PracticeMode.singleWord,
                              wordIds: [widget.wordId],
                              masterPractice: true,
                            ),
                          ),
                        );
                        if (mounted)
                          ref.invalidate(masteredIdsProvider(widget.profileId));
                      },
                      child: const Text('Practice this mastered word'),
                    ),
                  const SizedBox(height: 12),
                  if (snapshot.connectionState != ConnectionState.done)
                    const LinearProgressIndicator()
                  else if (snapshot.hasError)
                    TextButton(
                      onPressed: () => setState(
                        () => _writings = ref
                            .read(masterRepositoryProvider)
                            .writings(widget.profileId, widget.wordId),
                      ),
                      child: const Text('Reload writing gallery'),
                    )
                  else if (snapshot.data!.isEmpty)
                    const LearningCard(
                      child: Text('No writing saved for this word yet.'),
                    )
                  else
                    for (final writing in snapshot.data!) ...[
                      LearningCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              writing.prompt,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 12),
                            SelectableText(writing.sentence),
                            const SizedBox(height: 12),
                            Text(
                              MaterialLocalizations.of(
                                context,
                              ).formatMediumDate(writing.writtenAt.toLocal()),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
