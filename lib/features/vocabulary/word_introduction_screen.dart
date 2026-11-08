import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/learning_card.dart';
import '../review/word_quiz_entry.dart';
import 'vocabulary_repository.dart';
import 'sentence_audio.dart';
import 'word_teaching.dart';

class WordIntroductionScreen extends ConsumerWidget {
  const WordIntroductionScreen({
    required this.word,
    required this.showPinyin,
    required this.profileId,
    super.key,
  });
  final CatalogueWord word;
  final bool showPinyin;
  final int profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entry = word.entry;
    final audioSession = ref.watch(sentenceAudioSessionProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meet a word'),
        actions: [
          IconButton(
            tooltip: 'Sources and pronunciation information',
            icon: const Icon(Icons.info_outline),
            onPressed: () => showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Sources and pronunciation'),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(entry.source),
                      Text(entry.license),
                      if (word.teaching.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        const Text(
                          'Dictionary: Free Mandarin Learner\'s Dictionary (FMLD), based on English Wiktionary and CC-CEDICT. CC BY-SA 4.0. Selected modern senses matched by Hanzi and pronunciation; simplified display and grouped meanings are adaptations. Related-word suggestions and sense prioritization may be AI-assisted in the source. Independent language review pending.',
                        ),
                        const SelectableText('https://github.com/jiong3/fmld'),
                      ],
                      Text('Review: ${entry.reviewedBy} / ${entry.reviewedOn}'),
                      Text('Content revision: ${word.revision}'),
                      const SizedBox(height: 12),
                      const Text(
                        'Word audio and examples without recordings use device Mandarin speech. Bundled sentence recordings are also synthesized speech. Generated pronunciation can be imperfect, especially for words with multiple readings. Pinyin shows dictionary tones; tones can change in connected speech.',
                      ),
                      for (final example in entry.examples) ...[
                        const SizedBox(height: 12),
                        if (example.sourceId != null)
                          Text('Example: ${example.sourceId}'),
                        if (example.credit != null) Text(example.credit!),
                        if (example.sourceUrl != null)
                          SelectableText(example.sourceUrl!),
                        if (example.translationSourceUrl != null)
                          SelectableText(example.translationSourceUrl!),
                        if (example.annotation != null)
                          Text(example.annotation!),
                      ],
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
                      SpeechAudioControls(
                        session: audioSession,
                        id: 'word:${entry.id}',
                        text: entry.hanzi,
                        word: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (word.teaching.isNotEmpty) ...[
                  WordTeaching(senses: word.teaching),
                  const SizedBox(height: 20),
                ],
                Text(
                  entry.examples.length == 5
                      ? 'Five examples'
                      : 'Available examples (${entry.examples.length})',
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
                        if (entry.examples[i].audio case final clip?) ...[
                          const SizedBox(height: 12),
                          SentenceAudioControls(
                            session: audioSession,
                            clip: clip,
                          ),
                        ] else ...[
                          const SizedBox(height: 12),
                          SpeechAudioControls(
                            session: audioSession,
                            id: 'example:${entry.id}:$i',
                            text: entry.examples[i].hanzi,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                if (entry.questions.isNotEmpty)
                  WordQuizEntry(
                    profileId: profileId,
                    wordId: entry.id,
                    questionCount: entry.questions.length,
                    beforeQuiz: audioSession.stop,
                  )
                else
                  const Text(
                    'Quiz activities are not available for this word yet.',
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
