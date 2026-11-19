import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/context_tour.dart';
import 'curriculum_repository.dart';
import 'custom_word.dart';
import 'learning_keyboard.dart';

class EditCustomWordScreen extends ConsumerStatefulWidget {
  const EditCustomWordScreen({
    required this.profileId,
    required this.wordId,
    super.key,
  });

  final int profileId;
  final String wordId;

  @override
  ConsumerState<EditCustomWordScreen> createState() =>
      _EditCustomWordScreenState();
}

class _EditCustomWordScreenState extends ConsumerState<EditCustomWordScreen> {
  final _wordTarget = GlobalKey();
  final _examplesTarget = GlobalKey();
  final _saveTarget = GlobalKey();
  final _hanzi = TextEditingController();
  final _pinyin = TextEditingController();
  final _meaning = TextEditingController();
  final _sentences = List.generate(5, (_) => TextEditingController());
  final _sentencePinyin = List.generate(5, (_) => TextEditingController());
  final _translations = List.generate(5, (_) => TextEditingController());
  final _explanation = TextEditingController();
  LearningKeyboardMode _keyboardMode = LearningKeyboardMode.hanzi;
  bool _loading = true;
  bool _saving = false;
  bool _available = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final draft = await ref
          .read(curriculumRepositoryProvider)
          .editableCustomWord(widget.profileId, widget.wordId);
      if (!mounted) return;
      if (draft == null) {
        setState(() {
          _error = 'This custom word is unavailable for editing.';
          _loading = false;
        });
        return;
      }
      _hanzi.text = draft.hanzi;
      _pinyin.text = draft.pinyin;
      _meaning.text = draft.meaning;
      for (var i = 0; i < 5; i++) {
        _sentences[i].text = draft.examples[i].hanzi;
        _sentencePinyin[i].text = draft.examples[i].pinyin;
        _translations[i].text = draft.examples[i].meaning;
      }
      _explanation.text = draft.explanation;
      setState(() {
        _available = true;
        _loading = false;
      });
    } catch (_) {
      if (mounted)
        setState(() {
          _error = 'Could not load this word. Try opening it again.';
          _loading = false;
        });
    }
  }

  @override
  void dispose() {
    for (final controller in [
      _hanzi,
      _pinyin,
      _meaning,
      ..._sentences,
      ..._sentencePinyin,
      ..._translations,
      _explanation,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final draft = CustomWordDraft(
        hanzi: _hanzi.text,
        pinyin: _pinyin.text,
        meaning: _meaning.text,
        examples: [
          for (var i = 0; i < 5; i++)
            CustomSentence(
              _sentences[i].text,
              _sentencePinyin[i].text,
              _translations[i].text,
            ),
        ],
        explanation: _explanation.text,
      );
      await ref
          .read(curriculumRepositoryProvider)
          .updateCustomWord(widget.profileId, widget.wordId, draft);
      if (mounted) Navigator.pop(context, true);
    } on CustomWordConflict catch (error) {
      if (mounted)
        setState(
          () => _error =
              '${error.clash.fields.join(', ')} matches ${error.clash.word.hanzi}. Choose a different word, Pinyin, or meaning.',
        );
    } on FormatException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } catch (_) {
      if (mounted)
        setState(() => _error = 'Could not save this word. Please retry.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Edit custom word'),
      actions: [
        IconButton(
          tooltip: 'Page tutorial',
          onPressed: _loading
              ? null
              : () => showContextTour(context, [
                  TourStop(
                    _wordTarget,
                    'Edit the word',
                    'Change its Hanzi, Pinyin, or English meaning.',
                  ),
                  TourStop(
                    _examplesTarget,
                    'Edit five examples',
                    'Each Chinese sentence must use the word. Include Pinyin and an English translation.',
                  ),
                  TourStop(
                    _saveTarget,
                    'Save changes',
                    'The lesson and its questions update. Your progress stays with this word.',
                  ),
                ]),
          icon: const Icon(Icons.help_outline),
        ),
      ],
    ),
    body: _loading
        ? const Center(child: CircularProgressIndicator())
        : Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Text(
                    'Edit your word and examples',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Changes to a word you already studied keep its progress.',
                  ),
                  const SizedBox(height: 16),
                  LearningKeyboard(
                    key: _wordTarget,
                    hanzi: _hanzi,
                    pinyin: _pinyin,
                    english: _meaning,
                    hanziKey: const ValueKey('edit-custom-hanzi'),
                    pinyinKey: const ValueKey('edit-custom-pinyin'),
                    englishKey: const ValueKey('edit-custom-meaning'),
                    hanziLabel: 'Word in Hanzi',
                    pinyinLabel: 'Word Pinyin',
                    englishLabel: 'English meaning',
                    enabled: !_saving,
                  ),
                  const Divider(height: 32),
                  for (var i = 0; i < 5; i++) ...[
                    Text(
                      'Sentence ${i + 1}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    KeyedSubtree(
                      key: i == 0 ? _examplesTarget : null,
                      child: LearningKeyboard(
                        key: ValueKey('edit-example-input-$i'),
                        hanzi: _sentences[i],
                        pinyin: _sentencePinyin[i],
                        english: _translations[i],
                        initialMode: _keyboardMode,
                        onModeChanged: (mode) =>
                            setState(() => _keyboardMode = mode),
                        hanziKey: ValueKey('edit-example-hanzi-$i'),
                        pinyinKey: ValueKey('edit-example-pinyin-$i'),
                        englishKey: ValueKey('edit-example-english-$i'),
                        hanziLabel: 'Chinese sentence',
                        pinyinLabel: 'Sentence Pinyin',
                        englishLabel: 'English translation',
                        hanziMaxLength: 500,
                        hanziMaxLines: 2,
                        enabled: !_saving,
                      ),
                    ),
                    const Divider(height: 32),
                  ],
                  TextField(
                    key: const ValueKey('edit-custom-explanation'),
                    controller: _explanation,
                    enabled: !_saving,
                    maxLength: 2000,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'English explanation (optional)',
                    ),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _error!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    key: _saveTarget,
                    onPressed: _saving || !_available ? null : _save,
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('Save changes'),
                  ),
                ],
              ),
            ),
          ),
  );
}
