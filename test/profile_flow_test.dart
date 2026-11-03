import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ni_hao_robot/app/app.dart';
import 'package:ni_hao_robot/features/profiles/profile_providers.dart';

import 'profile_test_repository.dart';
import 'foundation_test_repository.dart';

import 'package:ni_hao_robot/features/onboarding/foundation_repository.dart';

Future<void> mount(
  WidgetTester tester,
  TestProfileRepository repository,
) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        profileRepositoryProvider.overrideWithValue(repository),
        foundationRepositoryProvider.overrideWithValue(
          TestFoundationRepository(),
        ),
      ],
      child: const NiHaoRobotApp(),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'create, continue, switch, add another and choose first profile',
    (tester) async {
      final repository = TestProfileRepository();
      await mount(tester, repository);
      await tester.enterText(find.byKey(const Key('profile-name')), 'Mei');
      await tapVisible(tester, find.text('Create profile'));
      expect(find.text('Choose your profile'), findsOneWidget);
      await tapVisible(tester, find.text('Continue'));
      expect(find.text('Welcome, Mei!'), findsOneWidget);
      await tapVisible(tester, find.text('Switch profile'));
      await tapVisible(tester, find.text('Create another profile'));
      await tester.enterText(find.byKey(const Key('profile-name')), '小明');
      await tapVisible(tester, find.text('15 min'));
      await tapVisible(tester, find.text('Create profile'));
      expect(repository.snapshot.selected!.dailyMinutes, 15);
      await tapVisible(tester, find.byKey(const ValueKey('profile-1')));
      await tapVisible(tester, find.text('Continue'));
      expect(find.text('Welcome, Mei!'), findsOneWidget);
      expect(repository.snapshot.selected!.dailyMinutes, 5);
    },
  );

  testWidgets('invalid input is explained without creating a profile', (
    tester,
  ) async {
    final repository = TestProfileRepository();
    await mount(tester, repository);
    await tapVisible(tester, find.text('Create profile'));
    expect(find.text('Enter a name for your profile.'), findsOneWidget);
    expect(repository.creates, 0);
  });

  testWidgets('failed save retains draft and retry saves exactly once', (
    tester,
  ) async {
    final repository = TestProfileRepository()..failSave = true;
    await mount(tester, repository);
    await tester.enterText(find.byKey(const Key('profile-name')), 'Mei');
    await tapVisible(tester, find.text('Create profile'));
    expect(find.textContaining('Could not save'), findsOneWidget);
    expect(
      tester
          .widget<TextFormField>(find.byKey(const Key('profile-name')))
          .controller!
          .text,
      'Mei',
    );
    expect(repository.snapshot.profiles, isEmpty);
    repository.failSave = false;
    await tapVisible(tester, find.text('Create profile'));
    expect(repository.snapshot.profiles, hasLength(1));
  });

  testWidgets('pending save disables repeated submission', (tester) async {
    final repository = TestProfileRepository()..saveGate = Completer<void>();
    await mount(tester, repository);
    await tester.enterText(find.byKey(const Key('profile-name')), 'Mei');
    await tester.ensureVisible(find.text('Create profile'));
    await tester.tap(find.text('Create profile'));
    await tester.pump();
    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'Saving profile…'),
          )
          .onPressed,
      isNull,
    );
    expect(repository.creates, 1);
    repository.saveGate!.complete();
    await tester.pumpAndSettle();
    expect(repository.snapshot.profiles, hasLength(1));
  });

  testWidgets('storage error shows retry without resetting data', (
    tester,
  ) async {
    final repository = TestProfileRepository()..failLoad = true;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [profileRepositoryProvider.overrideWithValue(repository)],
        child: const NiHaoRobotApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('has not been reset'), findsOneWidget);
    repository.failLoad = false;
    await tapVisible(tester, find.text('Try again'));
    expect(find.text('Create local profile'), findsOneWidget);
  });
}
