import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../shared/context_tour.dart';
import '../../shared/learning_card.dart';
import '../dashboard/home_content.dart';
import '../vocabulary/vocabulary_landing.dart';
import 'profile.dart';

class ProfileHomeScreen extends StatefulWidget {
  const ProfileHomeScreen({required this.profile, super.key});
  final LearnerProfile profile;

  @override
  State<ProfileHomeScreen> createState() => _ProfileHomeScreenState();
}

class _ProfileHomeScreenState extends State<ProfileHomeScreen> {
  int _destination = 0;
  bool _tourOpen = false;
  final _navigation = GlobalKey();
  final _foundation = GlobalKey();
  final _progress = GlobalKey();
  final _grammar = GlobalKey();
  final _vocabulary = List.generate(3, (_) => GlobalKey());
  final _scroll = ScrollController();
  static const _names = [
    'Home',
    'Vocabulary',
    'Grammar',
    'Practice',
    'Speaking',
  ];
  static const _icons = [
    Icons.home_outlined,
    Icons.auto_stories_outlined,
    Icons.menu_book_outlined,
    Icons.edit_note_outlined,
    Icons.chat_bubble_outline,
  ];

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _tour() async {
    if (_tourOpen) return;
    setState(() => _tourOpen = true);
    final stops = switch (_destination) {
      0 => [
        TourStop(
          _foundation,
          'Begin here',
          'Your introduction saves its place for this profile. You can leave, resume or replay after finishing.',
        ),
        TourStop(
          _progress,
          'Progress with meaning',
          'Word milestones are goals, not fluency scores. Counts and streaks will use actual learning records when lessons are available.',
        ),
        TourStop(
          _navigation,
          'Find your way',
          'Home, Vocabulary and Grammar each have a replayable tour. Practice and Speaking in this menu are future areas whose designs are pending.',
        ),
      ],
      1 => [
        TourStop(
          _vocabulary[0],
          'Learn in context',
          'New word lessons will introduce characters, Pinyin, meaning and five checked examples. This card becomes available when the lesson flow is ready.',
        ),
        TourStop(
          _vocabulary[1],
          'Vocabulary practice',
          'This is the planned vocabulary review stack. It is separate from the future Practice area in the main menu.',
        ),
        TourStop(
          _vocabulary[2],
          'Mastery takes time',
          'Mastery will need delayed, varied recall. A failed mastery check will return a word to review while preserving its history.',
        ),
      ],
      _ => [
        TourStop(
          _grammar,
          'Patterns, then practice',
          'Grammar will use distinct lessons with explanations, examples and prerequisites. Lesson records are being prepared; there are no placeholder exercises to complete.',
        ),
      ],
    };
    try {
      await showContextTour(context, stops);
    } finally {
      if (mounted) setState(() => _tourOpen = false);
    }
  }

  Widget _menu({required bool wide}) {
    final items = [
      for (var i = 0; i < _names.length; i++)
        TextButton.icon(
          key: ValueKey('destination-$i'),
          style: TextButton.styleFrom(
            foregroundColor: _destination == i ? AppColors.navy : Colors.white,
            backgroundColor: _destination == i
                ? AppColors.yellow
                : Colors.transparent,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          onPressed: () {
            setState(() => _destination = i);
            if (_scroll.hasClients) _scroll.jumpTo(0);
          },
          icon: Icon(_icons[i]),
          label: Text(_names[i]),
        ),
    ];
    return Material(
      key: _navigation,
      color: AppColors.navy,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: wide
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      'NI HAO\nROBOT!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...items,
                  const SizedBox(height: 24),
                  const Text(
                    'Practice & Speaking\nComing later · design pending',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              )
            : Wrap(spacing: 8, runSpacing: 8, children: items),
      ),
    );
  }

  Widget _content() => switch (_destination) {
    0 => HomeContent(
      profile: widget.profile,
      foundationKey: _foundation,
      progressKey: _progress,
    ),
    1 => VocabularyLanding(targets: _vocabulary),
    2 => LearningCard(
      key: _grammar,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Build sentences, step by step',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          const Text(
            'Grammar lessons are being prepared. They will connect useful patterns, clear explanations and checked examples, with prerequisites that support your next step.',
          ),
        ],
      ),
    ),
    _ => LearningCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _names[_destination],
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          const Text('Coming later — design pending'),
        ],
      ),
    ),
  };

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Your learning space')),
    body: LayoutBuilder(
      builder: (context, constraints) {
        final wide =
            constraints.maxWidth >= 1100 &&
            MediaQuery.textScalerOf(context).scale(16) <= 24;
        final content = SingleChildScrollView(
          controller: _scroll,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!wide) _menu(wide: false),
              Padding(
                padding: EdgeInsets.all(wide ? 32 : 16),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 16,
                          runSpacing: 8,
                          children: [
                            Text(
                              _names[_destination],
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            if (_destination <= 2)
                              TextButton.icon(
                                onPressed: _tourOpen ? null : _tour,
                                icon: const Icon(Icons.help_outline),
                                label: const Text('Replay Tutorial'),
                              ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _content(),
                        const SizedBox(height: 24),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Switch profile'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
        return wide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: 230,
                    child: ColoredBox(
                      color: AppColors.navy,
                      child: SingleChildScrollView(child: _menu(wide: true)),
                    ),
                  ),
                  Expanded(child: content),
                ],
              )
            : content;
      },
    ),
  );
}
