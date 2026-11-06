import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'learning_priority.dart';
import 'vocabulary_repository.dart';
import 'word_introduction_screen.dart';
import 'word_library.dart';

class WordLibraryScreen extends ConsumerStatefulWidget {
  const WordLibraryScreen({
    required this.profileId,
    required this.showPinyin,
    super.key,
  });
  final int profileId;
  final bool showPinyin;
  @override
  ConsumerState<WordLibraryScreen> createState() => _WordLibraryScreenState();
}

class _WordLibraryScreenState extends ConsumerState<WordLibraryScreen> {
  String _query = '';
  int? _tier;
  @override
  Widget build(BuildContext context) {
    final lessons = ref.watch(vocabularyCatalogueProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Imported word library')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: ref
              .watch(wordLibraryProvider)
              .when(
                loading: () => const CircularProgressIndicator(
                  semanticsLabel: 'Loading dictionary',
                ),
                error: (_, _) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Could not load the dictionary. Your progress is unchanged.',
                    ),
                    TextButton(
                      onPressed: () => ref.invalidate(wordLibraryProvider),
                      child: const Text('Try again'),
                    ),
                  ],
                ),
                data: (library) {
                  final visible = library.words
                      .where(
                        (w) =>
                            (_tier == null || w.priority.tier == _tier) &&
                            w.matches(_query),
                      )
                      .toList();
                  final available = {
                    for (final lesson
                        in lessons.asData?.value ?? <CatalogueWord>[])
                      lesson.entry.id: lesson,
                  };
                  return CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              TextField(
                                key: const ValueKey('dictionary-search'),
                                decoration: const InputDecoration(
                                  labelText: 'Search all imported words',
                                  prefixIcon: Icon(Icons.search),
                                ),
                                onChanged: (value) =>
                                    setState(() => _query = value),
                              ),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<int>(
                                initialValue: -1,
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  labelText: 'Learning priority',
                                ),
                                items: [
                                  const DropdownMenuItem(
                                    value: -1,
                                    child: Text(
                                      'All priorities · basics first',
                                    ),
                                  ),
                                  for (
                                    var i = 0;
                                    i < LearningPriority.labels.length;
                                    i++
                                  )
                                    DropdownMenuItem(
                                      value: i,
                                      child: Text(LearningPriority.labels[i]),
                                    ),
                                ],
                                onChanged: (value) => setState(
                                  () => _tier = value == -1 ? null : value,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${visible.length} of ${library.words.length} imported words',
                              ),
                              Text(
                                'HearMandarin · CC BY 4.0 · ${library.version}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const Text(
                                'Basics first, then source bands. Full lessons are marked when available.',
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (visible.isEmpty)
                        const SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(child: Text('No matching words.')),
                        )
                      else
                        SliverList.builder(
                          itemCount: visible.length,
                          itemBuilder: (context, index) {
                            final word = visible[index];
                            final lesson = available[word.id];
                            return Card(
                              margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      word.hanzi,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
                                    ),
                                    if (widget.showPinyin) Text(word.pinyin),
                                    Text(word.meaning),
                                    Text(
                                      '${word.priority.label}${word.band == null ? '' : ' · HSK band ${word.band}'}',
                                    ),
                                    Text(
                                      'Traditional: ${word.traditional} · ${word.partOfSpeech}',
                                    ),
                                    if (lesson != null)
                                      TextButton(
                                        onPressed: () => Navigator.of(context)
                                            .push(
                                              MaterialPageRoute<void>(
                                                builder: (_) =>
                                                    WordIntroductionScreen(
                                                      word: lesson,
                                                      profileId:
                                                          widget.profileId,
                                                      showPinyin:
                                                          widget.showPinyin,
                                                    ),
                                              ),
                                            ),
                                        child: const Text('Open full lesson'),
                                      )
                                    else
                                      const Text(
                                        'Dictionary entry · example lesson pending review',
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  );
                },
              ),
        ),
      ),
    );
  }
}
