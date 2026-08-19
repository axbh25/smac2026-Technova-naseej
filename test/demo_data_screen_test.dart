import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naseej/core/state/app_controller.dart';
import 'package:naseej/core/storage/app_storage.dart';
import 'package:naseej/core/theme/app_theme.dart';
import 'package:naseej/features/demo/presentation/demo_data_screen.dart';
import 'package:naseej/features/profile/domain/family_profile.dart';
import 'package:naseej/features/skill/domain/skill_draft.dart';
import 'package:naseej/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'support/failing_app_storage.dart';
import 'support/fake_app_storage.dart';
import 'support/fake_context_photo_service.dart';

const String oldPhotoPath = 'C:\\private\\naseej\\old-context-photo.jpg';

const FamilyProfile oldProfile = FamilyProfile(
  nickname: 'Aisha',
  role: FamilyRole.parent,
);

const SkillDraft oldDraft = SkillDraft(
  teacherNickname: 'Aisha',
  teacherRole: FamilyRole.parent,
  learnerNickname: 'Mariam',
  learnerRole: FamilyRole.teen,
  category: SkillCategory.heritage,
  explanation: 'Explain how our family welcomes guests with patience and care.',
  contextPhotoPath: oldPhotoPath,
);

class DemoScreenHarness {
  const DemoScreenHarness({
    required this.controller,
    required this.storage,
    required this.photoService,
  });

  final AppController controller;
  final AppStorage storage;

  final FakeContextPhotoService photoService;
}

Future<DemoScreenHarness> pumpDemoScreen(
  WidgetTester tester, {
  Locale locale = const Locale('en'),
  AppStorage? storage,
  FakeContextPhotoService? photoService,
}) async {
  await tester.binding.setSurfaceSize(const Size(412, 892));

  addTearDown(() async {
    await tester.binding.setSurfaceSize(null);
  });

  final AppStorage activeStorage =
      storage ?? FakeAppStorage(localeCode: locale.languageCode);

  final FakeContextPhotoService activePhotoService =
      photoService ?? FakeContextPhotoService();

  final AppController controller = AppController(activeStorage);

  await controller.initialize();

  addTearDown(controller.dispose);

  await tester.pumpWidget(
    ChangeNotifierProvider<AppController>.value(
      value: controller,
      child: MaterialApp(
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.light,
        home: DemoDataScreen(contextPhotoService: activePhotoService),
      ),
    ),
  );

  await tester.pumpAndSettle();

  return DemoScreenHarness(
    controller: controller,
    storage: activeStorage,
    photoService: activePhotoService,
  );
}

Future<void> scrollToWidget(
  WidgetTester tester,
  Finder target, {
  double delta = 300,
}) async {
  final Finder scrollable = find.byType(Scrollable).first;

  await tester.scrollUntilVisible(target, delta, scrollable: scrollable);

  await tester.pumpAndSettle();

  expect(target, findsOneWidget);
}

