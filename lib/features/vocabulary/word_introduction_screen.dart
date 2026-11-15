import 'package:flutter/material.dart';

import '../../shared/app_brand.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../shared/cozy_ui.dart';
import '../../shared/robot_art.dart';
import '../../shared/learning_card.dart';
import '../../shared/ui_art.dart';
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
        title: const AppScreenTitle('Meet a word'),
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
      body: WarmPageBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 820),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LearningCard(
                    background: const Color(0xFFFFF1D5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Expanded(
                              child: Text(
                                'A NEW WORD TO DISCOVER',
                                style: TextStyle(
                                  letterSpacing: 1.4,
                                  fontSize: 10,
                                  color: AppColors.mutedInk,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            UiArt(
                              art: UiArtwork.hanziTile,
                              width: 37,
                              height: 37,
                              opacity: .78,
                            ),
                          ],
                        ),
                        const SizedBox(height: 7),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                entry.hanzi,
                                style: const TextStyle(
                                  fontSize: 47,
                                  fontWeight: FontWeight.w900,
                                  height: 1.25,
                                ),
                              ),
                            ),
                            const RobotArt(
                              artwork: RobotArtwork.tallOnPaper,
                              size: 105,
                            ),
                          ],
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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          entry.examples.length == 5
                              ? 'Five examples'
                              : 'Available examples (${entry.examples.length})',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      const UiArt(
                        art: UiArtwork.openBook,
                        width: 58,
                        height: 43,
                        opacity: .88,
                      ),
                    ],
                  ),
                  for (var i = 0; i < entry.examples.length; i++) ...[
                    const SizedBox(height: 12),
                    LearningCard(
                      key: ValueKey('word-example-$i'),
                      background: i.isEven
                          ? AppColors.paper
                          : const Color(0xFFFFF9F0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 29,
                                height: 29,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  color: AppColors.yellow,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '${i + 1}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Example ${i + 1}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    letterSpacing: 1.1,
                                    color: AppColors.mutedInk,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
      ),
    );
  }
}
