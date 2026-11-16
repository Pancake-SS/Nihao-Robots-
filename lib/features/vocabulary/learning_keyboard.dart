import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pinyin_input.dart';
import 'word_library.dart';

enum LearningKeyboardMode { english, hanzi, pinyin, all }

/// An input editor whose Pinyin suggestions are driven by the field being
/// edited. There is no separate composition box to copy text from.
class LearningKeyboard extends ConsumerStatefulWidget {
  const LearningKeyboard({
    required this.hanzi,
    required this.enabled,
    this.pinyin,
    this.english,
    this.hanziKey,
    this.pinyinKey,
    this.englishKey,
    this.hanziLabel = 'Simplified Chinese',
    this.pinyinLabel = 'Pinyin',
    this.englishLabel = 'English',
    this.hanziMaxLength = 100,
    this.pinyinMaxLength = 1000,
    this.englishMaxLength = 1000,
    this.hanziMaxLines = 1,
    this.onHanziChanged,
    this.onHanziSubmitted,
    this.hanziHint = 'Type Pinyin or paste Hanzi',
    this.hanziSuffixIcon,
    this.initialMode = LearningKeyboardMode.hanzi,
    this.onModeChanged,
    super.key,
  }) : assert((pinyin == null) == (english == null));

  final TextEditingController hanzi;
  final TextEditingController? pinyin, english;
  final Key? hanziKey, pinyinKey, englishKey;
  final String hanziLabel, pinyinLabel, englishLabel;
  final int hanziMaxLength, pinyinMaxLength, englishMaxLength, hanziMaxLines;
  final bool enabled;
  final ValueChanged<String>? onHanziChanged;
  final ValueChanged<String>? onHanziSubmitted;
  final String hanziHint;
  final Widget? hanziSuffixIcon;
  final LearningKeyboardMode initialMode;
  final ValueChanged<LearningKeyboardMode>? onModeChanged;

  @override
  ConsumerState<LearningKeyboard> createState() => _LearningKeyboardState();
}

class _LearningKeyboardState extends ConsumerState<LearningKeyboard> {
  final _hanziFocus = FocusNode();
  final _pinyinFocus = FocusNode();
  final _englishFocus = FocusNode();
  late LearningKeyboardMode _mode;
  bool _showKeys = false;
  int _page = 0;
  static const _pageSize = 8;
  static final _romanTail = RegExp(r"[A-Za-zÀ-ɏüÜvV0-9:'’]+$");

  @override
  void initState() {
    super.initState();
    _mode = widget.initialMode;
  }

