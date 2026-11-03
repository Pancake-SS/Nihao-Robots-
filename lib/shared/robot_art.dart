import 'package:flutter/widgets.dart';

/// Supplied originals only. Background and character choices are explicit.
enum RobotArtwork {
  wavingOnPaper('assets/mascots/welcome_waving_light.png'),
  orbOnNavy('assets/mascots/welcome_orb_dark.png'),
  trackedOnPaper('assets/mascots/profile_tracked_light.png'),
  gogglesOnPaper('assets/mascots/vocabulary_goggles_light.png'),
  orbOnPaper('assets/mascots/foundation_orb_light.png'),
  hoverOnPaper('assets/mascots/vocabulary_hover_light.png');

  const RobotArtwork(this.assetPath);

  final String assetPath;
}

class RobotArt extends StatelessWidget {
  const RobotArt({required this.artwork, this.size = 200, super.key});

  final RobotArtwork artwork;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      artwork.assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      excludeFromSemantics: true,
    );
  }
}
