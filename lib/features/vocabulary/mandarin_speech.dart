import 'dart:async';

import 'package:flutter_tts/flutter_tts.dart';

abstract interface class MandarinSpeech {
  Stream<void> get completed;
  Stream<void> get failed;
  Future<void> speak(String text);
  Future<void> stop();
  Future<void> dispose();
}

class MissingMandarinVoice implements Exception {}

// Do not let an English or Cantonese default voice read Mandarin text.
Map<String, String>? selectMandarinVoice(List<dynamic> voices) {
  const locales = ['zh-cn', 'zh-sg', 'zh-tw', 'cmn-cn', 'cmn-tw', 'cmn', 'zh'];
  for (final locale in locales) {
    for (final voice in voices) {
      if (voice is! Map ||
          voice['name'] is! String ||
          voice['locale'] is! String)
        continue;
      if (voice['network_required'] == true ||
          voice['network_required'] == 'true')
        continue;
      if ((voice['locale'] as String).replaceAll('_', '-').toLowerCase() ==
          locale) {
        return {
          'name': voice['name'] as String,
          'locale': voice['locale'] as String,
        };
      }
    }
  }
  return null;
}

class NativeMandarinSpeech implements MandarinSpeech {
  FlutterTts? _tts;
  bool _disposed = false;
  final _completed = StreamController<void>.broadcast();
  final _failed = StreamController<void>.broadcast();
  @override
  Stream<void> get completed => _completed.stream;
  @override
  Stream<void> get failed => _failed.stream;

  @override
  Future<void> speak(String text) async {
    if (_disposed) return;
    if (text.trim().isEmpty || text.length > 1000)
      throw ArgumentError('Invalid speech text');
    final tts = _tts ??= FlutterTts();
    tts.setCompletionHandler(() {
      if (!_disposed) _completed.add(null);
    });
    tts.setErrorHandler((_) {
      if (!_disposed) _failed.add(null);
    });
    final voices = await tts.getVoices;
    if (_disposed) return;
    final voice = selectMandarinVoice(voices is List ? voices : []);
    if (voice == null) throw MissingMandarinVoice();
    final selected = await tts.setVoice(voice);
    if (selected != 1 && selected != true) throw MissingMandarinVoice();
    await tts.setSpeechRate(0.4);
    if (_disposed) return;
    final result = await tts.speak(text);
    if (result != 1 && result != true)
      throw StateError('Speech failed to start');
  }

  @override
  Future<void> stop() async {
    await _tts?.stop();
  }

  @override
  Future<void> dispose() async {
    _disposed = true;
    try {
      await stop();
    } finally {
      await _completed.close();
      await _failed.close();
    }
  }
}
