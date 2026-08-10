import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naseej/app.dart';
import 'package:naseej/core/state/app_controller.dart';
import 'package:naseej/features/profile/domain/family_profile.dart';
import 'package:naseej/features/skill/domain/skill_draft.dart';
import 'package:provider/provider.dart';

import 'support/fake_app_storage.dart';

Future<AppController> pumpReferenceApp(
  WidgetTester tester, {
  FakeAppStorage? storage,
}) async {
  await tester.binding.setSurfaceSize(const Size(412, 892));

  addTearDown(() async {
    await tester.binding.setSurfaceSize(null);
  });

  final AppController controller = AppController(storage ?? FakeAppStorage());

  await controller.initialize();

  addTearDown(controller.dispose);

  await tester.pumpWidget(
    ChangeNotifierProvider<AppController>.value(
      value: controller,
      child: const NaseejApp(),
    ),
  );

  await tester.pumpAndSettle();

  return controller;
}

FakeAppStorage storageWithProfile({
  String localeCode = 'en',
  String nickname = 'Fatima',
  FamilyRole role = FamilyRole.grandparent,
  SkillDraft? draft,
}) {
  final FamilyProfile profile = FamilyProfile(nickname: nickname, role: role);

  return FakeAppStorage(
    localeCode: localeCode,
    profileJson: profile.toJsonString(),
    skillDraftJson: draft?.toJsonString(),
  );
}

Future<void> openTeachSkillScreen(
  WidgetTester tester, {
  required FakeAppStorage storage,
}) async {
  await pumpReferenceApp(tester, storage: storage);

  final Finder teachButton = find.byKey(
    const ValueKey<String>('teach_skill_button'),
  );

  expect(teachButton, findsOneWidget);

  await tester.ensureVisible(teachButton);
  await tester.pumpAndSettle();

  await tester.tap(teachButton);
  await tester.pumpAndSettle();

  expect(
    find.byKey(const ValueKey<String>('skill_draft_screen')),
    findsOneWidget,
  );
}

Future<void> completeSkillDraftForm(WidgetTester tester) async {
  final Finder learnerNicknameFinder = find.byKey(
    const ValueKey<String>('learner_nickname_field'),
  );

  await tester.ensureVisible(learnerNicknameFinder);
  await tester.pumpAndSettle();

  await tester.enterText(learnerNicknameFinder, 'Mariam');

  await tester.pump();

  final Finder learnerRoleFinder = find.byKey(
    const ValueKey<String>('learner_role_teen'),
  );

  await tester.ensureVisible(learnerRoleFinder);
  await tester.pumpAndSettle();

  await tester.tap(learnerRoleFinder);
  await tester.pump();

  final Finder categoryFinder = find.byKey(
    const ValueKey<String>('category_heritage'),
  );

  await tester.ensureVisible(categoryFinder);
  await tester.pumpAndSettle();

  await tester.tap(categoryFinder);
  await tester.pump();

  final Finder explanationFinder = find.byKey(
    const ValueKey<String>('explanation_field'),
  );

  await tester.ensureVisible(explanationFinder);
  await tester.pumpAndSettle();

  await tester.enterText(
    explanationFinder,
    'Explain how our family welcomes guests with patience and care.',
  );

  await tester.pump();
}

