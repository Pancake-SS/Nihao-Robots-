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
import '../grammar/grammar_screen.dart';
import '../learning/learning_home.dart';
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
  final _learning = List.generate(4, (_) => GlobalKey());
  final _scroll = ScrollController();
  static const _names = [
    'Home',
    'Vocabulary',
    'Grammar',
    'Learning',
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
          'The green bar tracks words currently mastered. Flags mark goals from 100 through 11,000 words. The daily checklist shows what remains for today.',
        ),
        TourStop(
          _navigation,
          'Find your way',
          'Use the sidebar to open Vocabulary, Grammar, Learning and Speaking. Replay this tutorial on each main page.',
        ),
      ],
      1 => [
        TourStop(
          _vocabulary[0],
          'Learn in context',
          'Choose a word and finish its lesson quiz. New words and quiz activity count toward daily goals.',
        ),
        TourStop(
          _vocabulary[1],
          'Practice your words',
          'Choose a learned word for a full test, answer random questions, try endless mode, or reopen a lesson.',
        ),
        TourStop(
          _vocabulary[2],
          'Master words',
          'After 25 correct points, pass the full Master test to master a word. If you already know one, Instant master skips the quiz after confirmation. Three missed answers during Master practice return the word to Learn while keeping its points.',
        ),
      ],
      2 => [
        TourStop(
          _grammar,
          'Patterns in context',
          'Open Pending lessons to study a grammar pattern with a clear explanation, structure and examples. Mark it completed when you understand it, then revisit it under Completed lessons.',
        ),
      ],
      3 => [
        TourStop(
          _learning[0],
          'Online resources',
          'Browse free Chinese videos, audio and stories.',
        ),
        TourStop(
          _learning[1],
          'Classical stories',
          'Open a story and switch between the original Chinese and English.',
        ),
        TourStop(
          _learning[2],
          'Free writing',
          'Pick a topic, write and save. One saved piece meets the daily writing goal.',
        ),
        TourStop(
          _learning[3],
          'Notebook',
          'Keep personal notes on a single, roomy page.',
        ),
      ],
      _ => [
        TourStop(
          _navigation,
          'Speaking',
          'This section is still being prepared.',
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

  Widget _grammarPanel() => KeyedSubtree(
    key: _grammar,
    child: GrammarHomeContent(
      profileId: widget.profile.id,
      showPinyin: widget.profile.showPinyin,
    ),
  );

  Widget _futurePanel() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      SunnyHero(
        title: _names[_destination],
        subtitle: 'Build confidence with spoken Mandarin.',
        tag: 'A space for tomorrow',
        robot: RobotArtwork.tallOnPaper,
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
              const Text(
                'Speaking features will be planned separately. Existing pronunciation and audio functions are unchanged.',
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
    3 => LearningHomeContent(profileId: widget.profile.id, targets: _learning),
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
                        if (_destination <= 3)
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
