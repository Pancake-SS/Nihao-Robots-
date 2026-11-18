import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/app_database.dart';
import '../../shared/app_brand.dart';
import '../../shared/cozy_ui.dart';
import '../../shared/learning_card.dart';
import '../../shared/robot_art.dart';
import '../vocabulary/learning_keyboard.dart';
import 'learning_journal_repository.dart';
import 'writing_prompts.dart';

typedef _EntryPage = ({List<LearningEntry> entries, int total});

class LearningJournalScreen extends ConsumerStatefulWidget {
  const LearningJournalScreen({
    required this.profileId,
    required this.kind,
    super.key,
  });

  final int profileId;
  final LearningEntryKind kind;

  @override
  ConsumerState<LearningJournalScreen> createState() =>
      _LearningJournalScreenState();
}

class _LearningJournalScreenState extends ConsumerState<LearningJournalScreen> {
  final _search = TextEditingController();
  late Future<_EntryPage> _results;
  int _page = 0;

  bool get _writing => widget.kind == LearningEntryKind.writing;

  @override
  void initState() {
    super.initState();
    _results = _load();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<_EntryPage> _load() async {
    final repo = ref.read(learningJournalRepositoryProvider);
    final entries = await repo.list(
      widget.profileId,
      widget.kind,
      page: _page,
      search: _search.text,
    );
    final total = await repo.count(
      widget.profileId,
      widget.kind,
      search: _search.text,
    );
    return (entries: entries, total: total);
  }

  void _refresh({bool firstPage = false}) => setState(() {
    if (firstPage) _page = 0;
    _results = _load();
  });

  Future<void> _edit([LearningEntry? entry]) async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => LearningEntryEditor(
          profileId: widget.profileId,
          kind: widget.kind,
          entry: entry,
          initialPrompt: _writing && entry == null
              ? randomWritingPrompt()
              : null,
        ),
      ),
    );
    if (changed == true && mounted) _refresh(firstPage: true);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: AppScreenTitle(_writing ? 'Free writing' : 'Notebook'),
    ),
    body: WarmPageBackground(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              SunnyHero(
                title: _writing ? 'Write freely' : 'Your notebook',
                subtitle: _writing
                    ? 'A new topic each time. Write as much or as little as you like.'
                    : 'Keep your Chinese notes, ideas and ramblings together.',
                tag: _writing ? 'Creative practice' : 'Personal notes',
                robot: _writing
                    ? RobotArtwork.hoverOnPaper
                    : RobotArtwork.tallOnPaper,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                key: const ValueKey('new-learning-entry'),
                onPressed: () => _edit(),
                icon: const Icon(Icons.add),
                label: Text(_writing ? 'New writing' : 'New note'),
              ),
              const SizedBox(height: 16),
              TextField(
                key: const ValueKey('learning-entry-search'),
                controller: _search,
                onSubmitted: (_) => _refresh(firstPage: true),
                decoration: InputDecoration(
                  labelText: _writing ? 'Search your writing' : 'Search notes',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    tooltip: 'Search saved entries',
                    onPressed: () => _refresh(firstPage: true),
                    icon: const Icon(Icons.arrow_forward),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              FutureBuilder<_EntryPage>(
                future: _results,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError || snapshot.data == null) {
                    return TextButton(
                      onPressed: _refresh,
                      child: const Text(
                        'Could not load saved entries. Try again.',
                      ),
                    );
                  }
                  final data = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '${data.total} saved ${_writing ? 'pieces' : 'notes'}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      if (data.entries.isEmpty)
                        LearningCard(
                          child: Text(
                            _search.text.isNotEmpty
                                ? 'Nothing matches this search.'
                                : _writing
                                ? 'Your writing will appear here after you save it.'
                                : 'Your notes will appear here after you save one.',
                          ),
                        ),
                      for (final entry in data.entries)
                        Card(
                          child: ListTile(
                            key: ValueKey('learning-entry-${entry.id}'),
                            title: Text(entry.title),
                            subtitle: Text(
                              _preview(entry),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => _edit(entry),
                          ),
                        ),
                      if (data.total > 20)
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            TextButton(
                              onPressed: _page == 0
                                  ? null
                                  : () {
                                      _page--;
                                      _refresh();
                                    },
                              child: const Text('Previous 20'),
                            ),
                            Text(
                              'Page ${_page + 1} of ${(data.total + 19) ~/ 20}',
                            ),
                            TextButton(
                              onPressed: (_page + 1) * 20 >= data.total
                                  ? null
                                  : () {
                                      _page++;
                                      _refresh();
                                    },
                              child: const Text('Next 20'),
                            ),
                          ],
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );

  String _preview(LearningEntry entry) {
    final body = [
      entry.hanzi,
      entry.pinyin,
      entry.english,
    ].firstWhere((text) => text.isNotEmpty, orElse: () => '');
    return _writing ? '${entry.prompt}\n$body' : body;
  }
}

class LearningEntryEditor extends ConsumerStatefulWidget {
  const LearningEntryEditor({
    required this.profileId,
    required this.kind,
    this.entry,
    this.initialPrompt,
    super.key,
  });

  final int profileId;
  final LearningEntryKind kind;
  final LearningEntry? entry;
  final String? initialPrompt;

  @override
  ConsumerState<LearningEntryEditor> createState() =>
      _LearningEntryEditorState();
}

class _LearningEntryEditorState extends ConsumerState<LearningEntryEditor> {
  late final TextEditingController _title, _hanzi, _pinyin, _english;
  late String _prompt;
  bool _dirty = false, _saving = false, _allowPop = false;
  String? _error;

  bool get _writing => widget.kind == LearningEntryKind.writing;

  @override
  void initState() {
    super.initState();
    _prompt = widget.entry?.prompt ?? widget.initialPrompt ?? '';
    _title = TextEditingController(
      text: widget.entry?.title ?? (_writing ? _prompt : ''),
    );
    _hanzi = TextEditingController(text: widget.entry?.hanzi ?? '');
    _pinyin = TextEditingController(text: widget.entry?.pinyin ?? '');
    _english = TextEditingController(text: widget.entry?.english ?? '');
    for (final controller in [_title, _hanzi, _pinyin, _english]) {
      controller.addListener(_markDirty);
    }
  }

  void _markDirty() {
    if (!_dirty) setState(() => _dirty = true);
  }

  @override
  void dispose() {
    _title.dispose();
    _hanzi.dispose();
    _pinyin.dispose();
    _english.dispose();
    super.dispose();
  }

  void _exit(bool changed) {
    setState(() => _allowPop = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) Navigator.of(context).pop(changed);
    });
  }

  Future<void> _leave() async {
    if (_saving) return;
    if (!_dirty) {
      _exit(false);
      return;
    }
    final discard = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard your changes?'),
        content: const Text('Your unsaved text will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep editing'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    if (discard == true && mounted) _exit(false);
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref
          .read(learningJournalRepositoryProvider)
          .save(
            widget.profileId,
            LearningEntryDraft(
              kind: widget.kind,
              title: _title.text,
              prompt: _writing ? _prompt : '',
              hanzi: _hanzi.text,
              pinyin: _pinyin.text,
              english: _english.text,
            ),
            id: widget.entry?.id,
          );
      if (mounted) _exit(true);
    } catch (error) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = error is ArgumentError
              ? '${error.message}'
              : 'Could not save this entry. Try again.';
        });
      }
    }
  }

  Future<void> _delete() async {
    final entry = widget.entry;
    if (entry == null || _saving) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete this entry?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _saving = true);
    try {
      await ref
          .read(learningJournalRepositoryProvider)
          .delete(widget.profileId, entry.id);
      if (mounted) _exit(true);
    } catch (_) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = 'Could not delete this entry. Try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: _allowPop,
    onPopInvokedWithResult: (didPop, _) {
      if (!didPop) _leave();
    },
    child: Scaffold(
      appBar: AppBar(
        title: AppScreenTitle(_writing ? 'Free writing' : 'Notebook page'),
        actions: [
          if (widget.entry != null)
            IconButton(
              tooltip: 'Delete entry',
              onPressed: _saving ? null : _delete,
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: Align(
            alignment: Alignment.center,
            heightFactor: 1,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 850),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  key: const ValueKey('save-learning-entry'),
                  onPressed: _saving ? null : _save,
                  icon: const Icon(Icons.save_outlined),
                  label: Text(_saving ? 'Saving…' : 'Save'),
                ),
              ),
            ),
          ),
        ),
      ),
      body: WarmPageBackground(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 850),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                if (_writing) ...[
                  LearningCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your topic',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(_prompt, key: const ValueKey('writing-prompt')),
                        if (widget.entry == null)
                          TextButton.icon(
                            onPressed: _saving
                                ? null
                                : () => setState(() {
                                    final old = _prompt;
                                    _prompt = randomWritingPrompt(
                                      excluding: old,
                                    );
                                    if (_title.text == old) {
                                      _title.text = _prompt;
                                    }
                                    _dirty = true;
                                  }),
                            icon: const Icon(Icons.shuffle),
                            label: const Text('Another topic'),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
                TextField(
                  key: const ValueKey('learning-entry-title'),
                  controller: _title,
                  enabled: !_saving,
                  maxLength: 120,
                  decoration: InputDecoration(
                    labelText: _writing ? 'Title' : 'Note title',
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Write in Hanzi, Pinyin or English. The Chinese keyboard works directly in the editor; All mode adds editable dictionary hints in the other fields.',
                ),
                const SizedBox(height: 12),
                LearningKeyboard(
                  hanzi: _hanzi,
                  pinyin: _pinyin,
                  english: _english,
                  hanziKey: const ValueKey('entry-hanzi'),
                  pinyinKey: const ValueKey('entry-pinyin'),
                  englishKey: const ValueKey('entry-english'),
                  enabled: !_saving,
                  hanziLabel: 'Chinese writing',
                  pinyinLabel: 'Pinyin notes',
                  englishLabel: 'English notes',
                  hanziHint:
                      'Type Pinyin and choose Hanzi, or paste Chinese text',
                  hanziMaxLength: 10000,
                  pinyinMaxLength: 10000,
                  englishMaxLength: 10000,
                  hanziMaxLines: 8,
                  pinyinMaxLines: 6,
                  englishMaxLines: 6,
                ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      _error!,
                      key: const ValueKey('entry-save-error'),
                    ),
                  ),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
