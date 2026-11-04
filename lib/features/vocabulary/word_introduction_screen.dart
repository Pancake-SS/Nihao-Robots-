import 'package:flutter/material.dart';

import '../../shared/learning_card.dart';
import 'vocabulary_repository.dart';

class WordIntroductionScreen extends StatelessWidget {
  const WordIntroductionScreen({
    required this.word,
    required this.showPinyin,
    super.key,
  });
  final CatalogueWord word;
  final bool showPinyin;

  @override
  Widget build(BuildContext context) {
    final entry = word.entry;
    return Scaffold(
      appBar: AppBar(title: const Text('Meet a word')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 820),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LearningCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.hanzi,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      if (showPinyin)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            entry.pinyin,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                      const SizedBox(height: 12),
                      Text(entry.meaning),
                      const SizedBox(height: 20),
                      const Text('Audio unavailable for this word.'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Five examples',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                for (var i = 0; i < entry.examples.length; i++) ...[
                  const SizedBox(height: 12),
                  LearningCard(
                    key: ValueKey('word-example-$i'),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Example ${i + 1}'),
                        const SizedBox(height: 8),
                        Text(
                          entry.examples[i].hanzi,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        if (showPinyin)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(entry.examples[i].pinyin),
                          ),
                        const SizedBox(height: 8),
                        Text(entry.examples[i].meaning),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                const Text(
                  'Quiz activities are coming next. Reading this page does not record a learned word or mastery.',
                ),
                const SizedBox(height: 16),
                ExpansionTile(
                  title: const Text('Content source and review'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(entry.source),
                          const SizedBox(height: 8),
                          Text(entry.license),
                          const SizedBox(height: 8),
                          Text(
                            'Review: ${entry.reviewedBy} · ${entry.reviewedOn}',
                          ),
                          Text('Content revision: ${word.revision}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
