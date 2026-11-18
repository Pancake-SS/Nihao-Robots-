import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/app_brand.dart';
import '../../shared/cozy_ui.dart';
import '../../shared/context_tour.dart';
import '../../shared/robot_art.dart';
import 'classical_stories.dart';
import 'learning_resources_screen.dart';

class ClassicalStoriesScreen extends ConsumerWidget {
  const ClassicalStoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stories = ref.watch(classicalStoriesProvider);
    return Scaffold(
      appBar: AppBar(title: const AppScreenTitle('Classical stories')),
      body: WarmPageBackground(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: stories.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Could not load the stories.'),
                    TextButton(
                      onPressed: () => ref.invalidate(classicalStoriesProvider),
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              ),
              data: (collections) => ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const SunnyHero(
                    title: 'Stories from Chinese classics',
                    subtitle: 'Short parables and longer Daoist chapters.',
                    tag: 'Read offline',
                    robot: RobotArtwork.tallOnPaper,
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'These works use Classical Chinese. Start with a short parable, or explore a chapter at your own pace.',
                  ),
                  const SizedBox(height: 14),
                  for (final collection in collections)
                    Card(
                      child: ListTile(
                        key: ValueKey('classic-${collection.id}'),
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(collection.title),
                        subtitle: Text(
                          '${collection.description} · ${collection.chapters.length} readings',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                ClassicCollectionScreen(collection: collection),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ClassicCollectionScreen extends StatefulWidget {
  const ClassicCollectionScreen({required this.collection, super.key});

  final ClassicCollection collection;

  @override
  State<ClassicCollectionScreen> createState() =>
      _ClassicCollectionScreenState();
}

class _ClassicCollectionScreenState extends State<ClassicCollectionScreen> {
  final _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    _search.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    _search.removeListener(_refresh);
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final collection = widget.collection;
    final query = _search.text.trim().toLowerCase();
    final shown = collection.chapters.asMap().entries.where((entry) {
      return query.isEmpty || entry.value.title.toLowerCase().contains(query);
    }).toList();
    return Scaffold(
      appBar: AppBar(title: AppScreenTitle(collection.title)),
      body: WarmPageBackground(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        collection.description,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(collection.credit),
                      const SizedBox(height: 8),
                      TextField(
                        key: const ValueKey('classic-search'),
                        controller: _search,
                        decoration: const InputDecoration(
                          labelText: 'Find a story or chapter',
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('${shown.length} readings'),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    itemCount: shown.length,
                    itemBuilder: (context, visibleIndex) {
                      final entry = shown[visibleIndex];
                      return Card(
                        child: ListTile(
                          key: ValueKey('chapter-${entry.value.id}'),
                          title: Text(entry.value.title),
                          leading: Text('${entry.key + 1}'),
                          trailing: const Icon(Icons.menu_book_outlined),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => ClassicReaderScreen(
                                collection: collection,
                                initialIndex: entry.key,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ClassicReaderScreen extends ConsumerStatefulWidget {
  const ClassicReaderScreen({
    required this.collection,
    required this.initialIndex,
    super.key,
  });

  final ClassicCollection collection;
  final int initialIndex;

  @override
  ConsumerState<ClassicReaderScreen> createState() =>
      _ClassicReaderScreenState();
}

class _ClassicReaderScreenState extends ConsumerState<ClassicReaderScreen> {
  final _languageTarget = GlobalKey();
  final _sizeTarget = GlobalKey();
  final _navigationTarget = GlobalKey();
  late int _index;
  final _scroll = ScrollController();
  double _textSize = 22;
  bool _english = false;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _move(int delta) {
    if (_scroll.hasClients) _scroll.jumpTo(0);
    setState(() => _index += delta);
  }

  Future<void> _openSource(String url) async {
    try {
      if (await ref.read(resourceOpenerProvider)(Uri.parse(url))) return;
    } catch (_) {
      // The browser may be unavailable or the network may be offline.
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open Wikisource. Try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final chapter = widget.collection.chapters[_index];
    final paragraphs = _english
        ? chapter.englishParagraphs
        : chapter.paragraphs;
    return Scaffold(
      appBar: AppBar(
        title: AppScreenTitle(chapter.title),
        actions: [
          IconButton(
            tooltip: 'View source',
            onPressed: () => _openSource(
              _english ? chapter.englishSourceUrl : chapter.sourceUrl,
            ),
            icon: const Icon(Icons.open_in_new),
          ),
          IconButton(
            tooltip: 'Page tutorial',
            onPressed: () => showContextTour(context, [
              TourStop(
                _languageTarget,
                'Switch languages',
                'Read the original Chinese or an attributed English translation of this chapter.',
              ),
              TourStop(
                _sizeTarget,
                'Adjust text size',
                'Make the reading text larger or smaller.',
              ),
              TourStop(
                _navigationTarget,
                'Keep reading',
                'Move to the previous or next story in this collection.',
              ),
            ]),
            icon: const Icon(Icons.help_outline),
          ),
          IconButton(
            tooltip: 'Smaller text',
            onPressed: _textSize <= 18
                ? null
                : () => setState(() => _textSize -= 2),
            icon: const Icon(Icons.text_decrease),
          ),
          IconButton(
            key: _sizeTarget,
            tooltip: 'Larger text',
            onPressed: _textSize >= 30
                ? null
                : () => setState(() => _textSize += 2),
            icon: const Icon(Icons.text_increase),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            key: _navigationTarget,
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _index == 0 ? null : () => _move(-1),
                  icon: const Icon(Icons.chevron_left),
                  label: const Text('Previous'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.icon(
                  onPressed: _index + 1 == widget.collection.chapters.length
                      ? null
                      : () => _move(1),
                  icon: const Icon(Icons.chevron_right),
                  label: const Text('Next'),
                ),
              ),
            ],
          ),
        ),
      ),
      body: WarmPageBackground(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.all(22),
              itemCount: paragraphs.length + 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.collection.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(widget.collection.credit),
                      Text(
                        '${_index + 1} of ${widget.collection.chapters.length}',
                      ),
                      const SizedBox(height: 12),
                      KeyedSubtree(
                        key: _languageTarget,
                        child: SegmentedButton<bool>(
                          key: const ValueKey('classic-language'),
                          segments: const [
                            ButtonSegment(value: false, label: Text('Chinese')),
                            ButtonSegment(value: true, label: Text('English')),
                          ],
                          selected: {_english},
                          onSelectionChanged: chapter.englishParagraphs.isEmpty
                              ? null
                              : (selection) {
                                  if (_scroll.hasClients) _scroll.jumpTo(0);
                                  setState(() => _english = selection.first);
                                },
                        ),
                      ),
                      if (_english) ...[
                        const SizedBox(height: 12),
                        Text(chapter.englishCredit),
                        Text('License: ${chapter.englishLicense}'),
                      ],
                      const SizedBox(height: 14),
                    ],
                  );
                }
                if (index == paragraphs.length + 1) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 18, bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _english
                              ? chapter.englishCredit
                              : 'Classical Chinese · simplified rendering',
                        ),
                        const SizedBox(height: 7),
                        TextButton.icon(
                          onPressed: () => _openSource(
                            _english
                                ? chapter.englishSourceUrl
                                : chapter.sourceUrl,
                          ),
                          icon: const Icon(Icons.open_in_new),
                          label: Text(
                            _english
                                ? 'View English source'
                                : 'View source on Wikisource',
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: SelectableText(
                    paragraphs[index - 1],
                    style: TextStyle(fontSize: _textSize, height: 1.75),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
