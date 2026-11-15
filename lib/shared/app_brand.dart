import 'package:flutter/material.dart';

import '../app/theme.dart';

/// The supplied robot-head artwork is kept intact. Dark surfaces use an
/// alternate PNG with a thin external cream contour (not a recoloring filter).
class AppRobotLogo extends StatelessWidget {
  const AppRobotLogo({this.size = 40, this.invertOnDark = false, super.key});

  final double size;
  final bool invertOnDark;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: size,
    height: size,
    child: Center(
      child: Image.asset(
        invertOnDark
            ? 'assets/branding/nihao_robot_head_on_dark.png'
            : 'assets/branding/nihao_robot_head.png',
        width: size,
        height: size,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
        semanticLabel: 'Ni Hao Robot mascot logo',
      ),
    ),
  );
}

class AppBrandRow extends StatelessWidget {
  const AppBrandRow({
    this.onDark = false,
    this.size = 40,
    this.showTagline = false,
    super.key,
  });

  final bool onDark;
  final double size;
  final bool showTagline;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      AppRobotLogo(size: size, invertOnDark: onDark),
      const SizedBox(width: 10),
      Flexible(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'NI HAO ROBOT!',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: onDark ? Colors.white : AppColors.deepNavy,
                fontSize: 16,
                height: 1.0,
                fontWeight: FontWeight.w900,
                letterSpacing: -.3,
              ),
            ),
            if (showTagline) ...[
              const SizedBox(height: 3),
              Text(
                'LEARNING SPACE',
                style: TextStyle(
                  color: onDark ? const Color(0xFFAEBBD0) : AppColors.mutedInk,
                  fontSize: 9,
                  letterSpacing: 1.3,
                  fontWeight: FontWeight.w800,
                  height: 1.0,
                ),
              ),
            ],
          ],
        ),
      ),
    ],
  );
}

class AppScreenTitle extends StatelessWidget {
  const AppScreenTitle(this.title, {super.key});
  final String title;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      const AppRobotLogo(size: 28),
      const SizedBox(width: 8),
      Flexible(
        child: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontFamily: 'Segoe UI',
            color: AppColors.deepNavy,
            fontWeight: FontWeight.w800,
            fontSize: 19,
            height: 1.0,
          ),
        ),
      ),
    ],
  );
}