Future<void> tapReplacementConfirm(WidgetTester tester) async {
  final Finder confirmButton = find.byKey(
    const ValueKey<String>('confirm_replace_demo_button'),
  );

  expect(confirmButton, findsOneWidget);

  await tester.tap(confirmButton);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('completed local sample loads a full Family Thread', (
    WidgetTester tester,
  ) async {
    final DemoScreenHarness harness = await pumpDemoScreen(tester);

    final Finder button = find.byKey(
      const ValueKey<String>('load_completed_demo_button'),
    );

    await scrollToWidget(tester, button);

    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(harness.controller.profile, isNotNull);

    expect(harness.controller.skillDraft, isNotNull);

    expect(harness.controller.skillCard, isNotNull);

    expect(harness.controller.learningProgress?.isExchangeCompleted, isTrue);
  });

  testWidgets('reset confirmation clears family data but keeps locale', (
    WidgetTester tester,
  ) async {
    final DemoScreenHarness harness = await pumpDemoScreen(tester);

    final Finder loadButton = find.byKey(
      const ValueKey<String>('load_completed_demo_button'),
    );

    await scrollToWidget(tester, loadButton);

    await tester.tap(loadButton);
    await tester.pumpAndSettle();

    final Finder resetButton = find.byKey(
      const ValueKey<String>('reset_local_data_button'),
    );

    await scrollToWidget(tester, resetButton);

    await tester.tap(resetButton);
    await tester.pumpAndSettle();

    final Finder confirmButton = find.byKey(
      const ValueKey<String>('confirm_reset_data_button'),
    );

    expect(confirmButton, findsOneWidget);

    await tester.tap(confirmButton);
    await tester.pumpAndSettle();

    expect(harness.controller.profile, isNull);

    expect(harness.controller.skillDraft, isNull);

    expect(harness.controller.skillCard, isNull);

    expect(harness.controller.learningProgress, isNull);

    expect(harness.controller.locale.languageCode, 'en');
  });

  testWidgets('Arabic Data Tools screen uses RTL', (WidgetTester tester) async {
    await pumpDemoScreen(tester, locale: const Locale('ar'));

    final BuildContext screenContext = tester.element(
      find.byKey(const ValueKey<String>('demo_data_screen')),
    );

    expect(Directionality.of(screenContext), TextDirection.rtl);

    expect(find.text('العرض والبيانات المحلية'), findsOneWidget);
  });

  testWidgets('successful sample replacement deletes the old photo afterward', (
    WidgetTester tester,
  ) async {
    final FakeAppStorage storage = FakeAppStorage(
      localeCode: 'en',
      profileJson: oldProfile.toJsonString(),
      skillDraftJson: oldDraft.toJsonString(),
    );

    final FakeContextPhotoService photoService = FakeContextPhotoService();

    final DemoScreenHarness harness = await pumpDemoScreen(
      tester,
      storage: storage,
      photoService: photoService,
    );

    final Finder loadButton = find.byKey(
      const ValueKey<String>('load_completed_demo_button'),
    );

    await scrollToWidget(tester, loadButton);

    await tester.tap(loadButton);
    await tester.pumpAndSettle();

    expect(harness.photoService.deletedPaths, isEmpty);

    await tapReplacementConfirm(tester);

    expect(harness.controller.skillDraft?.contextPhotoPath, isNull);

    expect(harness.photoService.deletedPaths, <String>[oldPhotoPath]);
  });

  testWidgets('failed replacement keeps the old photo and old family state', (
    WidgetTester tester,
  ) async {
    final FailingAppStorage storage = FailingAppStorage(
      localeCode: 'en',
      profileJson: oldProfile.toJsonString(),
      skillDraftJson: oldDraft.toJsonString(),
    );

    final FakeContextPhotoService photoService = FakeContextPhotoService();

    final DemoScreenHarness harness = await pumpDemoScreen(
      tester,
      storage: storage,
      photoService: photoService,
    );

    storage.failNextOperation = 'writeSkillCardJson';

    final Finder loadButton = find.byKey(
      const ValueKey<String>('load_completed_demo_button'),
    );

    await scrollToWidget(tester, loadButton);

    await tester.tap(loadButton);
    await tester.pumpAndSettle();

    await tapReplacementConfirm(tester);

    expect(harness.photoService.deletedPaths, isEmpty);

    expect(harness.controller.profile, oldProfile);

    expect(harness.controller.skillDraft, oldDraft);

    expect(harness.controller.skillCard, isNull);

    expect(harness.controller.learningProgress, isNull);

    expect(
      harness.controller.recoveryNotice,
      AppRecoveryNotice.storageUnavailable,
    );
  });

  testWidgets('unknown stored state still requires replacement confirmation', (
    WidgetTester tester,
  ) async {
    final FailingAppStorage storage = FailingAppStorage(
      localeCode: 'en',
      failNextOperation: 'readProfileJson',
    );

    final DemoScreenHarness harness = await pumpDemoScreen(
      tester,
      storage: storage,
    );

    expect(
      harness.controller.recoveryNotice,
      AppRecoveryNotice.storageUnavailable,
    );

    expect(harness.controller.hasAnyFamilyData, isFalse);

    final Finder loadButton = find.byKey(
      const ValueKey<String>('load_ai_ready_demo_button'),
    );

    await scrollToWidget(tester, loadButton);

    await tester.tap(loadButton);
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey<String>('confirm_replace_demo_button')),
      findsOneWidget,
    );
  });

  testWidgets('photo cleanup failure does not undo successful sample load', (
    WidgetTester tester,
  ) async {
    final FakeAppStorage storage = FakeAppStorage(
      localeCode: 'en',
      profileJson: oldProfile.toJsonString(),
      skillDraftJson: oldDraft.toJsonString(),
    );

    final FakeContextPhotoService photoService = FakeContextPhotoService(
      throwOnDelete: true,
    );

    final DemoScreenHarness harness = await pumpDemoScreen(
      tester,
      storage: storage,
      photoService: photoService,
    );

    final Finder loadButton = find.byKey(
      const ValueKey<String>('load_completed_demo_button'),
    );

    await scrollToWidget(tester, loadButton);

    await tester.tap(loadButton);
    await tester.pumpAndSettle();

    await tapReplacementConfirm(tester);

    expect(harness.controller.skillCard, isNotNull);

    expect(harness.controller.learningProgress?.isExchangeCompleted, isTrue);

    expect(find.textContaining('could not be deleted'), findsOneWidget);
  });
}
