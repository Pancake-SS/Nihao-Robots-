import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ni_hao_robot/features/vocabulary/content_pack.dart';
import 'package:ni_hao_robot/features/vocabulary/mandarin_speech.dart';
import 'package:ni_hao_robot/features/vocabulary/sentence_audio.dart';

class _Recording implements SentencePlayer {
  final events = StreamController<void>.broadcast(sync: true);
  final played = <String>[];
  int stops = 0;
  @override
  Stream<void> get completed => events.stream;
  @override
  Future<void> play(String asset) async {
    played.add(asset);
  }

  @override
  Future<void> stop() async {
    stops++;
  }

  @override
  Future<void> dispose() async {
    await events.close();
  }
}

class _Speech implements MandarinSpeech {
  final events = StreamController<void>.broadcast(sync: true);
  final errors = StreamController<void>.broadcast(sync: true);
  final spoken = <String>[];
  bool missing = false, disposed = false;
  int stops = 0;
  Completer<void>? gate;
  @override
  Stream<void> get completed => events.stream;
  @override
  Stream<void> get failed => errors.stream;
  @override
  Future<void> speak(String text) async {
    if (missing) throw MissingMandarinVoice();
    spoken.add(text);
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
    await errors.close();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final clip = VocabularyPack.parse(
    File('assets/content/starter_imported_v1.json').readAsStringSync(),
  ).entries.first.examples.first.audio!;

  test('selects an offline Mandarin voice and refuses English/Cantonese/network voices', () {
    final voices = [
      {'name': 'English', 'locale': 'en-US'},
      {'name': 'Cantonese', 'locale': 'zh-HK'},
      {'name': 'Online', 'locale': 'zh-CN', 'network_required': true},
      {'name': 'Taiwan', 'locale': 'zh-TW'},
      {'name': 'Mainland', 'locale': 'zh_CN'},
    ];
    expect(selectMandarinVoice(voices)!['name'], 'Mainland');
    expect(selectMandarinVoice(voices.take(3).toList()), isNull);
    expect(selectMandarinVoice(voices.take(4).toList())!['name'], 'Taiwan');
  });

  test('native adapter retries voice discovery and sends Chinese text to the selected voice', () async {
    const channel = MethodChannel('flutter_tts');
    final calls = <MethodCall>[];
    var installed = false;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          calls.add(call);
          if (call.method == 'getVoices')
            return installed
                ? [
                    {'name': 'Huihui', 'locale': 'zh-CN'},
                  ]
                : [
                    {'name': 'David', 'locale': 'en-US'},
                  ];
          return 1;
        });
    addTearDown(
      () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null),
    );
    final speech = NativeMandarinSpeech();
    await expectLater(speech.speak('你好'), throwsA(isA<MissingMandarinVoice>()));
    expect(calls.where((c) => c.method == 'speak'), isEmpty);
    installed = true;
    await speech.speak('你好');
    expect(calls.firstWhere((c) => c.method == 'setVoice').arguments, {
      'name': 'Huihui',
      'locale': 'zh-CN',
    });
    expect(calls.lastWhere((c) => c.method == 'speak').arguments, '你好');
    await speech.dispose();
  });

  test(
    'recordings and speech share stop, completion, error and route cleanup',
    () async {
      final player = _Recording();
      final speech = _Speech();
      final session = SentenceAudioSession(player, speech: speech);
      await session.playOrStop(clip);
      expect(player.played, [clip.asset]);
      expect(speech.spoken, isEmpty);
      await session.speakOrStop('word:1', '你好');
      expect(player.stops, 2);
      expect(session.activeAsset, 'tts:word:1');
      player.events.add(
        null,
      ); // A late recording completion cannot stop speech UI.
      expect(session.activeAsset, 'tts:word:1');
      speech.events.add(null);
      expect(session.activeAsset, isNull);
      await session.speakOrStop('sentence:1', '你好。');
      speech.errors.add(null);
      expect(session.errorAsset, 'tts:sentence:1');
      expect(session.activeAsset, isNull);
      await session.playOrStop(clip);
      expect(session.activeAsset, clip.asset);
      speech.events.add(null);
      expect(session.activeAsset, clip.asset);
      await session.stop();
      expect(session.activeAsset, isNull);
      speech.gate = Completer<void>();
      final start = session.speakOrStop('word:2', '书');
      await Future<void>.delayed(Duration.zero);
      session.dispose();
      speech.gate!.complete();
      await start;
      await Future<void>.delayed(Duration.zero);
      expect(speech.disposed, isTrue);
    },
  );

  testWidgets('word button explains a missing Mandarin voice and can retry', (
    tester,
  ) async {
    final player = _Recording();
    final speech = _Speech()..missing = true;
    final session = SentenceAudioSession(player, speech: speech);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SpeechAudioControls(
            session: session,
            id: 'word:1',
            text: '你好',
            word: true,
          ),
        ),
      ),
    );
    await tester.tap(find.text('Play word'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Install an offline Mandarin'), findsOneWidget);
    expect(find.text('Stop audio'), findsNothing);
    speech.missing = false;
    await tester.tap(find.text('Play word'));
    await tester.pumpAndSettle();
    expect(speech.spoken, ['你好']);
    expect(find.text('Stop audio'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    session.dispose();
  });
}
