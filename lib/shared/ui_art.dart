import 'package:flutter/material.dart';

/// Optional transparent layers. All labels, progress, buttons and robots are
/// still native widgets; these drawings never intercept taps or semantics.
enum UiArtwork {
  vocabularyFlashcards('assets/ui_art/vocabulary_flashcards.png'),
  fluencyJourney('assets/ui_art/fluency_journey.png'),
  cherryBlossom('assets/ui_art/corner_cherry_blossom.png'),
  milestonePagoda('assets/ui_art/milestone_pagoda.png'),
  openBook('assets/ui_art/decorative_open_book.png'),
  brainNetwork('assets/ui_art/accent_brain_network.png'),
  hanziTile('assets/ui_art/accent_hanzi_tile.png'),
  studyRobotReading('assets/ui_art/study_robot_reading.png'),
  studyRobotGreeting('assets/ui_art/study_robot_greeting.png');

  const UiArtwork(this.path);
  final String path;
}

class UiArt extends StatelessWidget {
  const UiArt({
    required this.art,
    required this.width,
    required this.height,
    this.opacity = 1,
    this.alignment = Alignment.center,
    super.key,
  });

  final UiArtwork art;
  final double width;
  final double height;
  final double opacity;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    ignoring: true,
    child: Opacity(
      opacity: opacity,
      child: Image.asset(
        art.path,
        width: width,
        height: height,
        fit: BoxFit.contain,
        alignment: alignment,
        filterQuality: FilterQuality.medium,
        excludeFromSemantics: true,
      ),
    ),
  );
}

/// Faint, clipped corner art behind an existing card's interactive content.
/// Hide on narrow cards so the artwork never crowds text or controls.
class ArtBackplate extends StatelessWidget {
  const ArtBackplate({
    required this.child,
    required this.art,
    this.width = 180,
    this.height = 140,
    this.opacity = .16,
    this.minWidth = 440,
    super.key,
  });

  final Widget child;
  final UiArtwork art;
  final double width;
  final double height;
  final double opacity;
  final double minWidth;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth < minWidth) return child;
      return ClipRect(
        child: Stack(
          children: [
            Positioned(
              right: 0,
              bottom: 0,
              child: UiArt(
                art: art,
                width: width,
                height: height,
                opacity: opacity,
              ),
            ),
            child,
          ],
        ),
      );
    },
  );
}
