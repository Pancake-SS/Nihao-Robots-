import 'package:flutter/material.dart';

import '../app/theme.dart';
import 'robot_art.dart';
import 'ui_art.dart';

class VocabularyStackCard extends StatelessWidget {
  const VocabularyStackCard({
    required this.title,
    required this.label,
    required this.color,
    required this.background,
    required this.icon,
    required this.artwork,
    required this.description,
    required this.status,
    required this.actionLabel,
    this.action,
    super.key,
  });
  final String title, label, description, status, actionLabel;
  final Color color, background;
  final IconData icon;
  final RobotArtwork artwork;
  final VoidCallback? action;

  UiArtwork get _smallAccent => switch (title) {
    'Learn' => UiArtwork.vocabularyFlashcards,
    'Practice' => UiArtwork.brainNetwork,
    'Master' => UiArtwork.milestonePagoda,
    _ => UiArtwork.openBook,
  };

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 378),
    decoration: BoxDecoration(
      color: AppColors.paper,
      borderRadius: BorderRadius.circular(25),
      border: Border.all(color: AppColors.border),
      boxShadow: const [
        BoxShadow(
          color: Color(0x120F2943),
          blurRadius: 20,
          offset: Offset(0, 7),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.navy, size: 22),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        color: AppColors.mutedInk,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              UiArt(art: _smallAccent, width: 58, height: 55, opacity: .95),
            ],
          ),
          const SizedBox(height: 11),
          Container(
            height: 130,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(19),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 13,
                  right: 18,
                  child: Icon(
                    Icons.auto_awesome,
                    size: 25,
                    color: color.withValues(alpha: .9),
                  ),
                ),
                Center(child: RobotArt(artwork: artwork, size: 125)),
                Positioned(
                  bottom: 9,
                  left: 15,
                  child: Icon(
                    Icons.spa_outlined,
                    color: AppColors.leaf,
                    size: 23,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            description,
            maxLines: 3,
            style: const TextStyle(
              fontSize: 12.5,
              color: AppColors.mutedInk,
              height: 1.36,
            ),
          ),
          const SizedBox(height: 13),
          Text(
            status,
            maxLines: 2,
            style: const TextStyle(
              fontSize: 11.5,
              color: AppColors.navy,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 13),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: action,
              style: FilledButton.styleFrom(
                backgroundColor: color,
                foregroundColor: AppColors.navy,
                disabledBackgroundColor: background,
                disabledForegroundColor: AppColors.mutedInk,
              ),
              icon: Icon(
                action == null ? Icons.schedule : Icons.arrow_forward_rounded,
                size: 18,
              ),
              label: Text(actionLabel),
            ),
          ),
        ],
      ),
    ),
  );
}
