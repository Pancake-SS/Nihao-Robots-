import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'content_pack.dart';

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
  SentenceAudioSession(this.player) {
    _subscription = player.completed.listen((_) {
      if (_disposed) return;
      activeAsset = null;
      notifyListeners();
    });
  }
  final SentencePlayer player;
  late final StreamSubscription<void> _subscription;
  String? activeAsset, errorAsset;
  bool busy = false, _disposed = false;
  Completer<void>? _settled;

  Future<void> playOrStop(SentenceAudio clip) async {
    if (busy || _disposed) return;
    final stopping = activeAsset == clip.asset;
    busy = true;
    _settled = Completer<void>();
    errorAsset = null;
    notifyListeners();
    try {
      await player.stop();
      if (_disposed) return;
      activeAsset = null;
      if (!stopping) {
        activeAsset = clip.asset;
        await player.play(clip.asset);
      }
    } catch (_) {
      activeAsset = null;
      errorAsset = clip.asset;
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
    activeAsset = null;
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    unawaited(_subscription.cancel());
    unawaited(player.dispose().catchError((Object _) {}));
    super.dispose();
  }
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
