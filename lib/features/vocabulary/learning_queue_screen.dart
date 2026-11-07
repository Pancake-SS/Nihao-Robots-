import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'curriculum_repository.dart';
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
  int _request = 0;
  CurriculumRepository get repository => ref.read(curriculumRepositoryProvider);
  @override
  void initState() {
    super.initState();
    _load(reset: true);
  }

  @override
  void dispose() {
    _search.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _load({bool reset = false, int? pages}) async {
    final request = ++_request;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final result = reset ? <QueueWord>[] : [..._words];
      var more = false;
      for (var page = 0; page < (pages ?? 1); page++) {
        final next = await repository.page(
          widget.profileId,
          offset: result.length,
          search: _query,
        );
        result.addAll(next.words);
        more = next.hasMore;
        if (!more) break;
      }
      if (!mounted || request != _request) return;
      setState(() {
        _words = result;
        _more = more;
        if (!_words.any((w) => w.id == _selected))
          _selected = _words.firstOrNull?.id;
      });
    } catch (_) {
      if (mounted && request == _request)
        setState(
          () => _error = 'Could not load the queue. Your saved order and progress are retained.',
        );
    } finally {
      if (mounted && request == _request) setState(() => _busy = false);
    }
  }

  Future<void> _move(String direction) async {
    if (_selected == null || _busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await repository.move(widget.profileId, _selected!, direction);
      await _load(reset: true, pages: (_words.length / 20).ceil());
    } catch (_) {
      if (mounted)
        setState(() {
          _busy = false;
          _error = 'Could not change the queue. Please retry.';
        });
    }
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
      if (mounted) await _load(reset: true, pages: (_words.length / 20).ceil());
    } catch (_) {
      if (mounted)
        setState(() {
          _busy = false;
          _error = 'Could not open this lesson. Please retry.';
        });
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
    final index = _words.indexWhere((w) => w.id == _selected);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning queue'),
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
          constraints: const BoxConstraints(maxWidth: 960),
          child: CustomScrollView(
            controller: _scroll,
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Basics come first. Select a word to learn it now, or move it in your queue.',
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _search,
                        key: const ValueKey('queue-search'),
                        maxLength: 100,
                        decoration: InputDecoration(
                          labelText: 'Search Hanzi, Pinyin or meaning',
                          counterText: '',
                          suffixIcon: IconButton(
                            tooltip: 'Search queue',
                            icon: const Icon(Icons.search),
                            onPressed: _busy
                                ? null
                                : () {
                                    _query = _search.text;
                                    _load(reset: true);
                                  },
                          ),
                        ),
                        onSubmitted: (value) {
                          _query = value;
                          _load(reset: true);
                        },
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          FilledButton(
                            key: const ValueKey('learn-selected'),
                            onPressed: _busy || selected == null
                                ? null
                                : _learn,
                            child: Text(
                              selected == null
                                  ? 'Learn selected word'
                                  : 'Learn ${selected.hanzi}',
                            ),
                          ),
                          OutlinedButton(
                            onPressed: _busy || index < 1
                                ? null
                                : () => _move('up'),
                            child: const Text('Move up'),
                          ),
                          OutlinedButton(
                            onPressed:
                                _busy || index < 0 || index == _words.length - 1
                                ? null
                                : () => _move('down'),
                            child: const Text('Move down'),
                          ),
                          OutlinedButton(
                            onPressed: _busy || selected == null
                                ? null
                                : () => _move('front'),
                            child: const Text('Move to front'),
                          ),
                          TextButton(
                            onPressed: _busy
                                ? null
                                : () async {
                                    setState(() {
                                      _busy = true;
                                      _error = null;
                                    });
                                    try {
                                      await repository.reset(widget.profileId);
                                      if (mounted) await _load(reset: true);
                                    } catch (_) {
                                      if (mounted)
                                        setState(() {
                                          _busy = false;
                                          _error = 'Could not restore the default order.';
                                        });
                                    }
                                  },
                            child: const Text('Restore priority order'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text('${_words.length} words shown · 20 at a time'),
                      if (_busy) const LinearProgressIndicator(),
                      if (_error != null) ...[
                        Text(_error!, semanticsLabel: _error),
                        TextButton(
                          onPressed: _busy ? null : () => _load(reset: true),
                          child: const Text('Try again'),
                        ),
                      ],
                      if (!_busy && _words.isEmpty && _error == null)
                        Text(
                          _query.isEmpty
                              ? 'Your queue is complete. Open Vocabulary Practice for scheduled reviews.'
                              : 'No matching words.',
                        ),
                    ],
                  ),
                ),
              ),
              SliverList.builder(
                itemCount: _words.length,
                itemBuilder: (context, index) {
                  final word = _words[index];
                  final selected = word.id == _selected;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 3,
                    ),
                    child: Material(
                      color: selected
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(context).colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: selected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).dividerColor,
                          width: selected ? 2 : 1,
                        ),
                      ),
                      child: ListTile(
                        key: ValueKey('queue-${word.id}'),
                        selected: selected,
                        leading: Icon(
                          selected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                        ),
                        title: Text('${index + 1}. ${word.hanzi}'),
                        subtitle: Text(
                          '${widget.showPinyin ? '${word.pinyin} · ' : ''}${word.meaning}',
                        ),
                        onTap: _busy
                            ? null
                            : () => setState(() => _selected = word.id),
                      ),
                    ),
                  );
                },
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      if (_more)
                        OutlinedButton(
                          onPressed: _busy ? null : () => _load(),
                          child: const Text('See 20 more'),
                        ),
                      if (selected != null)
                        TextButton(
                          onPressed: () => _scroll.animateTo(
                            0,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOut,
                          ),
                          child: Text('Back to Learn ${selected.hanzi}'),
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
