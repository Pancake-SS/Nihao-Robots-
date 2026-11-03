import 'package:flutter/material.dart';

import '../app/theme.dart';

class TourStop {
  const TourStop(this.target, this.title, this.description);
  final GlobalKey target;
  final String title;
  final String description;
}

/// Spotlights live widgets, scrolling each target into view before opening.
/// Dialog focus traversal, Escape, Back/Next and Close work without a pointer.
Future<void> showContextTour(BuildContext context, List<TourStop> stops) async {
  var index = 0;
  while (context.mounted && index >= 0 && index < stops.length) {
    final stopIndex = index;
    final stop = stops[index];
    final targetContext = stop.target.currentContext;
    if (targetContext == null) return;
    await Scrollable.ensureVisible(targetContext, alignment: 0.1);
    if (!context.mounted) return;
    final direction = await showDialog<int>(
      context: context,
      barrierColor: Colors.transparent,
      barrierLabel: 'Close tutorial',
      useSafeArea: false,
      builder: (dialogContext) => LayoutBuilder(
        builder: (context, constraints) {
          final box = stop.target.currentContext?.findRenderObject();
          final rect = box is RenderBox && box.hasSize
              ? box.localToGlobal(Offset.zero) & box.size
              : Rect.zero;
          final available = MediaQuery.sizeOf(context);
          final alignTop = rect.center.dy > available.height / 2;
          return Stack(
            children: [
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(painter: _SpotlightPainter(rect)),
                ),
              ),
              Dialog(
                alignment: alignTop
                    ? Alignment.topCenter
                    : Alignment.bottomCenter,
                insetPadding: const EdgeInsets.all(16),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 520,
                    maxHeight: (constraints.maxHeight - 48) * 0.55,
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tutorial ${stopIndex + 1} of ${stops.length}'),
                        const SizedBox(height: 8),
                        Text(
                          stop.title,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 12),
                        Text(stop.description),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(dialogContext),
                              child: const Text('Close tutorial'),
                            ),
                            if (stopIndex > 0)
                              OutlinedButton(
                                onPressed: () =>
                                    Navigator.pop(dialogContext, -1),
                                child: const Text('Back'),
                              ),
                            FilledButton(
                              autofocus: true,
                              onPressed: () => Navigator.pop(dialogContext, 1),
                              child: Text(
                                stopIndex == stops.length - 1 ? 'Done' : 'Next',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
    if (direction == null) return;
    index += direction;
  }
}

class _SpotlightPainter extends CustomPainter {
  _SpotlightPainter(this.target);
  final Rect target;

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = (Offset.zero & size).deflate(4);
    final cutout = RRect.fromRectAndRadius(
      target.inflate(4).intersect(bounds),
      const Radius.circular(20),
    );
    final path = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Offset.zero & size)
      ..addRRect(cutout);
    canvas.drawPath(path, Paint()..color = const Color(0xB3222C3B));
    canvas.drawRRect(
      cutout,
      Paint()
        ..color = AppColors.yellow
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(_SpotlightPainter oldDelegate) =>
      oldDelegate.target != target;
}
