import 'package:flutter/widgets.dart';

/// Original robot drawings (derived transparent-ink versions for light panels).
/// White-line versions are used only on dark backgrounds.
enum RobotArtwork {
  wavingOnPaper('assets/robots/robot_05_ink.png'),
  orbOnNavy('assets/robots/robot_09_light.png'),
  trackedOnPaper('assets/robots/robot_01_ink.png'),
  gogglesOnPaper('assets/robots/robot_06_ink.png'),
  orbOnPaper('assets/robots/robot_03_ink.png'),
  hoverOnPaper('assets/robots/robot_10_ink.png'),
  tallOnPaper('assets/robots/robot_02_ink.png'),
  squareOnPaper('assets/robots/robot_04_ink.png'),
  shyOnPaper('assets/robots/robot_08_ink.png'),
  whiteTracked('assets/robots/robot_01_light.png'),
  whiteHover('assets/robots/robot_10_light.png');

  const RobotArtwork(this.assetPath);
  final String assetPath;
}

class RobotArt extends StatelessWidget {
  const RobotArt({required this.artwork, this.size = 200, super.key});
  final RobotArtwork artwork;
  final double size;

  @override
  Widget build(BuildContext context) => Image.asset(
    artwork.assetPath,
    width: size,
    height: size,
    fit: BoxFit.contain,
    filterQuality: FilterQuality.medium,
    excludeFromSemantics: true,
  );
}
