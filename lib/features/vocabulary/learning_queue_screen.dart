import 'package:flutter/material.dart';

import '../../shared/app_brand.dart';

import '../../app/theme.dart';
import '../../shared/robot_art.dart';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'curriculum_repository.dart';
import 'add_word_screen.dart';
import 'learning_priority.dart';
import 'word_introduction_screen.dart';

class LearningQueueScreen extends ConsumerStatefulWidget {
  const LearningQueueScreen({
    required this.profileId,
    required this.showPinyin,
    super.key,
  });
  final int profileId;
  final bool showPinyin;
  @override
  ConsumerState<LearningQueueScreen> createState() =>
      _LearningQueueScreenState();
}

class _LearningQueueScreenState extends ConsumerState<LearningQueueScreen> {
  final _search = TextEditingController();
  final _scroll = ScrollController();
  List<QueueWord> _words = [];
  String? _selected, _error;
  String _query = '';
  bool _busy = true, _more = false;
  int _request = 0, _page = 0;
  int? _priority;
  WordCategory? _category;
  CurriculumRepository get repository => ref.read(curriculumRepositoryProvider);
  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _search.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _load({int page = 0}) async {
    final request = ++_request;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      var target = page;
      var result = await repository.page(
        widget.profileId,
        offset: target * 20,
        search: _query,
        priority: _priority,
        category: _category,
        priorityOrder: false,
      );
      // Completing the final word on a page can leave that page empty.
      while (target > 0 && result.words.isEmpty) {
        target--;
        result = await repository.page(
          widget.profileId,
          offset: target * 20,
          search: _query,
          priority: _priority,
          category: _category,
          priorityOrder: false,
        );
      }
      if (!mounted || request != _request) return;
      setState(() {
        _words = result.words;
        _more = result.hasMore;
        if (_page != target || !_words.any((w) => w.id == _selected)) {
          _selected = _words.firstOrNull?.id;
        }
        _page = target;
      });
      if (_scroll.hasClients) _scroll.jumpTo(0);
    } catch (_) {
      if (mounted && request == _request) {
        setState(() => _error = 'Could not load words. Please try again.');
      }
    } finally {
      if (mounted && request == _request) setState(() => _busy = false);
    }
  }

  Future<void> _filters() async {
    var priority = _priority;
    var category = _category;
    final apply = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, update) => AlertDialog(
          title: const Text('Word filters'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<int>(
                  key: const ValueKey('priority-filter'),
                  initialValue: priority ?? -1,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Priority'),
                  items: [
                    const DropdownMenuItem(
                      value: -1,
                      child: Text('All priorities'),
                    ),
                    for (var i = 0; i < LearningPriority.labels.length; i++)
                      DropdownMenuItem(
                        value: i,
                        child: Text(LearningPriority.labels[i]),
                      ),
                  ],
                  onChanged: (value) =>
                      update(() => priority = value == -1 ? null : value),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<int>(
                  key: const ValueKey('category-filter'),
                  initialValue: category?.index ?? -1,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: [
                    const DropdownMenuItem(
                      value: -1,
                      child: Text('All categories'),
                    ),
                    for (final c in WordCategory.values)
                      DropdownMenuItem(value: c.index, child: Text(c.label)),
                  ],
                  onChanged: (value) => update(
                    () => category = value == null || value == -1
                        ? null
                        : WordCategory.values[value],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                update(() {
                  priority = null;
                  category = null;
                });
              },
              child: const Text('Clear'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
    if (!mounted || apply != true) return;
    setState(() {
      _priority = priority;
      _category = category;
    });
    await _load();
  }

  Future<void> _learn() async {
    if (_selected == null || _busy) return;
    final id = _selected!;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final word = await repository.lesson(id);
      if (word == null) throw StateError('Missing lesson');
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => WordIntroductionScreen(
            word: word,
            showPinyin: widget.showPinyin,
            profileId: widget.profileId,
          ),
        ),
      );
      if (mounted) await _load(page: _page);
    } catch (_) {
      if (mounted)
        setState(() {
          _busy = false;
          _error = 'Could not open this lesson. Please retry.';
        });
    }
  }

  Future<void> _addWord() async {
    final result = await Navigator.of(context).push<AddedWordResult>(
      MaterialPageRoute(
        builder: (_) => AddWordScreen(profileId: widget.profileId),
      ),
    );
    if (!mounted || result == null) return;
    _search.clear();
    _query = '';
    setState(() {
      _priority = null;
      _category = null;
    });
    await _load();
    if (!mounted) return;
    if (_words.any((word) => word.id == result.id)) {
      setState(() => _selected = result.id);
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(result.message)));
    if (result.alreadyStarted) {
      _selected = result.id;
      await _learn();
    }
  }

  Future<void> _attribution() async {
    final text = await rootBundle.loadString('assets/content/ATTRIBUTION.txt');
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Content attribution'),
        content: SingleChildScrollView(child: SelectableText(text)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selected = _words.where((w) => w.id == _selected).firstOrNull;
    final filterLabel = [
      if (_priority != null) LearningPriority.labels[_priority!],
      if (_category != null) _category!.label,
    ].join(' / ');
    return Scaffold(
      appBar: AppBar(
        title: const AppScreenTitle('Learn words'),
        actions: [
          IconButton(
            tooltip: 'Content attribution',
            onPressed: _attribution,
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: Column(
            children: [
              if (MediaQuery.sizeOf(context).width >= 600 &&
                  MediaQuery.textScalerOf(context).scale(16) <= 24)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 2),
                  child: Row(
                    children: [
                      const RobotArt(
                        artwork: RobotArtwork.hoverOnPaper,
                        size: 62,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Learn',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w900,
                                color: AppColors.navy,
                              ),
                            ),
                            Text(
                              'Choose a word to discover next',
                              style: TextStyle(
                                color: AppColors.mutedInk,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.paleGreen,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'WORD BANK',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _search,
                        key: const ValueKey('queue-search'),
                        maxLength: 100,
                        decoration: InputDecoration(
                          labelText: 'Search words',
                          counterText: '',
                          hintText: 'Hanzi, Pinyin or meaning',
                          suffixIcon: IconButton(
                            tooltip: 'Search queue',
                            icon: const Icon(Icons.search),
                            onPressed: _busy
                                ? null
                                : () {
                                    _query = _search.text;
                                    _load();
                                  },
                          ),
                        ),
                        onSubmitted: (value) {
                          _query = value;
                          _load();
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filledTonal(
                      tooltip: filterLabel.isEmpty
                          ? 'Filter words'
                          : 'Filter words: $filterLabel',
                      onPressed: _busy ? null : _filters,
                      icon: Icon(
                        filterLabel.isEmpty
                            ? Icons.filter_list
                            : Icons.filter_alt,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    key: const ValueKey('add-custom-word'),
                    onPressed: _busy ? null : _addWord,
                    icon: const Icon(Icons.add),
                    label: const Text('Add word'),
                  ),
                ),
              ),
              if (filterLabel.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(filterLabel),
                ),
              if (_busy) const LinearProgressIndicator(),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(_error!),
                      TextButton(
                        onPressed: _busy ? null : () => _load(page: _page),
                        child: const Text('Try again'),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: _words.isEmpty && !_busy
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            _query.isEmpty && filterLabel.isEmpty
                                ? 'All words learned. Return to Vocabulary for reviews.'
                                : 'No matching words. Try another search or filter.',
                          ),
                        ),
                      )
                    : LayoutBuilder(
                        builder: (context, size) {
                          final scale =
                              MediaQuery.textScalerOf(context).scale(14) / 14;
                          final columns =
                              (size.maxWidth / (220 * scale.clamp(1, 1.5)))
                                  .floor()
                                  .clamp(1, 5);
                          final rows = (20 / columns).ceil();
                          final height =
                              ((size.maxHeight - 32 - (rows - 1) * 10) / rows)
                                  .clamp(110 * scale, 230 * scale);
                          return GridView.builder(
                            controller: _scroll,
                            padding: const EdgeInsets.all(16),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: columns,
                                  mainAxisExtent: height,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                            itemCount: _words.length,
                            itemBuilder: (context, index) {
                              final word = _words[index];
                              final active = word.id == _selected;
                              final colors = Theme.of(context).colorScheme;
                              return Semantics(
                                selected: active,
                                button: true,
                                child: Material(
                                  color: active
                                      ? colors.primaryContainer
                                      : colors.surface,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    side: BorderSide(
                                      color: active
                                          ? colors.primary
                                          : colors.outlineVariant,
                                      width: active ? 2 : 1,
                                    ),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: InkWell(
                                    key: ValueKey('queue-${word.id}'),
                                    onTap: _busy
                                        ? null
                                        : () => setState(
                                            () => _selected = word.id,
                                          ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  word.hanzi,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge,
                                                ),
                                              ),
                                              if (active)
                                                Icon(
                                                  Icons.check_circle,
                                                  size: 20,
                                                  color: colors.primary,
                                                ),
                                            ],
                                          ),
                                          if (widget.showPinyin)
                                            Text(
                                              word.pinyin,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          const SizedBox(height: 4),
                                          Expanded(
                                            child: Tooltip(
                                              message: word.meaning,
                                              child: Text(
                                                word.meaning,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            tooltip: 'Previous 20 words',
                            onPressed: _busy || _page == 0
                                ? null
                                : () => _load(page: _page - 1),
                            icon: const Icon(Icons.chevron_left),
                          ),
                          Text('Page ${_page + 1}'),
                          IconButton(
                            tooltip: 'Next 20 words',
                            onPressed: _busy || !_more
                                ? null
                                : () => _load(page: _page + 1),
                            icon: const Icon(Icons.chevron_right),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          key: const ValueKey('learn-selected'),
                          onPressed: _busy || selected == null ? null : _learn,
                          child: Text(
                            selected == null
                                ? 'Learn selected word'
                                : 'Learn ${selected.hanzi}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
