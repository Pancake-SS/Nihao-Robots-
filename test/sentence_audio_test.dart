import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ni_hao_robot/features/vocabulary/content_pack.dart';
import 'package:ni_hao_robot/features/vocabulary/sentence_audio.dart';

class _Player implements SentencePlayer {
  final events = StreamController<void>.broadcast(sync: true);
  final played = <String>[];
  Completer<void>? gate;
  bool fail = false, disposed = false;
  int stops = 0;
  @override
  Stream<void> get completed => events.stream;
  @override
  Future<void> play(String asset) async {
    played.add(asset);
    if (fail) throw StateError('Playback failed');
    await gate?.future;
  }

  @override
  Future<void> stop() async {
    stops++;
  }

  @override
  Future<void> dispose() async {
    disposed = true;
    await events.close();
  }
}

void main() {
  final pack = VocabularyPack.parse(
    File('assets/content/starter_imported_v1.json').readAsStringSync(),
  );
  final clip = pack.entries.first.examples.first.audio!;

  test('audio paths and provenance are bounded and originals are present', () {
    final files = <String>{};
    for (final word in pack.entries) {
      for (final example in word.examples) {
        final audio = example.audio!;
        expect(File(audio.asset).lengthSync(), audio.bytes);
        files.add(audio.asset);
      }
    }
    expect(files, hasLength(88));
    for (final field in ['asset', 'url', 'sha256', 'synthetic']) {
      final data = Map<String, dynamic>.from(
        jsonDecode(jsonEncode(clip.toJson())),
      );
      data[field] = field == 'synthetic' ? false : '../invalid';
      expect(() => SentenceAudio.parse(data), throwsFormatException);
    }
  });

  test('one active recording, duplicate startup blocked and stop waits for startup', () async {
    final player = _Player()..gate = Completer<void>();
    final session = SentenceAudioSession(player);
    final playing = session.playOrStop(clip);
    await Future<void>.delayed(Duration.zero);
    await session.playOrStop(clip);
    expect(player.played, hasLength(1));
    final stop = session.stop();
    player.gate!.complete();
    await playing;
    await stop;
    expect(session.activeAsset, isNull);
    player.gate = null;
    await session.playOrStop(clip);
    player.events.add(null);
    expect(session.activeAsset, isNull);
    session.dispose();
    await Future<void>.delayed(Duration.zero);
    expect(player.disposed, isTrue);
  });

  testWidgets(
    'failed playback explains retry and does not pretend sound played',
    (tester) async {
      final player = _Player()..fail = true;
      final session = SentenceAudioSession(player);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SentenceAudioControls(session: session, clip: clip),
          ),
        ),
      );
      await tester.tap(find.text('Play sentence'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Could not play'), findsOneWidget);
      expect(find.text('Stop audio'), findsNothing);
      player.fail = false;
      await tester.tap(find.text('Play sentence'));
      await tester.pumpAndSettle();
      expect(find.text('Stop audio'), findsOneWidget);
      await tester.tap(find.text('Stop audio'));
      await tester.pumpAndSettle();
      expect(session.activeAsset, isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      session.dispose();
    },
  );
}
