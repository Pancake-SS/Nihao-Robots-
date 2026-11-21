import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/app_brand.dart';
import '../../shared/cozy_ui.dart';
import '../../shared/robot_art.dart';
import 'learning_providers.dart';
import 'master_repository.dart';
import 'practice_method_screen.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({
    required this.profileId,
    this.showPinyin = true,
    super.key,
  });
  final int profileId;
  final bool showPinyin;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const AppScreenTitle('Practice')),
    body: WarmPageBackground(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: PracticeContent(
              profileId: profileId,
              showPinyin: showPinyin,
            ),
          ),
        ),
      ),
    ),
  );
}

class PracticeContent extends ConsumerWidget {
  const PracticeContent({
    required this.profileId,
    required this.showPinyin,
    super.key,
  });
  final int profileId;
  final bool showPinyin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(learningProgressProvider(profileId));
    final mastered = ref.watch(masteredIdsProvider(profileId));
    final count = progress.asData?.value
        .where((word) => mastered.asData?.value.contains(word.wordId) != true)
        .length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SunnyHero(
          title: 'Practice',
          subtitle: 'Choose one way to practise. Each activity opens on its own page.',
          tag: 'Build your recall',
          robot: RobotArtwork.orbOnPaper,
        ),
        const SizedBox(height: 18),
        if (progress.hasError || mastered.hasError)
          TextButton(
            onPressed: () {
              ref.invalidate(learningProgressProvider(profileId));
              ref.invalidate(masteredIdsProvider(profileId));
            },
            child: const Text('Reload practice words'),
          )
        else if (count == null)
          const Center(child: CircularProgressIndicator())
        else
          Text(
            '$count ${count == 1 ? 'word' : 'words'} ready',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        const SizedBox(height: 12),
        _method(
          context,
          PracticeRoute.oneWord,
          Icons.spellcheck,
          'Test one word',
          'Choose a learned word and repeat its full test.',
        ),
        _method(
          context,
          PracticeRoute.randomWords,
          Icons.shuffle,
          'Random questions',
          'Choose a number of questions from different words.',
        ),
        _method(
          context,
          PracticeRoute.endless,
          Icons.all_inclusive,
          'Endless questions',
          'Keep going through fresh questions until you stop.',
        ),
        _method(
          context,
          PracticeRoute.relearn,
          Icons.menu_book_outlined,
          'Relearn a word',
          'Browse learned words or search, then revisit a lesson.',
        ),
        if (count == 0)
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text('Finish a word lesson to start practising.'),
          ),
      ],
    );
  }

  Widget _method(
    BuildContext context,
    PracticeRoute route,
    IconData icon,
    String title,
    String description,
  ) => Card(
    child: ListTile(
      key: ValueKey('practice-method-${route.name}'),
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(description),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => PracticeMethodScreen(
            profileId: profileId,
            route: route,
            showPinyin: showPinyin,
          ),
        ),
      ),
    ),
  );
}
