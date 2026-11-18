import 'package:flutter/material.dart';

import '../app/theme.dart';
import 'cozy_ui.dart';
import 'robot_art.dart';

class MetricCard extends StatelessWidget {
  const MetricCard({
    required this.title,
    required this.value,
    required this.caption,
    required this.icon,
    required this.color,
    required this.artwork,
  });
  final String title, value, caption;
  final IconData icon;
  final Color color;
  final RobotArtwork artwork;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 153),
    decoration: BoxDecoration(
      color: AppColors.paper,
      borderRadius: BorderRadius.circular(23),
      border: Border.all(color: AppColors.border),
      boxShadow: const [
        BoxShadow(
          color: Color(0x120F2943),
          blurRadius: 18,
          offset: Offset(0, 6),
        ),
      ],
    ),
    child: Stack(
      children: [
        Positioned(
          right: 7,
          bottom: 3,
          child: Opacity(
            opacity: .65,
            child: RobotArt(artwork: artwork, size: 105),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Icon(icon, size: 19, color: AppColors.navy),
                  ),
                  const SizedBox(width: 9),
                  Flexible(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 39,
                  fontWeight: FontWeight.w900,
                  height: 1.04,
                  color: AppColors.deepNavy,
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 190,
                child: Text(
                  caption,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 10,
                    height: 1.2,
                    color: AppColors.mutedInk,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

/// Shows actual Master membership against the installed word catalogue.
class JourneyProgress extends StatelessWidget {
  const JourneyProgress({required this.count, this.total = 11147, super.key});
  final int? count;
  final int total;

  @override
  Widget build(BuildContext context) {
    final ratio = (count ?? 0).clamp(0, total) / total;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeading(
          title: 'Mastered words',
          caption: 'Your progress through the word library',
          icon: Icons.bar_chart_rounded,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFFE7F5DD),
            borderRadius: BorderRadius.circular(17),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                count == null
                    ? 'Loading mastered words…'
                    : '$count / $total words mastered',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: LinearProgressIndicator(
                  value: ratio.toDouble(),
                  minHeight: 15,
                  backgroundColor: Colors.white,
                  color: const Color(0xFF3E9F62),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${(ratio * 100).toStringAsFixed(1)}% of the library',
                style: const TextStyle(fontSize: 12, color: AppColors.mutedInk),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
