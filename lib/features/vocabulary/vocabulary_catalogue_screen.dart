import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'vocabulary_repository.dart';
import 'word_introduction_screen.dart';
import 'word_library_screen.dart';

class VocabularyCatalogueScreen extends ConsumerStatefulWidget {
  const VocabularyCatalogueScreen({
    required this.showPinyin,
    required this.profileId,
    super.key,
  });
  final bool showPinyin;
  final int profileId;
  @override
  ConsumerState<VocabularyCatalogueScreen> createState() =>
      _VocabularyCatalogueScreenState();
}

class _VocabularyCatalogueScreenState
    extends ConsumerState<VocabularyCatalogueScreen> {
  String _query = '';
  bool _matches(CatalogueWord word) {
    final entry = word.entry;
    final query = _query.trim().toLowerCase();
    return query.isEmpty ||
        [
          entry.hanzi,
          entry.pinyin,
          entry.meaning,
          entry.details?.traditional ?? '',
          entry.details?.pinyinNumbered ?? '',
          entry.details?.pinyinNumbered.replaceAll(RegExp(r'[1-5\s]'), '') ??
              '',
        ].any((text) => text.toLowerCase().contains(query));
  }

  Future<void> _attribution() async {
    final text = await rootBundle.loadString('assets/content/ATTRIBUTION.txt');
    if (!mounted) return;
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Content attribution'),
        content: SingleChildScrollView(child: SelectableText(text)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Learn a word'),
      actions: [
        IconButton(
          tooltip: 'Browse all imported words',
          icon: const Icon(Icons.menu_book_outlined),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => WordLibraryScreen(
                profileId: widget.profileId,
                showPinyin: widget.showPinyin,
              ),
            ),
          ),
        ),
        IconButton(
          tooltip: 'Content attribution',
          onPressed: _attribution,
          icon: const Icon(Icons.info_outline),
        ),
      ],
    ),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: ref
            .watch(vocabularyCatalogueProvider)
            .when(
              loading: () => const Center(
                child: CircularProgressIndicator(
                  semanticsLabel: 'Loading words',
                ),
              ),
              error: (_, _) => ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  const Text(
                    'Could not load the word list. Your saved progress has not changed.',
                  ),
                  TextButton(
                    onPressed: () =>
                        ref.invalidate(vocabularyCatalogueProvider),
                    child: const Text('Try again'),
                  ),
                ],
              ),
              data: (words) {
                if (words.isEmpty)
                  return ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      Text(
                        'Your first words are on their way',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'The starter lessons are being checked for language accuracy and source permissions. No word lessons are available yet.',
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'You can return to Home to explore or replay the introduction.',
                      ),
                    ],
                  );
                final visible = words.where(_matches).toList();
                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          TextButton.icon(
                            icon: const Icon(Icons.menu_book_outlined),
                            label: const Text(
                              'Browse full imported word library',
                            ),
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => WordLibraryScreen(
                                  profileId: widget.profileId,
                                  showPinyin: widget.showPinyin,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                            child: TextField(
                              key: const ValueKey('word-search'),
                              decoration: const InputDecoration(
                                labelText: 'Search Hanzi, Pinyin or English',
                                prefixIcon: Icon(Icons.search),
                              ),
                              onChanged: (value) =>
                                  setState(() => _query = value),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 8,
                            ),
                            child: Text(
                              '${visible.length} of ${words.length} lessons · basics first',
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (visible.isEmpty)
                      const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Text('No matching words. Try another search.'),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.all(24),
                        sliver: SliverList.separated(
                          itemCount: visible.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final word = visible[index];
                            return Card(
                              key: ValueKey('catalogue-${word.entry.id}'),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      word.entry.hanzi,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
                                    ),
                                    if (widget.showPinyin)
                                      Text(word.entry.pinyin),
                                    const SizedBox(height: 8),
                                    Text(word.entry.meaning),
                                    if (word.entry.details?.learningPriority
                                        case final priority?)
                                      Text(priority.label),
                                    if (word.entry.questions.isNotEmpty)
                                      Text(
                                        '${word.entry.questions.length} questions',
                                      ),
                                    const SizedBox(height: 12),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: FilledButton(
                                        onPressed: () => Navigator.of(context)
                                            .push(
                                              MaterialPageRoute<void>(
                                                builder: (_) =>
                                                    WordIntroductionScreen(
                                                      word: word,
                                                      showPinyin:
                                                          widget.showPinyin,
                                                      profileId:
                                                          widget.profileId,
                                                    ),
                                              ),
                                            ),
                                        child: const Text('Explore word'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                );
              },
            ),
      ),
    ),
  );
}
