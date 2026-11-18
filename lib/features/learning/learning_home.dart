import 'package:flutter/material.dart';

import '../../shared/cozy_ui.dart';
import '../../shared/robot_art.dart';
import 'classical_stories_screen.dart';
import 'learning_journal_repository.dart';
import 'learning_journal_screen.dart';
import 'learning_resources_screen.dart';

class LearningHomeContent extends StatelessWidget {
  const LearningHomeContent({required this.profileId, super.key});

  final int profileId;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const SunnyHero(
        title: 'Learning',
        subtitle: 'Find Chinese in stories, sound and everyday life.',
        tag: 'Explore and create',
        robot: RobotArtwork.shyOnPaper,
      ),
      const SizedBox(height: 18),
      Text(
        'Choose your path',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      const SizedBox(height: 7),
      const Text(
        'Enjoy real Chinese content, write from a fresh topic, or keep your own notes.',
      ),
      const SizedBox(height: 15),
      _destination(
        context,
        key: 'learning-resources',
        icon: Icons.travel_explore_outlined,
        title: 'Explore online',
        subtitle: 'Free stories, videos, podcasts and music.',
        builder: (_) => const LearningResourcesScreen(),
      ),
      _destination(
        context,
        key: 'learning-classics',
        icon: Icons.auto_stories_outlined,
        title: 'Classical stories',
        subtitle: 'Buddhist parables, Zhuangzi and Liezi. Read offline.',
        builder: (_) => const ClassicalStoriesScreen(),
      ),
      _destination(
        context,
        key: 'learning-writing',
        icon: Icons.draw_outlined,
        title: 'Free writing',
        subtitle: 'Get a random topic and save what you write.',
        builder: (_) => LearningJournalScreen(
          profileId: profileId,
          kind: LearningEntryKind.writing,
        ),
      ),
      _destination(
        context,
        key: 'learning-notebook',
        icon: Icons.book_outlined,
        title: 'Notebook',
        subtitle: 'Keep ideas, Chinese notes and ramblings.',
        builder: (_) => LearningJournalScreen(
          profileId: profileId,
          kind: LearningEntryKind.note,
        ),
      ),
    ],
  );

  Widget _destination(
    BuildContext context, {
    required String key,
    required IconData icon,
    required String title,
    required String subtitle,
    required WidgetBuilder builder,
  }) => Card(
    child: ListTile(
      key: ValueKey(key),
      contentPadding: const EdgeInsets.all(16),
      leading: Icon(icon, size: 30),
      title: Text(title, style: Theme.of(context).textTheme.titleLarge),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: () =>
          Navigator.of(context).push(MaterialPageRoute<void>(builder: builder)),
    ),
  );
}
