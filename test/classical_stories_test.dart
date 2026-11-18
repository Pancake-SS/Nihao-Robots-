import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ni_hao_robot/app/theme.dart';
import 'package:ni_hao_robot/features/learning/classical_stories.dart';
import 'package:ni_hao_robot/features/learning/classical_stories_screen.dart';
import 'package:ni_hao_robot/features/learning/learning_resources_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('three complete credited works load from the offline pack', () async {
    final source = await rootBundle.loadString(
      'assets/content/classics_v1.json',
    );
    final english = await rootBundle.loadString(
      'assets/content/classics_english_v1.json',
    );
    final collections = parseClassics(source, englishSource: english);
    expect(collections.map((work) => work.chapters.length), [98, 33, 8]);
    expect(collections.first.chapters.first.title, '愚人食盐喻');
    expect(collections[1].chapters.first.title, '逍遥游');
    expect(collections[2].chapters.first.title, '天瑞篇');
    expect(collections.expand((work) => work.chapters).length, 139);
    for (final chapter in collections.expand((work) => work.chapters)) {
      expect(chapter.revision, greaterThan(0));
      expect(Uri.parse(chapter.sourceUrl).scheme, 'https');
      expect(chapter.paragraphs, isNotEmpty);
      expect(chapter.paragraphs.join(), isNot(contains('{{')));
      expect(chapter.englishParagraphs, isNotEmpty);
      expect(chapter.englishCredit, isNotEmpty);
      expect(Uri.parse(chapter.englishSourceUrl).hasScheme, isTrue);
    }
  });

  testWidgets('narrow reader opens a parable and navigates to the next', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    Uri? opened;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          resourceOpenerProvider.overrideWithValue((uri) async {
            opened = uri;
            return true;
          }),
        ],
        child: MaterialApp(
          theme: buildTheme(),
          home: const ClassicalStoriesScreen(),
        ),
      ),
    );
    for (
      var attempt = 0;
      attempt < 20 &&
          find.byKey(const ValueKey('classic-baiyu')).evaluate().isEmpty;
      attempt++
    ) {
      await tester.pump(const Duration(milliseconds: 50));
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
    }
    expect(find.byKey(const ValueKey('classic-baiyu')), findsOneWidget);
    await tester.ensureVisible(find.byKey(const ValueKey('classic-baiyu')));
    await tester.tap(find.byKey(const ValueKey('classic-baiyu')));
    await tester.pumpAndSettle();
    expect(find.text('98 readings'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('chapter-baiyu_001')));
    await tester.pumpAndSettle();
    expect(find.text('愚人食盐喻'), findsWidgets);
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();
    expect(find.textContaining('The Fool Who Ate Salt'), findsOneWidget);
    await tester.tap(find.text('Chinese'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Larger text'));
    await tester.pump();
    await tester.tap(find.byTooltip('View source'));
    await tester.pump();
    expect(opened?.queryParameters['oldid'], isNotEmpty);
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('愚人集牛乳喻'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
