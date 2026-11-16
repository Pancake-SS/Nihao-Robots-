import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../shared/cozy_ui.dart';
import '../../shared/context_tour.dart';
import '../../shared/learning_card.dart';
import '../../shared/robot_art.dart';
import '../../shared/app_brand.dart';
import '../../shared/app_sidebar.dart';
import '../../shared/ui_art.dart';
import '../dashboard/home_content.dart';
import '../vocabulary/vocabulary_landing.dart';
import '../review/review_screen.dart';
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
          'Home, Vocabulary and Grammar each have a replayable tour. Practice opens your learned words and three question modes.',
        ),
      ],
      1 => [
        TourStop(
          _vocabulary[0],
          'Learn in context',
          'Browse words opens the lesson catalogue. Reviewed packs will supply characters, Pinyin, meaning and five examples. The catalogue explains when no lessons are available.',
        ),
        TourStop(
          _vocabulary[1],
          'Vocabulary practice',
          'Practice lets you replay a word test, choose a number of random words, or keep answering fresh questions.',
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

  void _select(int index) {
    setState(() => _destination = index);
    if (_scroll.hasClients) _scroll.jumpTo(0);
  }

  Widget _menu({required bool wide}) => AppSidebar(
    navigationKey: wide ? _navigation : null,
    selected: _destination,
    onSelect: (index) {
      _select(index);
      if (!wide) Navigator.of(context).pop(); // close the mobile drawer
    },
    footer: IconButton(
      tooltip: 'Switch profile',
      onPressed: () => Navigator.of(context).pop(),
      icon: const Icon(Icons.swap_horiz_rounded, color: Colors.white),
    ),
  );

  Widget _grammarPanel() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const SunnyHero(
        title: 'Grammar',
        subtitle: 'Find the patterns that make Mandarin click.',
        tag: 'Build your foundations',
        robot: RobotArtwork.gogglesOnPaper,
      ),
      const SizedBox(height: 18),
      LearningCard(
        key: _grammar,
        child: ArtBackplate(
          art: UiArtwork.studyRobotReading,
          width: 205,
          height: 175,
          opacity: .33,
          minWidth: 750,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeading(
                title: 'Lesson chapters',
                art: UiArtwork.openBook,
                caption: 'Meaning · structure · rules · examples',
                icon: Icons.auto_stories_outlined,
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: AppColors.peach,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.menu_book_outlined, size: 27),
                  ),
                  const SizedBox(width: 13),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Grammar library is being prepared',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Lessons will come from distinct records, not repeated placeholder chapters.',
                          style: TextStyle(
                            color: AppColors.mutedInk,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(label: Text('Clear structures')),
                  Chip(label: Text('Grammar rules')),
                  Chip(label: Text('Worked examples')),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'No grammar lesson has been published in the supplied app yet.',
                style: TextStyle(fontSize: 12, color: AppColors.mutedInk),
              ),
            ],
          ),
        ),
      ),
    ],
  );

  Widget _futurePanel() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      SunnyHero(
        title: _names[_destination],
        subtitle: _destination == 3
            ? 'Put what you know into everyday conversation.'
            : 'Build confidence with spoken Mandarin.',
        tag: 'A space for tomorrow',
        robot: _destination == 3
            ? RobotArtwork.orbOnPaper
            : RobotArtwork.tallOnPaper,
      ),
      const SizedBox(height: 18),
      LearningCard(
        child: ArtBackplate(
          art: UiArtwork.studyRobotGreeting,
          width: 190,
          height: 155,
          opacity: .30,
          minWidth: 750,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeading(
                title: 'Coming soon',
                caption: 'This area has not been designed or connected yet',
                icon: Icons.construction_outlined,
              ),
              const SizedBox(height: 12),
              Text(
                _destination == 3
                    ? 'Conversation and practical writing activities will live here. Your current saved vocabulary reviews are available under Vocabulary → Practice.'
                    : 'Speaking features will be planned separately. Existing pronunciation and audio functions are unchanged.',
              ),
            ],
          ),
        ),
      ),
    ],
  );

  Widget _content() => switch (_destination) {
    0 => HomeContent(
      profile: widget.profile,
      foundationKey: _foundation,
      progressKey: _progress,
    ),
    1 => VocabularyLanding(
      profileId: widget.profile.id,
      targets: _vocabulary,
      showPinyin: widget.profile.showPinyin,
    ),
    2 => _grammarPanel(),
    3 => PracticeContent(
      profileId: widget.profile.id,
      showPinyin: widget.profile.showPinyin,
    ),
    _ => _futurePanel(),
  };

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      // Keep the desktop sidebar visible at common browser widths.
      final wide =
          constraints.maxWidth >= 780 &&
          MediaQuery.textScalerOf(context).scale(16) <= 24;
      final content = WarmPageBackground(
        child: SingleChildScrollView(
          controller: _scroll,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1150),
              child: Padding(
                padding: EdgeInsets.all(wide ? 24 : 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        if (wide)
                          const AppBrandRow(size: 35)
                        else
                          const Text(
                            'YOUR LEARNING SPACE',
                            style: TextStyle(
                              letterSpacing: 1.3,
                              fontSize: 10,
                              color: AppColors.mutedInk,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        if (_destination <= 2)
                          TextButton.icon(
                            onPressed: _tourOpen ? null : _tour,
                            icon: const Icon(
                              Icons.play_circle_outline,
                              size: 19,
                            ),
                            label: const Text('Replay Tutorial'),
                          ),
                      ],
                    ),
                    const SizedBox(height: 17),
                    _content(),
                    const SizedBox(height: 22),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.swap_horiz),
                        label: const Text('Switch profile'),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      return Scaffold(
        drawer: wide
            ? null
            : Drawer(
                width: (MediaQuery.sizeOf(context).width * .9).clamp(
                  244.0,
                  360.0,
                ),
                child: _menu(wide: false),
              ),
        appBar: wide
            ? null
            : AppBar(
                leading: Builder(
                  builder: (context) => IconButton(
                    key: _navigation,
                    tooltip: 'Open navigation sidebar',
                    icon: const Icon(Icons.menu_rounded),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                title: const AppBrandRow(size: 31),
              ),
        body: wide
            ? Row(
                children: [
                  SizedBox(width: 220, child: _menu(wide: true)),
                  Expanded(child: content),
                ],
              )
            : content,
      );
    },
  );
}
