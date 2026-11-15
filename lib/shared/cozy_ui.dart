import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../app/theme.dart';
import 'robot_art.dart';
import 'ui_art.dart';

/// Reusable illustrated header. All copy and buttons remain real Flutter UI.
/// Scenery is vector decoration, not a screenshot of the PowerPoint.
class SunnyHero extends StatelessWidget {
  const SunnyHero({
    required this.title,
    required this.subtitle,
    this.robot = RobotArtwork.wavingOnPaper,
    this.tag,
    super.key,
  });

  final String title;
  final String subtitle;
  final RobotArtwork robot;
  final String? tag;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final compact = constraints.maxWidth < 550;
      return ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: SizedBox(
          height: compact ? 178 : 208,
          child: Stack(
            children: [
              const Positioned.fill(
                child: CustomPaint(painter: _SunnyPainter()),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFF2E9D7),
                        const Color(0xFFEDE5D7).withValues(alpha: .95),
                        const Color(0xFFEDE5D7).withValues(alpha: .06),
                      ],
                      stops: const [0, .48, 1],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: compact ? 19 : 34,
                right: compact ? 118 : 220,
                top: compact ? 20 : 31,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (tag != null)
                      Text(
                        tag!.toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.mutedInk,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2,
                          fontSize: 10,
                        ),
                      ),
                    const SizedBox(height: 5),
                    Text(
                      title,
                      style: TextStyle(
                        color: AppColors.deepNavy,
                        fontSize: compact ? 28 : 42,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                        height: 1.12,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Text(
                      subtitle,
                      maxLines: compact ? 3 : 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: compact ? 12 : 15,
                        color: AppColors.mutedInk,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: compact ? 9 : 32,
                bottom: compact ? 5 : 2,
                child: RobotArt(artwork: robot, size: compact ? 116 : 172),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    required this.title,
    this.caption,
    this.icon = Icons.auto_awesome_outlined,
    this.art,
    this.action,
    super.key,
  });
  final String title;
  final String? caption;
  final IconData icon;
  final UiArtwork? art;
  final Widget? action;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final narrow =
          constraints.maxWidth < 430 ||
          MediaQuery.textScalerOf(context).scale(16) > 24;
      final heading = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 39,
            width: 39,
            decoration: BoxDecoration(
              color: AppColors.sky,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.navy, size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                if (caption != null)
                  Text(
                    caption!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.mutedInk,
                    ),
                  ),
              ],
            ),
          ),
          if (art != null && !narrow) ...[
            const SizedBox(width: 8),
            UiArt(art: art!, width: 56, height: 47, opacity: .90),
          ],
          if (action != null && !narrow) action!,
        ],
      );
      return narrow && action != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [heading, const SizedBox(height: 8), action!],
            )
          : heading;
    },
  );
}

class WarmPageBackground extends StatelessWidget {
  const WarmPageBackground({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFE9E5D9), Color(0xFFE0DED5), Color(0xFFD9DED7)],
      ),
    ),
    child: child,
  );
}

class NightStudyScene extends StatelessWidget {
  const NightStudyScene({super.key});
  @override
  Widget build(BuildContext context) =>
      const CustomPaint(painter: _NightPainter(), child: SizedBox.expand());
}

