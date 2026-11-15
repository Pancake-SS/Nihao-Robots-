import 'package:flutter/material.dart';

import '../app/theme.dart';
import 'cozy_ui.dart';
import 'robot_art.dart';
import 'ui_art.dart';

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

/// Shared by the live dashboard and the dependency-free GUI preview gallery.
class JourneyProgress extends StatelessWidget {
  const JourneyProgress({required this.count, super.key});
  final int? count;
  static const _goals = [500, 1000, 2000, 5000];
  static const _labels = [
    'Survival',
    'Everyday',
    'Deeper talks',
    'Long-term goal',
  ];
  static const _colors = [
    Color(0xFFE97B76),
    Color(0xFF77B878),
    Color(0xFF77A9DF),
    Color(0xFFDB96BC),
  ];

  @override
  Widget build(BuildContext context) {
    final value = (count ?? 0).clamp(0, 5000) / 5000;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeading(
          title: 'Fluency progression',
          caption: 'Explore your vocabulary milestones, one step at a time',
          icon: Icons.bar_chart_rounded,
          action: TextButton.icon(
            onPressed: () => _details(context),
            icon: const Icon(Icons.info_outline, size: 17),
            label: const Text('View Details'),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.fromLTRB(15, 19, 15, 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFDCF0CF), Color(0xFFE7F5DD), Color(0xFFD6EBF7)],
            ),
            borderRadius: BorderRadius.circular(17),
          ),
          child: Stack(
            children: [
              const Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: UiArt(
                    art: UiArtwork.fluencyJourney,
                    width: 370,
                    height: 180,
                    opacity: .14,
                  ),
                ),
              ),
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: LinearProgressIndicator(
                      value: value.toDouble(),
                      minHeight: 12,
                      backgroundColor: const Color(0xCCFFFFFF),
                      color: const Color(0xFF79B783),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i = 0; i < _goals.length; i++)
                        Expanded(
                          child: Column(
                            children: [
                              Icon(
                                Icons.flag_rounded,
                                color: _colors[i],
                                size: 26,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${_goals[i]}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                _labels[i],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: AppColors.mutedInk,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          count == null
              ? 'Loading your saved vocabulary activity…'
              : '$count words have saved quiz records. Milestones are goals, not fluency measurements.',
          style: const TextStyle(fontSize: 11, color: AppColors.mutedInk),
        ),
      ],
    );
  }

  void _details(BuildContext context) => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Your word milestones'),
      content: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '🚩 500 — A survival-vocabulary target: greetings and simple orders.',
            ),
            SizedBox(height: 11),
            Text('🚩 1,000 — A broader everyday-vocabulary target.'),
            SizedBox(height: 11),
            Text('🚩 2,000 — More vocabulary for richer conversations.'),
            SizedBox(height: 11),
            Text(
              '🚩 5,000 — A long-term vocabulary goal, not a guarantee of fluency.',
            ),
            SizedBox(height: 18),
            Text(
              'These goals are not fluency scores. Counts here reflect words with saved quizzes. Fluency also depends on listening, grammar, comprehension and speaking.',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}
