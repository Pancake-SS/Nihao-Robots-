import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../vocabulary/pinyin_input.dart';
import '../vocabulary/word_library.dart';

class ChineseAnswerInput extends ConsumerStatefulWidget {
  const ChineseAnswerInput({
    required this.answerKey,
    required this.initialValue,
    required this.enabled,
    required this.onChanged,
    super.key,
  });
  final Key answerKey;
  final String initialValue;
  final bool enabled;
  final ValueChanged<String> onChanged;

  @override
  ConsumerState<ChineseAnswerInput> createState() => _ChineseAnswerInputState();
}

class _ChineseAnswerInputState extends ConsumerState<ChineseAnswerInput> {
  late final _answer = TextEditingController(text: widget.initialValue);
  final _pinyin = TextEditingController();
  final _pinyinFocus = FocusNode();
  var _page = 0;
  var _showKeys = false;
  static const _pageSize = 8;

  @override
  void dispose() {
    _answer.dispose();
    _pinyin.dispose();
    _pinyinFocus.dispose();
    super.dispose();
  }

  void _compose(String value) {
    if (!widget.enabled) return;
    setState(() => _page = 0);
  }

  void _key(String value) {
    if (!widget.enabled) return;
    final selection = _pinyin.selection;
    final start = selection.isValid ? selection.start : _pinyin.text.length;
    final end = selection.isValid ? selection.end : start;
    if (_pinyin.text.length - (end - start) + value.length > 60) return;
    _pinyin.value = TextEditingValue(
      text: _pinyin.text.replaceRange(start, end, value),
      selection: TextSelection.collapsed(offset: start + value.length),
    );
    _compose(_pinyin.text);
  }

  void _insert(String hanzi) {
    if (!widget.enabled) return;
    final selection = _answer.selection;
    final start = selection.isValid ? selection.start : _answer.text.length;
    final end = selection.isValid ? selection.end : start;
    final result = _answer.text.replaceRange(start, end, hanzi);
    if (result.characters.length > 100) return;
    _answer.value = TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: start + hanzi.length),
    );
    widget.onChanged(result);
    _pinyin.clear();
    setState(() => _page = 0);
    _pinyinFocus.requestFocus();
  }

  void _backspace() {
    if (!widget.enabled || _pinyin.text.isEmpty) return;
    final selection = _pinyin.selection;
    final end = selection.isValid ? selection.end : _pinyin.text.length;
    var start = selection.isValid ? selection.start : end;
    if (start == end && start > 0) {
      start -= _pinyin.text.substring(0, start).characters.last.length;
    }
    _pinyin.value = TextEditingValue(
      text: _pinyin.text.replaceRange(start, end, ''),
      selection: TextSelection.collapsed(offset: start),
    );
    _compose(_pinyin.text);
  }

  @override
  Widget build(BuildContext context) {
    final engine = ref.watch(pinyinInputEngineProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          key: widget.answerKey,
          controller: _answer,
          enabled: widget.enabled,
          maxLength: 100,
          decoration: const InputDecoration(
            labelText: 'Your answer in Simplified Chinese',
          ),
          onChanged: widget.onChanged,
        ),
        const SizedBox(height: 8),
        Text(
          'Chinese keyboard',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const Text('Enter Pinyin, then choose the characters. Use v for ü.'),
        const SizedBox(height: 8),
        TextField(
          key: const ValueKey('pinyin-composition'),
          controller: _pinyin,
          focusNode: _pinyinFocus,
          enabled: widget.enabled,
          maxLength: 60,
          autocorrect: false,
          enableSuggestions: false,
          decoration: const InputDecoration(
            labelText: 'Pinyin',
            hintText: 'For example: nihao',
            counterText: '',
          ),
          onChanged: _compose,
        ),
        engine.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(8),
            child: LinearProgressIndicator(),
          ),
          error: (_, _) => Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text(
                'Keyboard unavailable. You can still enter Chinese above.',
              ),
              TextButton(
                onPressed: widget.enabled
                    ? () {
                        ref.invalidate(pinyinInputEngineProvider);
                        ref.invalidate(wordLibraryProvider);
                      }
                    : null,
                child: const Text('Retry keyboard'),
              ),
            ],
          ),
          data: (value) {
            final candidates = value.candidates(
              _pinyin.text,
              offset: _page * _pageSize,
              limit: _pageSize + 1,
            );
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_pinyin.text.trim().isNotEmpty && candidates.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'No matching words. Try another spelling or enter one word at a time.',
                    ),
                  ),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    for (final candidate in candidates.take(_pageSize))
                      Tooltip(
                        message: candidate.pinyin,
                        child: OutlinedButton(
                          key: ValueKey('candidate-${candidate.hanzi}'),
                          onPressed: widget.enabled
                              ? () => _insert(candidate.hanzi)
                              : null,
                          child: Text(candidate.hanzi),
                        ),
                      ),
                  ],
                ),
                if (_page > 0 || candidates.length > _pageSize)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        tooltip: 'Previous candidates',
                        onPressed: !widget.enabled || _page == 0
                            ? null
                            : () => setState(() => _page--),
                        icon: const Icon(Icons.chevron_left),
                      ),
                      Flexible(
                        child: Text(
                          'Page ${_page + 1}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        tooltip: 'More candidates',
                        onPressed:
                            !widget.enabled || candidates.length <= _pageSize
                            ? null
                            : () => setState(() => _page++),
                        icon: const Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
              ],
            );
          },
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: widget.enabled
                ? () => setState(() => _showKeys = !_showKeys)
                : null,
            icon: const Icon(Icons.keyboard),
            label: Text(_showKeys ? 'Hide keys' : 'Show keys'),
          ),
        ),
        if (_showKeys) ...[
          for (final row in ['qwertyuiop', 'asdfghjkl', 'zxcvbnm'])
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Wrap(
                spacing: 4,
                runSpacing: 4,
                children: [
                  for (final letter in row.split(''))
                    SizedBox(
                      width: 48,
                      height: 48,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: widget.enabled ? () => _key(letter) : null,
                        child: Text(letter),
                      ),
                    ),
                ],
              ),
            ),
          Wrap(
            spacing: 8,
            children: [
              OutlinedButton(
                onPressed: widget.enabled ? () => _key("'") : null,
                child: const Text("'"),
              ),
              IconButton(
                tooltip: 'Delete Pinyin character',
                onPressed: widget.enabled ? _backspace : null,
                icon: const Icon(Icons.backspace_outlined),
              ),
              TextButton(
                onPressed: widget.enabled
                    ? () {
                        _pinyin.clear();
                        _compose('');
                      }
                    : null,
                child: const Text('Clear Pinyin'),
              ),
            ],
          ),
        ],
        const SizedBox(height: 12),
      ],
    );
  }
}
