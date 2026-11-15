import 'package:flutter/material.dart';

import '../vocabulary/learning_keyboard.dart';

/// Typed quiz answers use the same inline Hanzi conversion as word editing.
/// The input remains a normal editable field for paste and installed IMEs.
class ChineseAnswerInput extends StatefulWidget {
  const ChineseAnswerInput({
    required this.answerKey,
    required this.initialValue,
    required this.enabled,
    required this.onChanged,
    this.maxLength = 100,
    super.key,
  });

  final Key answerKey;
  final String initialValue;
  final bool enabled;
  final ValueChanged<String> onChanged;
  final int maxLength;

  @override
  State<ChineseAnswerInput> createState() => _ChineseAnswerInputState();
}

class _ChineseAnswerInputState extends State<ChineseAnswerInput> {
  late final _answer = TextEditingController(text: widget.initialValue);

  @override
  void dispose() {
    _answer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LearningKeyboard(
    hanzi: _answer,
    hanziKey: widget.answerKey,
    hanziLabel: 'Your answer in Simplified Chinese',
    hanziMaxLength: widget.maxLength,
    enabled: widget.enabled,
    onHanziChanged: widget.onChanged,
  );
}