  @override
  void didUpdateWidget(covariant LearningKeyboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialMode != oldWidget.initialMode) {
      _mode = widget.initialMode;
      _page = 0;
    }
  }

  @override
  void dispose() {
    _hanziFocus.dispose();
    _pinyinFocus.dispose();
    _englishFocus.dispose();
    super.dispose();
  }

  TextEditingController get _active => switch (_mode) {
    LearningKeyboardMode.english => widget.english ?? widget.hanzi,
    LearningKeyboardMode.pinyin => widget.pinyin ?? widget.hanzi,
    _ => widget.hanzi,
  };

  FocusNode get _activeFocus => switch (_mode) {
    LearningKeyboardMode.english => _englishFocus,
    LearningKeyboardMode.pinyin => _pinyinFocus,
    _ => _hanziFocus,
  };

  String get _query {
    if (_mode == LearningKeyboardMode.english) return '';
    final value = _active.value;
    final cursor = value.selection.isValid
        ? value.selection.extentOffset
        : value.text.length;
    if (cursor < 0 || cursor > value.text.length) return '';
    return _romanTail.firstMatch(value.text.substring(0, cursor))?.group(0) ??
        '';
  }

  void _modeChanged(LearningKeyboardMode mode, {bool focus = true}) {
    if (!widget.enabled ||
        (widget.pinyin == null && mode != LearningKeyboardMode.hanzi))
      return;
    setState(() {
      _mode = mode;
      _page = 0;
    });
    widget.onModeChanged?.call(mode);
    if (focus) _activeFocus.requestFocus();
  }

  void _append(TextEditingController controller, String value) {
    final old = controller.text.trimRight();
    controller.text = old.isEmpty ? value : '$old $value';
    controller.selection = TextSelection.collapsed(
      offset: controller.text.length,
    );
  }

  void _replaceQuery(String replacement) {
    final controller = _active;
    final value = controller.value;
    final cursor = value.selection.isValid
        ? value.selection.extentOffset
        : value.text.length;
    final query = _query;
    if (query.isEmpty) return;
    final start = cursor - query.length;
    final result = value.text.replaceRange(start, cursor, replacement);
    if (controller == widget.hanzi &&
        result.characters.length > widget.hanziMaxLength)
      return;
    controller.value = TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: start + replacement.length),
    );
    if (controller == widget.hanzi) widget.onHanziChanged?.call(result);
  }

  void _select(PinyinCandidate candidate) {
    if (!widget.enabled) return;
    final mode = _mode;
    _replaceQuery(
      mode == LearningKeyboardMode.pinyin ? candidate.pinyin : candidate.hanzi,
    );
    if (mode == LearningKeyboardMode.all) {
      _append(widget.pinyin!, candidate.pinyin);
      // Dictionary glosses are an editable draft, not a sentence translation.
      _append(
        widget.english!,
        candidate.meaning.split(RegExp(r'[;/]')).first.trim(),
      );
    }
    setState(() => _page = 0);
    _activeFocus.requestFocus();
  }

  void _changed(String value) {
    if (!widget.enabled) return;
    // Space accepts the best dictionary match just like a conventional IME.
    if ((_mode == LearningKeyboardMode.hanzi ||
            _mode == LearningKeyboardMode.all) &&
        value.endsWith(' ')) {
      final withoutSpace = value.substring(0, value.length - 1);
      final query = _romanTail.firstMatch(withoutSpace)?.group(0) ?? '';
      final engine = ref.read(pinyinInputEngineProvider).asData?.value;
      final best = query.isEmpty
          ? null
          : engine?.candidates(query, limit: 1).firstOrNull;
      if (best != null) {
        final start = withoutSpace.length - query.length;
        final result = value.replaceRange(start, value.length, best.hanzi);
        if (result.characters.length <= widget.hanziMaxLength) {
          widget.hanzi.value = TextEditingValue(
            text: result,
            selection: TextSelection.collapsed(
              offset: start + best.hanzi.length,
            ),
          );
          if (_mode == LearningKeyboardMode.all) {
            _append(widget.pinyin!, best.pinyin);
            _append(
              widget.english!,
              best.meaning.split(RegExp(r'[;/]')).first.trim(),
            );
          }
          widget.onHanziChanged?.call(result);
          setState(() => _page = 0);
          return;
        }
      }
    }
    if (_active == widget.hanzi) widget.onHanziChanged?.call(widget.hanzi.text);
    setState(() => _page = 0);
  }

  void _typeKey(String character) {
    if (!widget.enabled) return;
    final controller = _active;
    final value = controller.value;
    final start = value.selection.isValid
        ? value.selection.start
        : value.text.length;
    final end = value.selection.isValid ? value.selection.end : start;
    final result = value.text.replaceRange(start, end, character);
    final limit = controller == widget.hanzi
        ? widget.hanziMaxLength
        : controller == widget.pinyin
        ? widget.pinyinMaxLength
        : widget.englishMaxLength;
    if (result.characters.length > limit) return;
    controller.value = TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: start + character.length),
    );
    _changed(result);
    _activeFocus.requestFocus();
  }

  void _backspace() {
    if (!widget.enabled) return;
    final controller = _active;
    final value = controller.value;
    final end = value.selection.isValid
        ? value.selection.end
        : value.text.length;
    var start = value.selection.isValid ? value.selection.start : end;
    if (start == end && start > 0) {
      start -= value.text.substring(0, start).characters.last.length;
    }
    if (start == end) return;
    final result = value.text.replaceRange(start, end, '');
    controller.value = TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: start),
    );
    _changed(result);
    _activeFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final query = _query;
    final engine = ref.watch(pinyinInputEngineProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.pinyin != null) ...[
          Wrap(
            key: const ValueKey('keyboard-modes'),
            spacing: 6,
            runSpacing: 4,
            children: [
              for (final mode in LearningKeyboardMode.values)
                ChoiceChip(
                  key: ValueKey('mode-${mode.name}'),
                  label: Text(switch (mode) {
                    LearningKeyboardMode.english => 'English',
                    LearningKeyboardMode.hanzi => 'Hanzi',
                    LearningKeyboardMode.pinyin => 'Pinyin',
                    LearningKeyboardMode.all => 'All',
                  }),
                  selected: _mode == mode,
                  onSelected: widget.enabled ? (_) => _modeChanged(mode) : null,
                ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          key: widget.hanziKey,
          controller: widget.hanzi,
          focusNode: _hanziFocus,
          enabled: widget.enabled,
          maxLength: widget.hanziMaxLength,
          maxLines: widget.hanziMaxLines,
          decoration: InputDecoration(
            labelText: widget.hanziLabel,
            hintText: widget.hanziHint,
            suffixIcon: widget.hanziSuffixIcon,
          ),
          onTap: () {
            if (_mode != LearningKeyboardMode.all)
              _modeChanged(LearningKeyboardMode.hanzi, focus: false);
          },
          onChanged: _changed,
          onFieldSubmitted: widget.onHanziSubmitted,
        ),
        if (widget.pinyin case final pinyin?) ...[
          TextField(
            key: widget.pinyinKey,
            controller: pinyin,
            focusNode: _pinyinFocus,
            enabled: widget.enabled,
            maxLength: widget.pinyinMaxLength,
            decoration: InputDecoration(labelText: widget.pinyinLabel),
            onTap: () =>
                _modeChanged(LearningKeyboardMode.pinyin, focus: false),
            onChanged: _changed,
          ),
          TextField(
            key: widget.englishKey,
            controller: widget.english,
            focusNode: _englishFocus,
            enabled: widget.enabled,
            maxLength: widget.englishMaxLength,
            decoration: InputDecoration(labelText: widget.englishLabel),
            onTap: () =>
                _modeChanged(LearningKeyboardMode.english, focus: false),
            onChanged: _changed,
          ),
        ],
        if (_mode == LearningKeyboardMode.all &&
            widget.pinyin != null &&
            (widget.hanzi.text.isNotEmpty ||
                widget.pinyin!.text.isNotEmpty ||
                widget.english!.text.isNotEmpty))
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              '${widget.hanzi.text} · ${widget.pinyin!.text} · ${widget.english!.text}',
              key: const ValueKey('combined-preview'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        if (query.isNotEmpty && _mode != LearningKeyboardMode.english)
          engine.when(
            loading: () => const LinearProgressIndicator(),
            error: (_, _) => Wrap(
              children: [
                const Text(
                  'Suggestions unavailable. Direct typing and paste still work.',
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
            data: (input) {
              final candidates = input.candidates(
                query,
                offset: _page * _pageSize,
                limit: _pageSize + 1,
              );
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (candidates.isEmpty)
                    const Text(
                      'No match. Try a shorter Pinyin spelling or paste the characters.',
                    ),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      for (final candidate in candidates.take(_pageSize))
                        OutlinedButton(
                          key: ValueKey('candidate-${candidate.hanzi}'),
                          onPressed: widget.enabled
                              ? () => _select(candidate)
                              : null,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 350),
                            child: Text(
                              _mode == LearningKeyboardMode.all
                                  ? '${candidate.hanzi} · ${candidate.pinyin} · ${candidate.meaning}'
                                  : _mode == LearningKeyboardMode.pinyin
                                  ? candidate.pinyin
                                  : candidate.hanzi,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
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
                        Text('Page ${_page + 1}'),
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
                        onPressed: widget.enabled
                            ? () => _typeKey(letter)
                            : null,
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
                onPressed: widget.enabled ? () => _typeKey(' ') : null,
                child: const Text('Space'),
              ),
              IconButton(
                tooltip: 'Delete character',
                onPressed: widget.enabled ? _backspace : null,
                icon: const Icon(Icons.backspace_outlined),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
