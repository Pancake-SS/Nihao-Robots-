import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'vocabulary_repository.dart';
import 'word_introduction_screen.dart';

class VocabularyCatalogueScreen extends ConsumerWidget {
  const VocabularyCatalogueScreen({required this.showPinyin, super.key});
  final bool showPinyin;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    appBar: AppBar(title: const Text('Learn a word')),
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
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: OutlinedButton(
                      onPressed: () =>
                          ref.invalidate(vocabularyCatalogueProvider),
                      child: const Text('Try again'),
                    ),
                  ),
                ],
              ),
              data: (words) => words.isEmpty
                  ? ListView(
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
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(24),
                      itemCount: words.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final word = words[index];
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  word.entry.hanzi,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall,
                                ),
                                if (showPinyin) Text(word.entry.pinyin),
                                const SizedBox(height: 8),
                                Text(word.entry.meaning),
                                const SizedBox(height: 12),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: FilledButton(
                                    onPressed: () => Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                        builder: (_) => WordIntroductionScreen(
                                          word: word,
                                          showPinyin: showPinyin,
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
      ),
    ),
  );
}