class _SunnyPainter extends CustomPainter {
  const _SunnyPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final r = Offset.zero & size;
    canvas.drawRect(
      r,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFA4C5CF), Color(0xFFD2E2DE), Color(0xFFE6D0B1)],
        ).createShader(r),
    );
    canvas.drawCircle(
      Offset(w * .79, h * .23),
      h * .20,
      Paint()..color = const Color(0x77FFF8D4),
    );
    for (final p in [Offset(.48, .20), Offset(.66, .33), Offset(.87, .17)]) {
      final c = Offset(w * p.dx, h * p.dy);
      canvas.drawOval(
        Rect.fromCenter(center: c, width: 77, height: 19),
        Paint()..color = const Color(0xC7FFFFFF),
      );
      canvas.drawCircle(
        c.translate(-20, -8),
        15,
        Paint()..color = const Color(0xC7FFFFFF),
      );
      canvas.drawCircle(
        c.translate(6, -13),
        20,
        Paint()..color = const Color(0xC7FFFFFF),
      );
    }
    final distant = Path()
      ..moveTo(0, h * .82)
      ..quadraticBezierTo(w * .40, h * .42, w * .63, h * .75)
      ..quadraticBezierTo(w * .87, h * .43, w, h * .66)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(distant, Paint()..color = const Color(0xFF9EBFBD));
    final front = Path()
      ..moveTo(0, h * .90)
      ..quadraticBezierTo(w * .36, h * .75, w * .61, h * .87)
      ..quadraticBezierTo(w * .86, h * .62, w, h * .83)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(front, Paint()..color = const Color(0xFFB5CD88));
    // Tiny decorative pagoda in the sunny garden.
    final x = w * .73;
    final y = h * .71;
    final roof = Path()
      ..moveTo(x - 31, y - 7)
      ..lineTo(x, y - 28)
      ..lineTo(x + 31, y - 7)
      ..lineTo(x + 22, y - 5)
      ..lineTo(x - 23, y - 5)
      ..close();
    canvas.drawPath(roof, Paint()..color = const Color(0xFF8F796A));
    canvas.drawRect(
      Rect.fromLTWH(x - 18, y - 4, 36, 29),
      Paint()..color = const Color(0xFFF6E4BD),
    );
    canvas.drawRect(
      Rect.fromLTWH(x - 4, y + 6, 8, 19),
      Paint()..color = const Color(0xFF977B6C),
    );
    for (var i = 0; i < 22; i++) {
      final px = w * (.46 + .54 * (i / 22));
      final py = h * (.90 + .045 * math.sin(i * 2.4));
      canvas.drawCircle(
        Offset(px, py),
        i % 4 == 0 ? 6 : 3,
        Paint()
          ..color = i % 3 == 0
              ? const Color(0xFFFFF1AE)
              : const Color(0xFFE9F2C0),
      );
      if (i % 4 == 0)
        canvas.drawCircle(
          Offset(px, py),
          2,
          Paint()..color = const Color(0xFFF5B663),
        );
    }
    // Window mullion and a faint sunlit sill give the room its warm feel.
    canvas.drawRect(
      Rect.fromLTWH(w * .43, 0, 5, h * .79),
      Paint()..color = const Color(0x88FFF8EE),
    );
    canvas.drawRect(
      Rect.fromLTWH(0, h * .97, w, h * .03),
      Paint()..color = const Color(0x55B78E61),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _NightPainter extends CustomPainter {
  const _NightPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F1B34), Color(0xFF1D2B4C), Color(0xFF334068)],
        ).createShader(rect),
    );
    final window = Rect.fromLTWH(w * .55, h * .12, w * .35, h * .56);
    canvas.drawRRect(
      RRect.fromRectAndRadius(window, const Radius.circular(16)),
      Paint()..color = const Color(0xFF12203B),
    );
    canvas.drawCircle(
      Offset(w * .79, h * .27),
      24,
      Paint()..color = const Color(0xFFFFE8A6),
    );
    canvas.drawCircle(
      Offset(w * .802, h * .25),
      22,
      Paint()..color = const Color(0xFF12203B),
    );
    for (var i = 0; i < 19; i++) {
      final x = w * (.56 + (i * 37 % 33) / 100);
      final y = h * (.15 + (i * 19 % 43) / 100);
      canvas.drawCircle(
        Offset(x, y),
        i % 3 == 0 ? 2 : 1,
        Paint()..color = const Color(0x99FFE8A6),
      );
    }
    final line = Paint()
      ..color = const Color(0xFF506183)
      ..strokeWidth = 7;
    canvas.drawLine(Offset(w * .72, h * .12), Offset(w * .72, h * .68), line);
    canvas.drawLine(Offset(w * .55, h * .42), Offset(w * .9, h * .42), line);
    canvas.drawRect(
      Rect.fromLTWH(0, h * .84, w, h * .16),
      Paint()..color = const Color(0xFF534263),
    );
    canvas.drawRect(
      Rect.fromLTWH(0, h * .82, w, h * .025),
      Paint()..color = const Color(0xFFAB825F),
    );
    canvas.drawCircle(
      Offset(w * .18, h * .53),
      h * .16,
      Paint()..color = const Color(0x33FBC57F),
    );
    for (var i = 0; i < 5; i++) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(w * (.06 + i * .05), h * (.66 - i % 2 * .05)),
          width: 30,
          height: 74,
        ),
        Paint()..color = const Color(0xFF627960),
      );
    }
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * .05, h * .72, w * .2, h * .12),
        const Radius.circular(7),
      ),
      Paint()..color = const Color(0xFFBB9471),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * .72, h * .75, w * .12, h * .07),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0xFFF8D7A5),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
