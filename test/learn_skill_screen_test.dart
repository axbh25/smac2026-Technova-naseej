import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naseej/core/state/app_controller.dart';
import 'package:naseej/core/theme/app_theme.dart';
import 'package:naseej/features/learning/domain/learning_progress.dart';
import 'package:naseej/features/learning/presentation/learn_skill_screen.dart';
import 'package:naseej/features/profile/domain/family_profile.dart';
import 'package:naseej/features/skill/domain/skill_card.dart';
import 'package:naseej/features/skill/domain/skill_draft.dart';
import 'package:naseej/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'support/fake_app_storage.dart';

const FamilyProfile profile = FamilyProfile(
  nickname: 'Fatima',
  role: FamilyRole.grandparent,
);

const SkillDraft draft = SkillDraft(
  teacherNickname: 'Fatima',
  teacherRole: FamilyRole.grandparent,
  learnerNickname: 'Mariam',
  learnerRole: FamilyRole.teen,
  category: SkillCategory.heritage,
  explanation: 'Explain how our family welcomes guests with patience and care.',
);

SkillCard createCard() {
  return SkillCard(
    title: 'Welcoming Guests',
    steps: const <String>[
      'Prepare the items together.',
      'Demonstrate the greeting slowly.',
      'Let the learner repeat the process.',
    ],
    safetyNote: 'Ask an adult for help with hot items.',
    teachBackQuestion: 'Why is welcoming a guest important?',
    reciprocalSkillSuggestion: 'Teach one phone feature in return.',
    outputLanguageCode: 'en',
    origin: SkillCardOrigin.ai,
    sourceDraftFingerprint: SkillCard.fingerprintForDraft(draft),
    modelName: 'gemini-3.5-flash-lite',
  );
}

Future<AppController> pumpLearningScreen(
  WidgetTester tester, {
  Locale locale = const Locale('en'),
  LearningProgress? progress,
}) async {
  await tester.binding.setSurfaceSize(const Size(412, 892));

  addTearDown(() async {
    await tester.binding.setSurfaceSize(null);
  });

  final SkillCard card = createCard();

  final FakeAppStorage storage = FakeAppStorage(
    localeCode: locale.languageCode,
    profileJson: profile.toJsonString(),
    skillDraftJson: draft.toJsonString(),
    skillCardJson: card.toJsonString(),
    learningProgressJson: progress?.toJsonString(),
  );

  final AppController controller = AppController(storage);

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
        home: LearnSkillScreen(card: card, draft: draft),
      ),
    ),
  );

  await tester.pumpAndSettle();

  return controller;
}

void main() {
  testWidgets('learner completes all steps and teach-back', (
    WidgetTester tester,
  ) async {
    final AppController controller = await pumpLearningScreen(tester);

    final Finder scrollable = find.byType(Scrollable).first;

    for (int index = 0; index < 3; index += 1) {
      final Finder checkbox = find.byKey(
        ValueKey<String>('learning_step_checkbox_$index'),
      );

      await tester.scrollUntilVisible(checkbox, 250, scrollable: scrollable);

      await tester.pumpAndSettle();

      expect(checkbox, findsOneWidget);

      await tester.tap(checkbox);
      await tester.pumpAndSettle();
    }

    final Finder responseField = find.byKey(
      const ValueKey<String>('teach_back_response_field'),
    );

    await tester.scrollUntilVisible(responseField, 250, scrollable: scrollable);

    await tester.pumpAndSettle();

    expect(responseField, findsOneWidget);

    await tester.enterText(
      responseField,
      'I learned to welcome guests calmly and explain each step.',
    );

    // Allow the 600 ms auto-save timer to run.
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();

    final Finder primaryButton = find.byKey(
      const ValueKey<String>('learning_primary_button'),
    );

    await tester.scrollUntilVisible(primaryButton, 250, scrollable: scrollable);

    await tester.pumpAndSettle();

    expect(primaryButton, findsOneWidget);

    final FilledButton buttonBeforeCompletion = tester.widget<FilledButton>(
      primaryButton,
    );

    expect(buttonBeforeCompletion.onPressed, isNotNull);

    await tester.tap(primaryButton);
    await tester.pumpAndSettle();

    expect(controller.learningProgress?.isCompleted, isTrue);

    final Finder completionBanner = find.byKey(
      const ValueKey<String>('learning_complete_banner'),
    );

    // Completing the lesson inserts the banner near the top of the ListView.
    // The test is currently near the bottom, so scroll upward until Flutter
    // builds and reveals the banner.
    await tester.scrollUntilVisible(
      completionBanner,
      -300,
      scrollable: scrollable,
    );

    await tester.pumpAndSettle();

    expect(completionBanner, findsOneWidget);
  });

  testWidgets('restores partially completed progress', (
    WidgetTester tester,
  ) async {
    final SkillCard card = createCard();

    final LearningProgress progress = LearningProgress(
      skillCardFingerprint: card.contentFingerprint,
      completedStepIndexes: const <int>[0, 1],
      teachBackResponse: 'I am still practising this lesson.',
    );

    await pumpLearningScreen(tester, progress: progress);

    final Finder scrollable = find.byType(Scrollable).first;

    final Finder firstCheckboxFinder = find.byKey(
      const ValueKey<String>('learning_step_checkbox_0'),
    );

    await tester.scrollUntilVisible(
      firstCheckboxFinder,
      250,
      scrollable: scrollable,
    );

    await tester.pumpAndSettle();

    expect(firstCheckboxFinder, findsOneWidget);

    final Checkbox firstCheckbox = tester.widget<Checkbox>(firstCheckboxFinder);

    expect(firstCheckbox.value, isTrue);

    final Finder secondCheckboxFinder = find.byKey(
      const ValueKey<String>('learning_step_checkbox_1'),
    );

    await tester.scrollUntilVisible(
      secondCheckboxFinder,
      250,
      scrollable: scrollable,
    );

    await tester.pumpAndSettle();

    expect(secondCheckboxFinder, findsOneWidget);

    final Checkbox secondCheckbox = tester.widget<Checkbox>(
      secondCheckboxFinder,
    );

    expect(secondCheckbox.value, isTrue);

    final Finder thirdCheckboxFinder = find.byKey(
      const ValueKey<String>('learning_step_checkbox_2'),
    );

    await tester.scrollUntilVisible(
      thirdCheckboxFinder,
      250,
      scrollable: scrollable,
    );

    await tester.pumpAndSettle();

    expect(thirdCheckboxFinder, findsOneWidget);

    final Checkbox thirdCheckbox = tester.widget<Checkbox>(thirdCheckboxFinder);

    expect(thirdCheckbox.value, isFalse);
  });

  testWidgets('Arabic learner screen uses RTL', (WidgetTester tester) async {
    await pumpLearningScreen(tester, locale: const Locale('ar'));

    final BuildContext screenContext = tester.element(
      find.byKey(const ValueKey<String>('learn_skill_screen')),
    );

    expect(Directionality.of(screenContext), TextDirection.rtl);

    expect(find.text('تعلّم مهارة'), findsOneWidget);
  });
}
