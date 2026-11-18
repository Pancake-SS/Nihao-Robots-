import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../shared/app_brand.dart';
import '../../shared/cozy_ui.dart';
import '../../shared/robot_art.dart';
import 'resource_catalogue.dart';

typedef ResourceOpener = Future<bool> Function(Uri uri);

final resourceOpenerProvider = Provider<ResourceOpener>(
  (ref) =>
      (uri) => launchUrl(uri, mode: LaunchMode.externalApplication),
);

class LearningResourcesScreen extends ConsumerStatefulWidget {
  const LearningResourcesScreen({super.key});

  @override
  ConsumerState<LearningResourcesScreen> createState() =>
      _LearningResourcesScreenState();
}

class _LearningResourcesScreenState
    extends ConsumerState<LearningResourcesScreen> {
  final _search = TextEditingController();
  ResourceType? _type;
  ResourceLevel? _level;
  String? _opening;

  @override
  void initState() {
    super.initState();
    _search.addListener(_rebuild);
  }

  void _rebuild() => setState(() {});

  @override
  void dispose() {
    _search.removeListener(_rebuild);
    _search.dispose();
    super.dispose();
  }

  Future<void> _open(LearningResource resource) async {
    if (_opening != null) return;
    setState(() => _opening = resource.id);
    var opened = false;
    try {
      opened = await ref.read(resourceOpenerProvider)(Uri.parse(resource.url));
    } catch (_) {
      // A missing browser or network connection can make the platform fail.
    }
    if (!mounted) return;
    setState(() => _opening = null);
    if (!opened) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open this resource. Try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final shown = learningResources
        .where(
          (resource) => resource.matches(
            search: _search.text,
            type: _type,
            level: _level,
          ),
        )
        .toList();
    return Scaffold(
      appBar: AppBar(title: const AppScreenTitle('Explore online')),
      body: WarmPageBackground(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const SunnyHero(
                  title: 'Explore Chinese',
                  subtitle: 'Read, watch and listen to things you enjoy.',
                  tag: 'Free online resources',
                  robot: RobotArtwork.squareOnPaper,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Choose something close to your level. You can return to a story or video as often as you like.',
                ),
                const SizedBox(height: 14),
                TextField(
                  key: const ValueKey('resource-search'),
                  controller: _search,
                  decoration: const InputDecoration(
                    labelText: 'Search resources',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 14),
                Text('Type', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 7),
                Wrap(
                  spacing: 7,
                  runSpacing: 5,
                  children: [
                    ChoiceChip(
                      label: const Text('All'),
                      selected: _type == null,
                      onSelected: (_) => setState(() => _type = null),
                    ),
                    for (final type in ResourceType.values)
                      ChoiceChip(
                        label: Text(_typeLabel(type)),
                        selected: _type == type,
                        onSelected: (_) => setState(() => _type = type),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text('Level', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 7),
                Wrap(
                  spacing: 7,
                  runSpacing: 5,
                  children: [
                    ChoiceChip(
                      label: const Text('Any level'),
                      selected: _level == null,
                      onSelected: (_) => setState(() => _level = null),
                    ),
                    for (final level in ResourceLevel.values)
                      ChoiceChip(
                        label: Text(_levelLabel(level)),
                        selected: _level == level,
                        onSelected: (_) => setState(() => _level = level),
                      ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  '${shown.length} resources',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (shown.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text('No resources match. Try another filter.'),
                  ),
                for (final resource in shown)
                  Card(
                    key: ValueKey('resource-${resource.id}'),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            resource.title,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 5),
                          Text(resource.description),
                          const SizedBox(height: 7),
                          Text(
                            '${_typeLabel(resource.type)} · '
                            '${resource.levels.map(_levelLabel).join(', ')} · '
                            '${resource.access}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 10),
                          FilledButton.tonalIcon(
                            onPressed: _opening == null
                                ? () => _open(resource)
                                : null,
                            icon: const Icon(Icons.open_in_new),
                            label: Text(
                              _opening == resource.id
                                  ? 'Opening…'
                                  : 'Open site',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 14),
                const Text(
                  'Links open the original site in your browser. An internet connection is needed; free access and availability can change.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _typeLabel(ResourceType type) => switch (type) {
  ResourceType.read => 'Read',
  ResourceType.watch => 'Watch',
  ResourceType.listen => 'Listen',
  ResourceType.music => 'Music',
  ResourceType.everyday => 'Everyday',
};

String _levelLabel(ResourceLevel level) => switch (level) {
  ResourceLevel.beginner => 'Beginner',
  ResourceLevel.intermediate => 'Intermediate',
  ResourceLevel.advanced => 'Advanced',
};
