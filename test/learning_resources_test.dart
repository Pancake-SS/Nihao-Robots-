import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ni_hao_robot/app/theme.dart';
import 'package:ni_hao_robot/features/learning/learning_resources_screen.dart';
import 'package:ni_hao_robot/features/learning/resource_catalogue.dart';

void main() {
  test('curated resource links are unique, secure and filterable', () {
    expect(learningResources.length, 22);
    expect(
      learningResources.map((resource) => resource.id).toSet().length,
      learningResources.length,
    );
    for (final resource in learningResources) {
      expect(Uri.parse(resource.url).scheme, 'https');
      expect(resource.access, isNotEmpty);
      expect(resource.levels, isNotEmpty);
    }
    expect(
      learningResources
          .where(
            (resource) => resource.matches(
              type: ResourceType.read,
              level: ResourceLevel.beginner,
              search: 'graded',
            ),
          )
          .map((resource) => resource.id),
      contains('mandarin_bean'),
    );
    expect(
      learningResources.where(
        (resource) => resource.matches(
          type: ResourceType.music,
          level: ResourceLevel.beginner,
        ),
      ),
      isEmpty,
    );
    expect(
      learningResources
          .where(
            (resource) => resource.matches(
              type: ResourceType.read,
              level: ResourceLevel.advanced,
              search: 'Wikisource',
            ),
          )
          .map((resource) => resource.id)
          .toSet(),
      {'wikisource_baiyu', 'wikisource_zhuangzi', 'wikisource_liezi'},
    );
  });

  testWidgets('resource search opens the original link at 360px', (
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
          home: const LearningResourcesScreen(),
        ),
      ),
    );
    await tester.enterText(
      find.byKey(const ValueKey('resource-search')),
      'Mandarin Click',
    );
    await tester.pump();
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('resource-mandarin_click')),
      260,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('1 resources'), findsOneWidget);
    await tester.tap(find.text('Open site'));
    await tester.pump();
    expect(opened.toString(), 'https://www.youtube.com/@MandarinClick');
    expect(tester.takeException(), isNull);
  });
}
