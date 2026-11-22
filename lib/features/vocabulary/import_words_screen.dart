import 'dart:convert';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/app_brand.dart';
import '../../shared/context_tour.dart';
import 'add_word_screen.dart';
import 'curriculum_repository.dart';
import 'custom_word.dart';
import 'custom_word_csv.dart';
import 'pinyin_input.dart';

class ImportWordsScreen extends ConsumerStatefulWidget {
  const ImportWordsScreen({required this.profileId, super.key});
  final int profileId;

  @override
  ConsumerState<ImportWordsScreen> createState() => _ImportWordsScreenState();
}

class _ImportWordsScreenState extends ConsumerState<ImportWordsScreen> {
  final _requested = TextEditingController();
  final _csv = TextEditingController();
  final _promptTarget = GlobalKey();
  final _csvTarget = GlobalKey();
  final _checkTarget = GlobalKey();
  List<CustomWordDraft>? _drafts;
  List<CustomWordClash?>? _clashes;
  String? _error;
  bool _busy = false;

  static const _fileType = XTypeGroup(
    label: 'CSV or text',
    extensions: ['csv', 'txt'],
    mimeTypes: ['text/csv', 'text/plain'],
  );

  @override
  void initState() {
    super.initState();
    _csv.addListener(_clearPreview);
  }

  void _clearPreview() {
    if (_drafts != null || _error != null) {
      setState(() {
        _drafts = null;
        _clashes = null;
        _error = null;
      });
    }
  }

  @override
  void dispose() {
    _csv.removeListener(_clearPreview);
    _requested.dispose();
    _csv.dispose();
    super.dispose();
  }

  void _notice(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _copy(String value, String success) async {
    try {
      await Clipboard.setData(ClipboardData(text: value));
      if (mounted) _notice(success);
    } catch (_) {
      if (mounted) setState(() => _error = 'Could not copy text. Try again.');
    }
  }

  Future<void> _chooseFile() async {
    if (_busy) return;
    try {
      final file = await openFile(acceptedTypeGroups: [_fileType]);
      if (file == null) return;
      final bytes = await file.readAsBytes();
      if (bytes.length > CustomWordCsv.maxCharacters * 4) {
        throw const FormatException('The CSV file is too large.');
      }
      final source = utf8.decode(bytes);
      if (source.length > CustomWordCsv.maxCharacters) {
        throw const FormatException('The CSV file is too large.');
      }
      _csv.text = source;
      if (mounted) _notice('CSV loaded. Review it, then check the words.');
    } on FormatException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } catch (_) {
      if (mounted)
        setState(() => _error = 'Could not read that file. Try again.');
    }
  }

