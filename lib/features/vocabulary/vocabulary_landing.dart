import 'package:flutter/material.dart';

import '../../shared/learning_card.dart';
import '../../shared/robot_art.dart';
import 'vocabulary_catalogue_screen.dart';

class VocabularyLanding extends StatelessWidget {
  const VocabularyLanding({
    required this.targets,
    required this.showPinyin,
    super.key,
  });
  final List<GlobalKey> targets;
  final bool showPinyin;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'One word, many connections',
        style: Theme.of(context).textTheme.headlineLarge,
      ),
      const SizedBox(height: 12),
      const Text(
        'Learn a word in context, revisit it over time, and build independent recall. Vocabulary activities are being prepared.',
      ),
      const SizedBox(height: 24),
      LayoutBuilder(
        builder: (context, constraints) {
          final wide =
              constraints.maxWidth >= 850 &&
              MediaQuery.textScalerOf(context).scale(16) <= 24;
          final cards = [
            _StackCard(
              key: targets[0],
              title: 'Learn',
              artwork: RobotArtwork.hoverOnPaper,
              description: 'Meet new words through characters, meaning and checked examples.',
              status: 'Word lessons coming next',
              action: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) =>
                      VocabularyCatalogueScreen(showPinyin: showPinyin),
                ),
              ),
            ),
            _StackCard(
              key: targets[1],
              title: 'Practice',
              artwork: RobotArtwork.orbOnPaper,
              description: 'Return to vocabulary through scheduled reviews and varied recall.',
              status: 'Review activities coming next',
            ),
            _StackCard(
              key: targets[2],
              title: 'Master',
              artwork: RobotArtwork.gogglesOnPaper,
              description: 'Build evidence across time and different tasks. Quick clicks are not mastery.',
              status: 'Mastery activities coming later',
            ),
          ];
          return wide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < cards.length; i++) ...[
                      if (i > 0) const SizedBox(width: 16),
                      Expanded(child: cards[i]),
                    ],
                  ],
                )
              : Column(
                  children: [
                    for (final card in cards) ...[
                      card,
                      const SizedBox(height: 16),
                    ],
                  ],
                );
        },
      ),
    ],
  );
}

class _StackCard extends StatelessWidget {
  const _StackCard({
    required this.title,
    required this.artwork,
    required this.description,
    required this.status,
    this.action,
    super.key,
  });
  final String title;
  final RobotArtwork artwork;
  final String description;
  final String status;
  final VoidCallback? action;

  @override
  Widget build(BuildContext context) => LearningCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(child: RobotArt(artwork: artwork, size: 140)),
        const SizedBox(height: 16),
        Text(title, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 12),
        Text(description),
        const SizedBox(height: 20),
        Text(status, style: const TextStyle(fontWeight: FontWeight.w600)),
        if (action != null) ...[
          const SizedBox(height: 16),
          FilledButton(onPressed: action, child: const Text('Browse words')),
        ],
      ],
    ),
  );
}
