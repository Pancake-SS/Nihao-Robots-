import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../review/chinese_answer_input.dart';
import 'curriculum_repository.dart';
import 'custom_word.dart';

class AddedWordResult {
  const AddedWordResult(this.id, this.message, {this.alreadyStarted = false});
  final String id, message;
  final bool alreadyStarted;
}

class AddWordScreen extends ConsumerStatefulWidget {
  const AddWordScreen({required this.profileId, super.key});
  final int profileId;

  @override
  ConsumerState<AddWordScreen> createState() => _AddWordScreenState();
}

class _AddWordScreenState extends ConsumerState<AddWordScreen> {
  final _pinyin = TextEditingController();
  final _meaning = TextEditingController();
  String _hanzi = '', _error = '';
  bool _busy = false;

  @override
  void dispose() {
    _pinyin.dispose();
    _meaning.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    setState(() {
      _busy = true;
      _error = '';
    });
    try {
      CustomWordDraft.validateWord(_hanzi, _pinyin.text, _meaning.text);
      final repo = ref.read(curriculumRepositoryProvider);
      final clash = await repo.findCustomClash(
        widget.profileId,
        _hanzi,
        _pinyin.text,
        _meaning.text,
      );
      if (!mounted) return;
      if (clash != null) {
        await repo.bringToFront(widget.profileId, clash.word.id);
        if (!mounted) return;
        Navigator.pop(
          context,
          AddedWordResult(
            clash.word.id,
            '${clash.fields.join(', ')} matches ${clash.word.hanzi} (${clash.word.pinyin}, ${clash.word.meaning}). ${clash.alreadyStarted ? 'This word is already in your reviews.' : 'Moved to the front of your queue.'}',
            alreadyStarted: clash.alreadyStarted,
          ),
        );
        return;
      }
      final result = await Navigator.push<AddedWordResult>(
        context,
        MaterialPageRoute(
          builder: (_) => AddWordExamplesScreen(
            profileId: widget.profileId,
            hanzi: _hanzi.trim(),
            pinyin: _pinyin.text.trim(),
            meaning: _meaning.text.trim(),
          ),
        ),
      );
      if (mounted && result != null) Navigator.pop(context, result);
    } on FormatException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (_) {
      if (mounted)
        setState(() => _error = 'Could not check this word. Please retry.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Add a word')),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'What word would you like to learn?',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            ChineseAnswerInput(
              answerKey: const ValueKey('custom-word-hanzi'),
              initialValue: '',
              enabled: !_busy,
              onChanged: (value) => _hanzi = value,
            ),
            TextField(
              key: const ValueKey('custom-word-pinyin'),
              controller: _pinyin,
              enabled: !_busy,
              maxLength: 300,
              decoration: const InputDecoration(
                labelText: 'Word Pinyin',
                hintText: 'For example: nǐ hǎo',
              ),
            ),
            TextField(
              key: const ValueKey('custom-word-meaning'),
              controller: _meaning,
              enabled: !_busy,
              maxLength: 1000,
              decoration: const InputDecoration(labelText: 'English meaning'),
            ),
            if (_error.isNotEmpty)
              Text(
                _error,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _busy ? null : _continue,
              child: const Text('Check word and continue'),
            ),
          ],
        ),
      ),
    ),
  );
}

class AddWordExamplesScreen extends ConsumerStatefulWidget {
  const AddWordExamplesScreen({
    required this.profileId,
    required this.hanzi,
    required this.pinyin,
    required this.meaning,
    super.key,
  });
  final int profileId;
  final String hanzi, pinyin, meaning;

  @override
  ConsumerState<AddWordExamplesScreen> createState() =>
      _AddWordExamplesScreenState();
}

class _AddWordExamplesScreenState extends ConsumerState<AddWordExamplesScreen> {
  final _sentences = List<String>.filled(5, '');
  final _pinyin = List.generate(5, (_) => TextEditingController());
  final _translations = List.generate(5, (_) => TextEditingController());
  final _explanation = TextEditingController();
  String _error = '';
  bool _busy = false;

  @override
  void dispose() {
    for (final controller in [..._pinyin, ..._translations, _explanation]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    setState(() {
      _busy = true;
      _error = '';
    });
    try {
      final draft = CustomWordDraft(
        hanzi: widget.hanzi,
        pinyin: widget.pinyin,
        meaning: widget.meaning,
        examples: [
          for (var i = 0; i < 5; i++)
            CustomSentence(
              _sentences[i],
              _pinyin[i].text,
              _translations[i].text,
            ),
        ],
        explanation: _explanation.text,
      );
      draft.validate();
      final word = await ref
          .read(curriculumRepositoryProvider)
          .addCustomWord(widget.profileId, draft);
      if (mounted)
        Navigator.pop(
          context,
          AddedWordResult(
            word.id,
            '${word.hanzi} was added to the front of your queue.',
          ),
        );
    } on CustomWordConflict catch (e) {
      final clash = e.clash;
      await ref
          .read(curriculumRepositoryProvider)
          .bringToFront(widget.profileId, clash.word.id);
      if (mounted)
        Navigator.pop(
          context,
          AddedWordResult(
            clash.word.id,
            '${clash.fields.join(', ')} matches ${clash.word.hanzi}. ${clash.alreadyStarted ? 'This word is already in your reviews.' : 'Moved it to the front of your queue.'}',
            alreadyStarted: clash.alreadyStarted,
          ),
        );
    } on FormatException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (_) {
      if (mounted)
        setState(() => _error = 'Could not save this word. Please retry.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('Examples for ${widget.hanzi}')),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Add five different sentences using ${widget.hanzi}. Each needs Pinyin and an English translation.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            for (var i = 0; i < 5; i++) ...[
              Text(
                'Sentence ${i + 1}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              ChineseAnswerInput(
                key: ValueKey('custom-example-input-$i'),
                answerKey: ValueKey('custom-example-hanzi-$i'),
                initialValue: '',
                enabled: !_busy,
                maxLength: 500,
                onChanged: (value) => _sentences[i] = value,
              ),
              TextField(
                key: ValueKey('custom-example-pinyin-$i'),
                controller: _pinyin[i],
                enabled: !_busy,
                maxLength: 1000,
                decoration: const InputDecoration(labelText: 'Sentence Pinyin'),
              ),
              TextField(
                key: ValueKey('custom-example-english-$i'),
                controller: _translations[i],
                enabled: !_busy,
                maxLength: 1000,
                decoration: const InputDecoration(
                  labelText: 'English translation',
                ),
              ),
              const Divider(height: 32),
            ],
            TextField(
              key: const ValueKey('custom-explanation'),
              controller: _explanation,
              enabled: !_busy,
              maxLength: 2000,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'English explanation (optional)',
              ),
            ),
            if (_error.isNotEmpty)
              Text(
                _error,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _busy ? null : _save,
              child: const Text('Save word and examples'),
            ),
          ],
        ),
      ),
    ),
  );
}