void main() {
  testWidgets('shows the English Welcome screen by default', (
    WidgetTester tester,
  ) async {
    await pumpReferenceApp(tester);

    expect(
      find.byKey(const ValueKey<String>('welcome_screen')),
      findsOneWidget,
    );

    expect(find.text('Naseej'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('switches to Arabic and stores the locale', (
    WidgetTester tester,
  ) async {
    final FakeAppStorage storage = FakeAppStorage();

    await pumpReferenceApp(tester, storage: storage);

    await tester.tap(find.byKey(const ValueKey<String>('language_ar_button')));

    await tester.pumpAndSettle();

    expect(find.text('كل جيل يعلّم، وكل جيل يتعلّم.'), findsOneWidget);

    expect(storage.localeCode, 'ar');

    final BuildContext welcomeContext = tester.element(
      find.byKey(const ValueKey<String>('welcome_screen')),
    );

    expect(Directionality.of(welcomeContext), TextDirection.rtl);
  });

  testWidgets('Continue opens Profile Setup', (WidgetTester tester) async {
    await pumpReferenceApp(tester);

    await tester.tap(find.byKey(const ValueKey<String>('continue_button')));

    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey<String>('profile_setup_screen')),
      findsOneWidget,
    );

    expect(find.text('Create your local profile'), findsOneWidget);
  });

  testWidgets('profile save requires both nickname and role', (
    WidgetTester tester,
  ) async {
    await pumpReferenceApp(tester);

    await tester.tap(find.byKey(const ValueKey<String>('continue_button')));

    await tester.pumpAndSettle();

    FilledButton saveButton = tester.widget<FilledButton>(
      find.byKey(const ValueKey<String>('save_profile_button')),
    );

    expect(saveButton.onPressed, isNull);

    await tester.enterText(
      find.byKey(const ValueKey<String>('nickname_field')),
      'Fatima',
    );

    await tester.pump();

    saveButton = tester.widget<FilledButton>(
      find.byKey(const ValueKey<String>('save_profile_button')),
    );

    expect(saveButton.onPressed, isNull);

    await tester.tap(find.byKey(const ValueKey<String>('role_grandparent')));

    await tester.pump();

    saveButton = tester.widget<FilledButton>(
      find.byKey(const ValueKey<String>('save_profile_button')),
    );

    expect(saveButton.onPressed, isNotNull);
  });

  testWidgets('saves a profile and opens Home', (WidgetTester tester) async {
    final FakeAppStorage storage = FakeAppStorage();

    await pumpReferenceApp(tester, storage: storage);

    await tester.tap(find.byKey(const ValueKey<String>('continue_button')));

    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey<String>('nickname_field')),
      'Fatima',
    );

    await tester.pump();

    await tester.tap(find.byKey(const ValueKey<String>('role_grandparent')));

    await tester.pump();

    await tester.tap(find.byKey(const ValueKey<String>('save_profile_button')));

    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey<String>('home_screen')), findsOneWidget);

    expect(find.text('Hello, Fatima'), findsOneWidget);

    expect(storage.profileJson, isNotNull);
  });

  testWidgets('restores a saved Arabic profile on startup', (
    WidgetTester tester,
  ) async {
    const FamilyProfile profile = FamilyProfile(
      nickname: 'فاطمة',
      role: FamilyRole.grandparent,
    );

    final FakeAppStorage storage = FakeAppStorage(
      localeCode: 'ar',
      profileJson: profile.toJsonString(),
    );

    await pumpReferenceApp(tester, storage: storage);

    expect(find.byKey(const ValueKey<String>('home_screen')), findsOneWidget);

    expect(find.text('مرحبًا، فاطمة'), findsOneWidget);
  });

  testWidgets('Teach a Skill opens from Home', (WidgetTester tester) async {
    await openTeachSkillScreen(tester, storage: storageWithProfile());

    expect(
      find.byKey(const ValueKey<String>('skill_draft_screen')),
      findsOneWidget,
    );

    expect(find.text('Teach a Skill'), findsOneWidget);
  });

  testWidgets('draft save requires all required fields', (
    WidgetTester tester,
  ) async {
    await openTeachSkillScreen(tester, storage: storageWithProfile());

    final Finder saveDraftFinder = find.byKey(
      const ValueKey<String>('save_draft_button'),
    );

    FilledButton saveButton = tester.widget<FilledButton>(saveDraftFinder);

    expect(saveButton.onPressed, isNull);

    final Finder learnerNicknameFinder = find.byKey(
      const ValueKey<String>('learner_nickname_field'),
    );

    await tester.ensureVisible(learnerNicknameFinder);
    await tester.pumpAndSettle();

    await tester.enterText(learnerNicknameFinder, 'Mariam');

    await tester.pump();

    final Finder learnerRoleFinder = find.byKey(
      const ValueKey<String>('learner_role_teen'),
    );

    await tester.ensureVisible(learnerRoleFinder);
    await tester.pumpAndSettle();

    await tester.tap(learnerRoleFinder);
    await tester.pump();

    final Finder categoryFinder = find.byKey(
      const ValueKey<String>('category_heritage'),
    );

    await tester.ensureVisible(categoryFinder);
    await tester.pumpAndSettle();

    await tester.tap(categoryFinder);
    await tester.pump();

    final Finder explanationFinder = find.byKey(
      const ValueKey<String>('explanation_field'),
    );

    await tester.ensureVisible(explanationFinder);
    await tester.pumpAndSettle();

    await tester.enterText(explanationFinder, 'Too short');

    await tester.pump();

    await tester.ensureVisible(saveDraftFinder);
    await tester.pumpAndSettle();

    saveButton = tester.widget<FilledButton>(saveDraftFinder);

    expect(saveButton.onPressed, isNull);

    await tester.enterText(
      explanationFinder,
      'This explanation now contains at least twenty characters.',
    );

    await tester.pump();

    await tester.ensureVisible(saveDraftFinder);
    await tester.pumpAndSettle();

    saveButton = tester.widget<FilledButton>(saveDraftFinder);

    expect(saveButton.onPressed, isNotNull);
  });

  testWidgets('saves a skill draft and displays it on Home', (
    WidgetTester tester,
  ) async {
    final FakeAppStorage storage = storageWithProfile();

    await openTeachSkillScreen(tester, storage: storage);

    await completeSkillDraftForm(tester);

    final Finder saveDraftFinder = find.byKey(
      const ValueKey<String>('save_draft_button'),
    );

    await tester.ensureVisible(saveDraftFinder);
    await tester.pumpAndSettle();

    await tester.tap(saveDraftFinder);
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey<String>('home_screen')), findsOneWidget);

    expect(find.text('Saved skill draft'), findsOneWidget);

    expect(find.textContaining('Mariam'), findsWidgets);

    expect(storage.skillDraftJson, isNotNull);
  });

  testWidgets('restores and reopens a saved skill draft', (
    WidgetTester tester,
  ) async {
    const SkillDraft draft = SkillDraft(
      teacherNickname: 'Fatima',
      teacherRole: FamilyRole.grandparent,
      learnerNickname: 'Mariam',
      learnerRole: FamilyRole.teen,
      category: SkillCategory.heritage,
      explanation:
          'Explain how our family welcomes guests with patience and care.',
    );

    await pumpReferenceApp(tester, storage: storageWithProfile(draft: draft));

    expect(find.byKey(const ValueKey<String>('home_screen')), findsOneWidget);

    expect(find.text('Saved skill draft'), findsOneWidget);

    final Finder teachButton = find.byKey(
      const ValueKey<String>('teach_skill_button'),
    );

    await tester.ensureVisible(teachButton);
    await tester.pumpAndSettle();

    await tester.tap(teachButton);
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey<String>('skill_draft_screen')),
      findsOneWidget,
    );

    final TextField learnerField = tester.widget<TextField>(
      find.byKey(const ValueKey<String>('learner_nickname_field')),
    );

    final TextField explanationField = tester.widget<TextField>(
      find.byKey(const ValueKey<String>('explanation_field')),
    );

    expect(learnerField.controller?.text, 'Mariam');

    expect(explanationField.controller?.text, draft.explanation);
  });

  testWidgets('Arabic Teach a Skill screen uses RTL', (
    WidgetTester tester,
  ) async {
    await openTeachSkillScreen(
      tester,
      storage: storageWithProfile(localeCode: 'ar', nickname: 'فاطمة'),
    );

    expect(find.text('علِّم مهارة'), findsOneWidget);

    final BuildContext screenContext = tester.element(
      find.byKey(const ValueKey<String>('skill_draft_screen')),
    );

    expect(Directionality.of(screenContext), TextDirection.rtl);
  });

  // Keep the semantics-heavy accessibility test last.
  testWidgets('Welcome screen meets basic accessibility guidelines', (
    WidgetTester tester,
  ) async {
    final SemanticsHandle semanticsHandle = tester.ensureSemantics();

    try {
      await pumpReferenceApp(tester);

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));

      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

      await expectLater(tester, meetsGuideline(textContrastGuideline));
    } finally {
      semanticsHandle.dispose();
    }
  });
}
