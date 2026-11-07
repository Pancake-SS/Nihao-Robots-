import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'content_pack.dart';
import 'mandarin_speech.dart';

abstract interface class SentencePlayer {
  Stream<void> get completed;
  Future<void> play(String asset);
  Future<void> stop();
  Future<void> dispose();
}

class NativeSentencePlayer implements SentencePlayer {
  AudioPlayer? _player;
  StreamSubscription<void>? _subscription;
  final _completed = StreamController<void>.broadcast();
  @override
  Stream<void> get completed => _completed.stream;
  @override
  Future<void> play(String asset) async {
    if (_player == null) {
      _player = AudioPlayer();
      _subscription = _player!.onPlayerComplete.listen(
        (_) => _completed.add(null),
      );
    }
    // Only validated bundle paths are used; no remote URL is played at runtime.
    await _player!.play(AssetSource(asset.substring('assets/'.length)));
  }

  @override
  Future<void> stop() async => _player?.stop();
  @override
  Future<void> dispose() async {
    await _subscription?.cancel();
    await _player?.dispose();
    await _completed.close();
  }
}

class SentenceAudioSession extends ChangeNotifier {
  SentenceAudioSession(this.player, {MandarinSpeech? speech})
    : speech = speech ?? NativeMandarinSpeech() {
    _subscription = player.completed.listen((_) {
      if (_disposed || activeAsset?.startsWith('tts:') == true) return;
      activeAsset = null;
      notifyListeners();
    });
    _speechCompleted = this.speech.completed.listen((_) {
      if (_disposed || activeAsset?.startsWith('tts:') != true) return;
      activeAsset = null;
      notifyListeners();
    });
    _speechFailed = this.speech.failed.listen((_) {
      if (_disposed || activeAsset?.startsWith('tts:') != true) return;
      errorAsset = activeAsset;
      errorMessage =
          'Could not generate speech. You can retry or continue reading.';
      activeAsset = null;
      notifyListeners();
    });
  }
  final SentencePlayer player;
  final MandarinSpeech speech;
  late final StreamSubscription<void> _subscription;
  late final StreamSubscription<void> _speechCompleted, _speechFailed;
  String? activeAsset, errorAsset, errorMessage;
  bool busy = false, _disposed = false;
  Completer<void>? _settled;

  Future<void> playOrStop(SentenceAudio clip) =>
      _play(clip.asset, () => player.play(clip.asset));

  Future<void> speakOrStop(String id, String text) =>
      _play('tts:$id', () => speech.speak(text));

  Future<void> _play(String key, Future<void> Function() start) async {
    if (busy || _disposed) return;
    final stopping = activeAsset == key;
    busy = true;
    _settled = Completer<void>();
    errorAsset = null;
    errorMessage = null;
    notifyListeners();
    try {
      await player.stop();
      await speech.stop();
      if (_disposed) return;
      activeAsset = null;
      if (!stopping) {
        activeAsset = key;
        await start();
      }
    } catch (error) {
      activeAsset = null;
      errorAsset = key;
      errorMessage = error is MissingMandarinVoice
          ? 'Install an offline Mandarin (Chinese) voice in your device’s speech settings, then retry. On Windows: Time & language > Speech > Add voices.'
          : 'Could not play audio. You can retry or continue reading.';
    } finally {
      busy = false;
      _settled!.complete();
      if (!_disposed) notifyListeners();
    }
  }

  Future<void> stop() async {
    await _settled?.future;
    if (_disposed) return;
    try {
      await player.stop();
    } catch (_) {
      /* Reading and quizzes remain usable. */
    }
    try {
      await speech.stop();
    } catch (_) {
      /* Reading remains available. */
    }
    activeAsset = null;
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    unawaited(_subscription.cancel());
    unawaited(_speechCompleted.cancel());
    unawaited(_speechFailed.cancel());
    unawaited(_disposePlayers());
    super.dispose();
  }

  Future<void> _disposePlayers() async {
    await _settled?.future;
    try {
      await player.dispose();
    } catch (_) {
      /* Best-effort route cleanup. */
    }
    try {
      await speech.dispose();
    } catch (_) {
      /* Best-effort route cleanup. */
    }
  }
}

class SpeechAudioControls extends StatelessWidget {
  const SpeechAudioControls({
    required this.session,
    required this.id,
    required this.text,
    this.word = false,
    super.key,
  });
  final SentenceAudioSession session;
  final String id, text;
  final bool word;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: session,
    builder: (context, _) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OutlinedButton.icon(
          key: ValueKey('speech-$id'),
          onPressed: session.busy ? null : () => session.speakOrStop(id, text),
          icon: Icon(
            session.activeAsset == 'tts:$id' ? Icons.stop : Icons.volume_up,
          ),
          label: Text(
            session.activeAsset == 'tts:$id'
                ? 'Stop audio'
                : word
                ? 'Play word'
                : 'Read sentence',
          ),
        ),
        const Text('Device Mandarin voice · generated speech'),
        if (session.errorAsset == 'tts:$id')
          Text(session.errorMessage ?? 'Speech unavailable. Please retry.'),
      ],
    ),
  );
}

final sentenceAudioSessionProvider = Provider.autoDispose<SentenceAudioSession>(
  (ref) {
    final session = SentenceAudioSession(NativeSentencePlayer());
    ref.onDispose(session.dispose);
    return session;
  },
);

class SentenceAudioControls extends StatelessWidget {
  const SentenceAudioControls({
    required this.session,
    required this.clip,
    super.key,
  });
  final SentenceAudioSession session;
  final SentenceAudio clip;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: session,
    builder: (context, _) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OutlinedButton.icon(
          onPressed: session.busy ? null : () => session.playOrStop(clip),
          icon: Icon(
            session.activeAsset == clip.asset ? Icons.stop : Icons.volume_up,
          ),
          label: Text(
            session.activeAsset == clip.asset ? 'Stop audio' : 'Play sentence',
          ),
        ),
        const Text('Synthetic voice · normal speed · offline'),
        if (session.errorAsset == clip.asset)
          const Text(
            'Could not play this recording. You can retry or continue reading.',
          ),
      ],
    ),
  );
}
