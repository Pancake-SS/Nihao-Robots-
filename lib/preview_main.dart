import 'package:flutter/material.dart';

import 'app/theme.dart';
import 'shared/app_brand.dart';
import 'shared/app_sidebar.dart';
import 'shared/cozy_ui.dart';
import 'shared/dashboard_widgets.dart';
import 'shared/learning_card.dart';
import 'shared/robot_art.dart';
import 'shared/vocabulary_card.dart';
import 'shared/ui_art.dart';

/// Isolated, visual-only UI preview. No accounts, database, lessons, or audio.
/// In the standalone workshop this is also copied to lib/main.dart.
void main() => runApp(const _PreviewApp());

class _PreviewApp extends StatelessWidget {
  const _PreviewApp();

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Ni Hao Robot! — UI Workshop',
    theme: buildTheme(),
    home: const _PreviewGallery(),
  );
}

class _PreviewGallery extends StatefulWidget {
  const _PreviewGallery();

  @override
  State<_PreviewGallery> createState() => _PreviewGalleryState();
}

class _PreviewGalleryState extends State<_PreviewGallery> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _destination = 0;
  int _vocabSection = 0;

  static const _wordSamples = <(String, String, String)>[
    ('你好', 'nǐ hǎo', 'Hello'),
    ('朋友', 'péng you', 'Friend'),
    ('米饭', 'mǐ fàn', 'Rice'),
    ('音乐', 'yīn yuè', 'Music'),
    ('照片', 'zhào piàn', 'Photo'),
    ('谢谢', 'xiè xie', 'Thank you'),
    ('老师', 'lǎo shī', 'Teacher'),
    ('喜欢', 'xǐ huan', 'Like'),
  ];

  void _select(int destination) {
    setState(() => _destination = destination);
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      _scaffoldKey.currentState?.closeDrawer();
    }
  }

  void _vocab(int tab) => setState(() {
    _destination = 1;
    _vocabSection = tab;
  });

  void _showTourInfo() => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.info_outline_rounded, color: AppColors.navy),
          SizedBox(width: 10),
          Text('UI workshop tour'),
        ],
      ),
      content: const Text(
        'The original application has its own replayable tutorial. '
        'Here you can explore the five sidebar sections and, under '
        'Vocabulary, the list, review, and lesson designs. '
        'These are visual samples only and do not save progress.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Got it'),
        ),
      ],
    ),
  );

  Widget _sidebar() => AppSidebar(
    selected: _destination,
    onSelect: _select,
    workshop: true,
    footer: IconButton(
      tooltip: 'Profiles / Welcome',
      onPressed: () => _select(5),
      icon: const Icon(Icons.person_outline_rounded, color: Colors.white),
    ),
  );

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final desktop = constraints.maxWidth >= 780;
      final content = WarmPageBackground(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            desktop ? 28 : 16,
            20,
            desktop ? 28 : 16,
            30,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1180),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      if (desktop)
                        const Expanded(child: AppBrandRow(size: 36))
                      else
                        const Expanded(
                          child: Text(
                            'YOUR LEARNING SPACE',
                            style: TextStyle(
                              color: AppColors.mutedInk,
                              fontSize: 10,
                              letterSpacing: 1.4,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      TextButton.icon(
                        onPressed: _showTourInfo,
                        icon: const Icon(Icons.play_circle_outline, size: 18),
                        label: const Text('Replay tutorial'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _currentPage(),
                  const SizedBox(height: 22),
                  const Text(
                    'UI WORKSHOP · SAMPLE CONTENT ONLY · '
                    'NO DATABASE, LOGIN, SAVING OR AUDIO',
                    style: TextStyle(
                      color: AppColors.mutedInk,
                      fontWeight: FontWeight.w800,
                      fontSize: 10,
                      letterSpacing: .75,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      return Scaffold(
        key: _scaffoldKey,
        drawer: desktop ? null : Drawer(width: 228, child: _sidebar()),
        appBar: desktop ? null : AppBar(title: const AppBrandRow(size: 31)),
        body: desktop
            ? Row(
                children: [
                  SizedBox(width: 196, child: _sidebar()),
                  Expanded(child: content),
                ],
              )
            : content,
      );
    },
  );

  Widget _currentPage() => switch (_destination) {
    0 => _home(),
    1 => _vocabulary(),
    2 => _grammar(),
    3 => _future(
      'Practice',
      'Texting, conversations and practical writing activities '
          'will be designed later.',
      RobotArtwork.orbOnPaper,
    ),
    4 => _future(
      'Speaking',
      'Speaking practice is planned for a later iteration.',
      RobotArtwork.tallOnPaper,
    ),
    _ => _welcome(),
  };

  Widget _home() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const SunnyHero(
        title: 'Home',
        subtitle: 'Small steps today, a more confident you tomorrow.',
        tag: 'Your Chinese learning journey',
        robot: RobotArtwork.trackedOnPaper,
      ),
      const SizedBox(height: 16),
      LayoutBuilder(
        builder: (context, c) => c.maxWidth >= 620
            ? const Row(
                children: [
                  Expanded(
                    child: MetricCard(
                      title: 'Words started',
                      value: '0',
                      caption: 'Sample progress — not saved',
                      icon: Icons.auto_stories_rounded,
                      color: AppColors.yellow,
                      artwork: RobotArtwork.orbOnPaper,
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: MetricCard(
                      title: 'Daily streak',
                      value: '—',
                      caption: 'Daily tracking coming later',
                      icon: Icons.local_fire_department_rounded,
                      color: AppColors.peach,
                      artwork: RobotArtwork.squareOnPaper,
                    ),
                  ),
                ],
              )
            : const Column(
                children: [
                  MetricCard(
                    title: 'Words started',
                    value: '0',
                    caption: 'Sample progress — not saved',
                    icon: Icons.auto_stories_rounded,
                    color: AppColors.yellow,
                    artwork: RobotArtwork.orbOnPaper,
                  ),
                  SizedBox(height: 14),
                  MetricCard(
                    title: 'Daily streak',
                    value: '—',
                    caption: 'Daily tracking coming later',
                    icon: Icons.local_fire_department_rounded,
                    color: AppColors.peach,
                    artwork: RobotArtwork.squareOnPaper,
                  ),
                ],
              ),
      ),
      const SizedBox(height: 16),
      const LearningCard(child: JourneyProgress(count: 0)),
      const SizedBox(height: 16),
      LearningCard(
        background: const Color(0xFFF7EEDB),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeading(
                    title: 'Start with the basics',
                    caption: 'Learn your first Chinese words',
                    icon: Icons.waving_hand_outlined,
                  ),
                  const SizedBox(height: 14),
                  FilledButton.icon(
                    onPressed: () => _vocab(0),
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: const Text('Explore vocabulary'),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 9),
            const RobotArt(artwork: RobotArtwork.hoverOnPaper, size: 103),
          ],
        ),
      ),
    ],
  );

  Widget _vocabulary() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const SunnyHero(
        title: 'Vocabulary',
        subtitle: 'Grow your Chinese word bank, step by step.',
        robot: RobotArtwork.wavingOnPaper,
        tag: 'Three ways to grow',
      ),
      const SizedBox(height: 14),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (var i = 0; i < 4; i++)
            ChoiceChip(
              selected: _vocabSection == i,
              label: Text(
                const [
                  'Overview',
                  'Learn list',
                  'Review list',
                  'Word lesson',
                ][i],
              ),
              onSelected: (_) => _vocab(i),
            ),
        ],
      ),
      const SizedBox(height: 16),
      switch (_vocabSection) {
        0 => _vocabularyCards(),
        1 => _learnList(),
        2 => _reviewList(),
        _ => _word(),
      },
    ],
  );

  Widget _vocabularyCards() => LayoutBuilder(
    builder: (context, c) {
      final cards = <Widget>[
        VocabularyStackCard(
          title: 'Learn',
          label: '01 · DISCOVER',
          color: AppColors.yellow,
          background: const Color(0xFFFFF2D5),
          icon: Icons.auto_stories_outlined,
          artwork: RobotArtwork.hoverOnPaper,
          description:
              'Meet new Chinese words with meanings, '
              'pronunciation, and examples.',
          status: 'Preview your upcoming words',
          actionLabel: 'Start learning',
          action: () => _vocab(1),
        ),
        VocabularyStackCard(
          title: 'Practice',
          label: '02 · RECALL',
          color: AppColors.blue,
          background: const Color(0xFFE7F0F5),
          icon: Icons.forum_outlined,
          artwork: RobotArtwork.orbOnPaper,
          description: 'Revisit learned words to reinforce your memory.',
          status: 'See your sample review list',
          actionLabel: 'Open reviews',
          action: () => _vocab(2),
        ),
        const VocabularyStackCard(
          title: 'Master',
          label: '03 · REMEMBER',
          color: AppColors.leaf,
          background: Color(0xFFE8F1DE),
          icon: Icons.star_outline_rounded,
          artwork: RobotArtwork.gogglesOnPaper,
          description: 'Build long-term recall with future mastery checks.',
          status: 'Mastery tools are not yet available',
          actionLabel: 'Coming soon',
        ),
      ];
      if (c.maxWidth >= 770) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < cards.length; i++) ...[
              if (i > 0) const SizedBox(width: 15),
              Expanded(child: cards[i]),
            ],
          ],
        );
      }
      return Column(
        children: [
          for (final card in cards) ...[card, const SizedBox(height: 14)],
        ],
      );
    },
  );

  Widget _learnList() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const SectionHeading(
        title: 'Learn · Upcoming words',
        caption: 'Example vocabulary list — for layout preview',
        icon: Icons.menu_book_rounded,
      ),
      const SizedBox(height: 13),
      LayoutBuilder(
        builder: (context, c) {
          final list = LearningCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        'PINYIN',
                        style: TextStyle(
                          color: AppColors.mutedInk,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'HANZI',
                        style: TextStyle(
                          color: AppColors.mutedInk,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'MEANING',
                        style: TextStyle(
                          color: AppColors.mutedInk,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                for (var i = 0; i < _wordSamples.length; i++) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            _wordSamples[i].$2,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            _wordSamples[i].$1,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            _wordSamples[i].$3,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (i < _wordSamples.length - 1)
                    const Divider(height: 1, color: AppColors.border),
                ],
              ],
            ),
          );
          final tools = Column(
            children: [
              LearningCard(
                background: const Color(0xFFF5EBD9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SectionHeading(
                      title: 'Add your own words',
                      caption: 'Input preview only · Not connected',
                      icon: Icons.edit_note_rounded,
                    ),
                    const SizedBox(height: 13),
                    const TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: 'Pinyin · Hanzi · Meaning',
                      ),
                    ),
                    const SizedBox(height: 12),
                    const FilledButton(
                      onPressed: null,
                      child: Text('Save word (not available)'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              LearningCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SectionHeading(
                      title: 'Let’s learn!',
                      caption: 'Discover one word at a time',
                      icon: Icons.auto_stories_rounded,
                    ),
                    const SizedBox(height: 8),
                    const Center(
                      child: RobotArt(
                        artwork: RobotArtwork.trackedOnPaper,
                        size: 110,
                      ),
                    ),
                    const SizedBox(height: 8),
                    FilledButton.icon(
                      onPressed: () => _vocab(3),
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: const Text('See sample lesson'),
                    ),
                  ],
                ),
              ),
            ],
          );
          return c.maxWidth >= 720
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 5, child: list),
                    const SizedBox(width: 15),
                    Expanded(flex: 4, child: tools),
                  ],
                )
              : Column(children: [list, const SizedBox(height: 15), tools]);
        },
      ),
    ],
  );

  Widget _reviewList() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const SectionHeading(
        title: 'Practice · Review list',
        caption: 'Sample list and review controls',
        icon: Icons.history_edu_rounded,
      ),
      const SizedBox(height: 14),
      LearningCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Words to practice',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
            ),
            const SizedBox(height: 7),
            const Text(
              'These examples do not reflect saved or due reviews.',
              style: TextStyle(color: AppColors.mutedInk, fontSize: 12),
            ),
            const SizedBox(height: 14),
            for (var i = 0; i < 5; i++) ...[
              Row(
                children: [
                  CircleAvatar(
                    radius: 17,
                    backgroundColor: AppColors.sky,
                    child: Text(
                      '${i + 1}',
                      style: const TextStyle(
                        color: AppColors.deepNavy,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Text(
                      _wordSamples[i].$1,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 19,
                      ),
                    ),
                  ),
                  Text(
                    _wordSamples[i].$2,
                    style: const TextStyle(color: AppColors.mutedInk),
                  ),
                  const SizedBox(width: 15),
                  Text(_wordSamples[i].$3),
                ],
              ),
              const Divider(height: 22),
            ],
            const FilledButton(
              onPressed: null,
              child: Text('Start review (requires real app)'),
            ),
          ],
        ),
      ),
    ],
  );

  Widget _word() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      LearningCard(
        background: const Color(0xFFF5E6CD),
        child: Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '照片',
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900),
                  ),
                  Text('zhào piàn', style: TextStyle(fontSize: 19)),
                  SizedBox(height: 8),
                  Text(
                    'Photo',
                    style: TextStyle(color: AppColors.mutedInk, fontSize: 17),
                  ),
                ],
              ),
            ),
            const RobotArt(artwork: RobotArtwork.tallOnPaper, size: 115),
          ],
        ),
      ),
      const SizedBox(height: 18),
      const SectionHeading(
        title: 'Example sentences',
        caption: 'Sample lesson content · Audio not available in workshop',
        icon: Icons.menu_book_rounded,
        art: UiArtwork.openBook,
      ),
      const SizedBox(height: 12),
      for (var i = 0; i < 5; i++) ...[
        LearningCard(
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.yellow,
                child: Text(
                  '${i + 1}',
                  style: const TextStyle(color: AppColors.deepNavy),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      i.isEven ? '这是一张照片。' : '我的照片很美。',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      i.isEven ? 'This is a photo.' : 'My photo is beautiful.',
                      style: const TextStyle(color: AppColors.mutedInk),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 9),
      ],
    ],
  );

  Widget _grammar() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const SunnyHero(
        title: 'Grammar',
        subtitle: 'Find the patterns that make Mandarin click.',
        robot: RobotArtwork.gogglesOnPaper,
        tag: 'Build your foundations',
      ),
      const SizedBox(height: 16),
      const LearningCard(
        child: ArtBackplate(
          art: UiArtwork.studyRobotReading,
          width: 205,
          height: 160,
          opacity: .32,
          minWidth: 750,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeading(
                title: 'Lesson chapters',
                art: UiArtwork.openBook,
                caption: 'Meaning · structure · rules · examples',
                icon: Icons.auto_stories_outlined,
              ),
              SizedBox(height: 18),
              Text(
                'Grammar library is being prepared',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17),
              ),
              SizedBox(height: 7),
              Text('This workshop does not contain a grammar dataset.'),
            ],
          ),
        ),
      ),
    ],
  );

  Widget _future(String title, String subtitle, RobotArtwork robot) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      SunnyHero(
        title: title,
        subtitle: subtitle,
        robot: robot,
        tag: 'A space for tomorrow',
      ),
      const SizedBox(height: 16),
      const LearningCard(
        child: ArtBackplate(
          art: UiArtwork.studyRobotGreeting,
          width: 175,
          height: 150,
          opacity: .30,
          minWidth: 750,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeading(
                title: 'Coming soon',
                caption: 'This section is intentionally not yet designed',
                icon: Icons.construction_outlined,
              ),
              SizedBox(height: 12),
              Text(
                'Existing vocabulary review is shown under Vocabulary → Review list.',
              ),
            ],
          ),
        ),
      ),
    ],
  );

  Widget _welcome() => LayoutBuilder(
    builder: (context, c) {
      final desktop = c.maxWidth >= 730;
      final story = ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: SizedBox(
          height: desktop ? 500 : 275,
          child: Stack(
            children: [
              const Positioned.fill(child: NightStudyScene()),
              const Positioned(
                left: 25,
                top: 27,
                child: AppBrandRow(onDark: true, size: 39),
              ),
              Positioned(
                left: 29,
                top: desktop ? 142 : 96,
                right: desktop ? 60 : 105,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '你好!',
                      style: TextStyle(
                        color: AppColors.yellow,
                        fontSize: desktop ? 49 : 34,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      'A little Mandarin,\nevery day.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: desktop ? 28 : 20,
                        height: 1.15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
      final profilePanel = LearningCard(
        child: ArtBackplate(
          art: UiArtwork.cherryBlossom,
          width: 190,
          height: 125,
          opacity: .16,
          minWidth: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SectionHeading(
                title: 'Welcome · Learner profiles',
                caption: 'Original app uses offline profiles, not online login',
                icon: Icons.person_outline_rounded,
              ),
              const SizedBox(height: 18),
              const Text(
                'Choose your learning space',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 10),
              const Text(
                'The functional profile picker is available '
                'only in your complete application.',
              ),
              const SizedBox(height: 17),
              const TextField(
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'New profile name',
                  hintText: 'Your name',
                ),
              ),
              const SizedBox(height: 12),
              const FilledButton(
                onPressed: null,
                child: Text('Create profile (preview only)'),
              ),
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: () => _select(0),
                icon: const Icon(Icons.visibility_outlined),
                label: const Text('Preview home design'),
              ),
              const SizedBox(height: 13),
              const Text(
                'No sign-in, local account, or database is created.',
                style: TextStyle(fontSize: 11, color: AppColors.mutedInk),
              ),
            ],
          ),
        ),
      );
      return desktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 5, child: story),
                const SizedBox(width: 17),
                Expanded(flex: 5, child: profilePanel),
              ],
            )
          : Column(children: [story, const SizedBox(height: 15), profilePanel]);
    },
  );
}
