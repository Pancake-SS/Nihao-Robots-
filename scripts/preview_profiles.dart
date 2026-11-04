// Development-only Flutter widget render; writes PNGs to OS temp, not app assets.
// Run with: flutter test scripts/preview_profiles.dart
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ni_hao_robot/app/app.dart';
import 'package:drift/native.dart';
import 'package:ni_hao_robot/data/app_database.dart';
import 'package:ni_hao_robot/data/database_provider.dart';
import 'package:ni_hao_robot/features/profiles/sqlite_profile_repository.dart';
import 'package:ni_hao_robot/features/review/learning_providers.dart';
import 'package:ni_hao_robot/shared/robot_art.dart';

void main() {
  testWidgets('render profile entry for visual inspection', (tester) async {
    await tester.runAsync(() async {
      for (final font in {
        'Segoe UI': 'segoeui.ttf',
        'Microsoft YaHei': 'msyh.ttc',
      }.entries) {
        final file = File('C:/Windows/Fonts/${font.value}');
        if (await file.exists()) {
          final loader = FontLoader(font.key)
            ..addFont(
              file.readAsBytes().then((bytes) => ByteData.sublistView(bytes)),
            );
          await loader.load();
        }
      }
      final icons = FontLoader('MaterialIcons')
        ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
      await icons.load();
    });
    final key = GlobalKey();
    final database = AppDatabase(NativeDatabase.memory());
    var clock = DateTime.utc(2026, 11, 4, 12);
    await SqliteProfileRepository(database).load();
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      await database.close();
    });
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1440, 900);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          learningClockProvider.overrideWithValue(() => clock),
        ],
        child: RepaintBoundary(key: key, child: const NiHaoRobotApp()),
      ),
    );
    await tester.pumpAndSettle();
    await tester.runAsync(() async {
      for (final artwork in RobotArtwork.values) {
        await precacheImage(AssetImage(artwork.assetPath), key.currentContext!);
      }
    });
    await tester.pumpAndSettle();
    Future<void> capture(String name) async {
      await tester.runAsync(() async {
        final boundary =
            key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
        final image = await boundary.toImage();
        final data = await image.toByteData(format: ui.ImageByteFormat.png);
        final directory = Directory(
          '${Directory.systemTemp.path}/nihao-profile-previews',
        );
        await directory.create(recursive: true);
        await File('${directory.path}/$name.png')
            .writeAsBytes(data!.buffer.asUint8List());
        image.dispose();
      });
    }

    await capture('create-profile');
    await tester.enterText(find.byKey(const Key('profile-name')), 'Mei');
    await tester.ensureVisible(find.text('Create profile'));
    await tester.tap(find.text('Create profile'));
    await tester.pumpAndSettle();
    await tester.drag(
      find.byType(SingleChildScrollView).first,
      const Offset(0, 1500),
    );
    await tester.pumpAndSettle();
    await capture('choose-profile');
    await tester.ensureVisible(find.text('Continue'));
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await capture('profile-ready');
    await tester.tap(find.text('Replay Tutorial'));
    await tester.pumpAndSettle();
    await capture('home-tour');
    await tester.tap(find.text('Close tutorial'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('destination-1')));
    await tester.pumpAndSettle();
    await capture('vocabulary');
    await tester.tap(find.text('Browse words'));
    await tester.pumpAndSettle();
    await capture('catalogue-pilot');
    await tester.tap(find.text('Explore word'));
    await tester.pumpAndSettle();
    await capture('pilot-lesson');
    await tester.ensureVisible(find.text('Continue to Quiz'));
    await tester.pumpAndSettle();
    await capture('pilot-lesson-bottom');
    await tester.tap(find.text('Continue to Quiz'));
    await tester.pumpAndSettle();
    await capture('pilot-quiz');
    await tester.tap(find.byKey(const ValueKey('answer-hello')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next question'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('answer-hello')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save answers'));
    await tester.pumpAndSettle();
    await capture('pilot-result');
    await tester.ensureVisible(find.text('Done'));
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open reviews'));
    await tester.pumpAndSettle();
    await capture('pilot-review-upcoming');
    clock = clock.add(const Duration(minutes: 5));
    await tester.pump(const Duration(seconds: 1));
    await capture('pilot-review-due');
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('destination-0')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start introduction'));
    await tester.pumpAndSettle();
    for (var i = 0; i < 6; i++) {
      await tester.ensureVisible(find.text('Next'));
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
    }
    await capture('foundation-pinyin');
    expect(tester.takeException(), isNull);
  });
}
