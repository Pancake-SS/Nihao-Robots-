import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ni_hao_robot/app/app.dart';
import 'package:ni_hao_robot/data/app_database.dart';
import 'package:ni_hao_robot/data/database_provider.dart';
import 'package:ni_hao_robot/features/profiles/profile_providers.dart';
import 'package:ni_hao_robot/features/profiles/sqlite_profile_repository.dart';

void main() {
  testWidgets(
    'UI-created profile can be continued after database and widget restart',
    (tester) async {
      final directory = (await tester.runAsync(
        () => Directory.systemTemp.createTemp('nihao-ui-test-'),
      ))!;
      final file = File(
        '${directory.path}${Platform.pathSeparator}profiles.sqlite',
      );
      AppDatabase? database;
      try {
        Future<void> open() async {
          database = AppDatabase(NativeDatabase(file));
          final repository = SqliteProfileRepository(database!);
          await tester.runAsync(repository.load);
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                appDatabaseProvider.overrideWithValue(database!),
                profileRepositoryProvider.overrideWithValue(repository),
              ],
              child: const NiHaoRobotApp(),
            ),
          );
          await tester.pumpAndSettle();
        }

        await open();
        await tester.enterText(find.byKey(const Key('profile-name')), '小明');
        await tester.ensureVisible(find.text('Create profile'));
        await tester.tap(find.text('Create profile'));
        await tester.pumpAndSettle();
        expect(find.text('Choose your profile'), findsOneWidget);
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.runAsync(database!.close);
        database = null;
        await open();
        expect(find.text('小明'), findsOneWidget);
        await tester.ensureVisible(find.text('Continue'));
        await tester.tap(find.text('Continue'));
        await tester.pumpAndSettle();
        expect(find.text('Welcome, 小明!'), findsOneWidget);
        for (final label in [
          'Start introduction',
          'Next',
          'Next',
          'Save and leave',
        ]) {
          await tester.ensureVisible(find.text(label));
          await tester.tap(find.text(label));
          await tester.pumpAndSettle();
        }
        expect(find.text('Resume at step 3 of 9'), findsOneWidget);
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.runAsync(database!.close);
        database = null;
        await open();
        await tester.ensureVisible(find.text('Continue'));
        await tester.tap(find.text('Continue'));
        await tester.pumpAndSettle();
        expect(find.text('Resume at step 3 of 9'), findsOneWidget);
        await tester.ensureVisible(find.text('Resume introduction'));
        await tester.tap(find.text('Resume introduction'));
        await tester.pumpAndSettle();
        expect(find.text('Step 3 of 9'), findsOneWidget);
        expect(tester.takeException(), isNull);
      } finally {
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.runAsync(() async {
          await database?.close();
          final root =
              '${Directory.systemTemp.absolute.path}${Platform.pathSeparator}nihao-ui-test-';
          if (!directory.absolute.path.startsWith(root))
            throw StateError('Unexpected test cleanup path.');
          await directory.delete(recursive: true);
        });
      }
    },
  );
}