  Future<void> _check() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = null;
      _drafts = null;
      _clashes = null;
    });
    try {
      final drafts = CustomWordCsv.parse(_csv.text);
      final repo = ref.read(curriculumRepositoryProvider);
      final clashes = <CustomWordClash?>[];
      for (final draft in drafts) {
        clashes.add(
          await repo.findCustomClash(
            widget.profileId,
            draft.hanzi,
            draft.pinyin,
            draft.meaning,
          ),
        );
      }
      if (mounted) {
        setState(() {
          _drafts = drafts;
          _clashes = clashes;
        });
      }
    } on FormatException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'Could not check these words. Try again.');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _import() async {
    final drafts = _drafts;
    if (_busy || drafts == null || _clashes!.any((clash) => clash != null))
      return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final saved = await ref
          .read(curriculumRepositoryProvider)
          .importCustomWords(widget.profileId, drafts);
      if (mounted) {
        Navigator.pop(
          context,
          AddedWordResult(
            saved.first.id,
            '${saved.length} ${saved.length == 1 ? 'word' : 'words'} imported to the front of your queue.',
            openLesson: saved.length == 1,
          ),
        );
      }
    } on CustomWordConflict catch (error) {
      if (mounted) {
        setState(
          () => _error =
              '${error.clash.word.hanzi} already matches an existing word (${error.clash.fields.join(', ')}). No words were imported.',
        );
      }
    } on FormatException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } catch (_) {
      if (mounted) {
        setState(
          () => _error = 'Import failed. No words were imported. Try again.',
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  bool _sameWord(CustomWordDraft draft, CustomWordClash clash) =>
      draft.hanzi.trim() == clash.word.hanzi &&
      PinyinInputEngine.normalize(draft.pinyin) ==
          PinyinInputEngine.normalize(clash.word.pinyin);

  Future<void> _saveExamplesToMatch() async {
    if (_busy || _clashes?.length != 1) return;
    final clash = _clashes!.single;
    final draft = _drafts?.single;
    if (clash == null || draft == null || !_sameWord(draft, clash)) return;
    setState(() => _busy = true);
    try {
      final repo = ref.read(curriculumRepositoryProvider);
      if (clash.word.id.startsWith('custom.p${widget.profileId}.')) {
        await repo.updateCustomWord(widget.profileId, clash.word.id, draft);
      } else {
        await repo.attachExamplesToExistingWord(
          widget.profileId,
          clash.word.id,
          draft,
        );
      }
      await repo.bringToFront(widget.profileId, clash.word.id);
      if (mounted) {
        Navigator.pop(
          context,
          AddedWordResult(
            clash.word.id,
            'Saved your five examples for ${clash.word.hanzi}. Open its lesson to read them.',
            alreadyStarted: clash.alreadyStarted,
            openLesson: true,
          ),
        );
      }
    } catch (_) {
      if (mounted)
        setState(() => _error = 'Could not save the examples. Try again.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final drafts = _drafts;
    final clashes = _clashes;
    final hasClash = clashes?.any((clash) => clash != null) ?? false;
    final matchingWord =
        drafts?.length == 1 &&
        clashes?.length == 1 &&
        clashes!.single != null &&
        _sameWord(drafts!.single, clashes.single!);
    return Scaffold(
      appBar: AppBar(
        title: const AppScreenTitle('Import words from text'),
        actions: [
          IconButton(
            tooltip: 'Page tutorial',
            onPressed: () => showContextTour(context, [
              TourStop(
                _promptTarget,
                'Create CSV text',
                'Enter the word or topic and copy the prompt into ChatGPT, or prepare your own CSV.',
              ),
              TourStop(
                _csvTarget,
                'Paste or choose a file',
                'Paste the CSV here or choose a .csv or .txt file. Each row needs a word and five translated sentences.',
              ),
              TourStop(
                _checkTarget,
                'Review before saving',
                'Check every row and read its examples. Existing word matches are shown before import.',
              ),
            ]),
            icon: const Icon(Icons.help_outline),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                'Create or paste a word list',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              const Text(
                'Import up to 20 words at once. Each word needs Hanzi, Pinyin, an English meaning, and five Chinese sentences with Pinyin and English. Review generated text before saving.',
              ),
              const SizedBox(height: 18),
              TextField(
                key: _promptTarget,
                controller: _requested,
                maxLength: 300,
                decoration: const InputDecoration(
                  labelText: 'Word or topic for ChatGPT (optional)',
                  hintText: 'For example: words for ordering food',
                ),
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    key: const ValueKey('copy-word-import-prompt'),
                    onPressed: () => _copy(
                      CustomWordCsv.chatGptPrompt(_requested.text),
                      'ChatGPT prompt copied.',
                    ),
                    icon: const Icon(Icons.copy_outlined),
                    label: const Text('Copy ChatGPT prompt'),
                  ),
                  TextButton.icon(
                    onPressed: () =>
                        _copy(CustomWordCsv.header, 'CSV header copied.'),
                    icon: const Icon(Icons.table_chart_outlined),
                    label: const Text('Copy CSV header'),
                  ),
                  TextButton.icon(
                    onPressed: _busy ? null : _chooseFile,
                    icon: const Icon(Icons.upload_file_outlined),
                    label: const Text('Choose CSV file'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              KeyedSubtree(
                key: _csvTarget,
                child: TextField(
                  key: const ValueKey('import-csv-text'),
                  controller: _csv,
                  enabled: !_busy,
                  minLines: 8,
                  maxLines: 14,
                  decoration: const InputDecoration(
                    labelText: 'CSV text',
                    hintText: 'Paste the header and word rows here',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              KeyedSubtree(
                key: _checkTarget,
                child: FilledButton.icon(
                  key: const ValueKey('import-check-csv'),
                  onPressed: _busy ? null : _check,
                  icon: const Icon(Icons.fact_check_outlined),
                  label: const Text('Check CSV and preview'),
                ),
              ),
              if (_busy) const LinearProgressIndicator(),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Semantics(
                  liveRegion: true,
                  child: Text(
                    _error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ],
              if (drafts != null && clashes != null) ...[
                const SizedBox(height: 20),
                Text(
                  '${drafts.length} ${drafts.length == 1 ? 'word' : 'words'} checked',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                for (var i = 0; i < drafts.length; i++)
                  Card(
                    child: ExpansionTile(
                      key: ValueKey('import-preview-$i'),
                      title: Text(
                        '${drafts[i].hanzi} · ${drafts[i].pinyin} · ${drafts[i].meaning}',
                      ),
                      subtitle: Text(
                        clashes[i] == null
                            ? 'New word · five examples'
                            : 'Matches ${clashes[i]!.word.hanzi}: ${clashes[i]!.fields.join(', ')}',
                      ),
                      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      children: [
                        for (var n = 0; n < 5; n++) ...[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: SelectableText(
                              '${n + 1}. ${drafts[i].examples[n].hanzi}\n${drafts[i].examples[n].pinyin}\n${drafts[i].examples[n].meaning}',
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                        if (drafts[i].explanation.isNotEmpty)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Note: ${drafts[i].explanation}'),
                          ),
                      ],
                    ),
                  ),
                if (hasClash)
                  Text(
                    matchingWord
                        ? 'This word already exists. Save your five examples for this profile, then open its lesson.'
                        : clashes.length == 1
                        ? 'A word clashes with this row, but its Hanzi and Pinyin do not both match. Edit the CSV row before importing; no examples have been saved.'
                        : 'Some words already exist. Remove those rows from the CSV, then check again.',
                  ),
                const SizedBox(height: 12),
                if (!hasClash)
                  FilledButton.icon(
                    key: const ValueKey('confirm-import-words'),
                    onPressed: _busy ? null : _import,
                    icon: const Icon(Icons.save_outlined),
                    label: Text(
                      'Import ${drafts.length} ${drafts.length == 1 ? 'word' : 'words'}',
                    ),
                  )
                else if (matchingWord)
                  FilledButton(
                    key: const ValueKey('save-examples-to-existing-word'),
                    onPressed: _busy ? null : _saveExamplesToMatch,
                    child: const Text('Save five examples to this word'),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
