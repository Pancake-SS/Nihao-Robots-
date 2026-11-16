import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../shared/cozy_ui.dart';
import '../../shared/vocabulary_card.dart';
import '../../shared/robot_art.dart';
import '../review/review_screen.dart';
import 'learning_queue_screen.dart';

class VocabularyLanding extends StatelessWidget {
  const VocabularyLanding({
    required this.targets,
    required this.showPinyin,
    required this.profileId,
    super.key,
  });
  final List<GlobalKey> targets;
  final bool showPinyin;
  final int profileId;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const SunnyHero(
        title: 'Vocabulary',
        subtitle: 'Grow your Chinese word bank, step by step.',
        tag: 'Three ways to grow',
        robot: RobotArtwork.wavingOnPaper,
      ),
      const SizedBox(height: 19),
      LayoutBuilder(
        builder: (context, c) {
          final wide =
              c.maxWidth >= 760 &&
              MediaQuery.textScalerOf(context).scale(16) <= 24;
          final cards = [
            VocabularyStackCard(
              key: targets[0],
              title: 'Learn',
              label: '01  ·  DISCOVER',
              color: AppColors.yellow,
              background: const Color(0xFFFFF5DB),
              icon: Icons.auto_stories_outlined,
              artwork: RobotArtwork.hoverOnPaper,
              description: 'Meet new Chinese words with meanings, pronunciation and checked examples.',
              status: 'Your next words are ready',
              actionLabel: 'Browse words',
              action: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => LearningQueueScreen(
                    showPinyin: showPinyin,
                    profileId: profileId,
                  ),
                ),
              ),
            ),
            VocabularyStackCard(
              key: targets[1],
              title: 'Practice',
              label: '02  ·  RECALL',
              color: AppColors.blue,
              background: const Color(0xFFE9F4FF),
              icon: Icons.forum_outlined,
              artwork: RobotArtwork.orbOnPaper,
              description: 'Replay a word test, choose random questions, or keep practising.',
              status: 'Ready whenever you are',
              actionLabel: 'Open practice',
              action: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => ReviewScreen(profileId: profileId),
                ),
              ),
            ),
            VocabularyStackCard(
              key: targets[2],
              title: 'Master',
              label: '03  ·  REMEMBER',
              color: AppColors.leaf,
              background: Color(0xFFEDF7E5),
              icon: Icons.star_outline_rounded,
              artwork: RobotArtwork.gogglesOnPaper,
              description: 'Strengthen lasting recall with future mastery challenges and varied tests.',
              status: 'Mastery tools in development',
              actionLabel: 'Coming soon',
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
                      const SizedBox(height: 15),
                    ],
                  ],
                );
        },
      ),
      const SizedBox(height: 18),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 7),
        child: Text(
          'Each word is a little discovery. Progress is saved per profile.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.mutedInk, fontSize: 12),
        ),
      ),
    ],
  );
}
