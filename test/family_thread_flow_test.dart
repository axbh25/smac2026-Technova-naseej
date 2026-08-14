import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naseej/core/state/app_controller.dart';
import 'package:naseej/core/theme/app_theme.dart';
import 'package:naseej/core/tts/text_to_speech_controller.dart';
import 'package:naseej/features/learning/domain/learning_progress.dart';
import 'package:naseej/features/learning/presentation/learn_skill_screen.dart';
import 'package:naseej/features/profile/domain/family_profile.dart';
import 'package:naseej/features/skill/domain/skill_card.dart';
import 'package:naseej/features/skill/domain/skill_draft.dart';
import 'package:naseej/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'support/fake_app_storage.dart';
import 'support/fake_text_to_speech_engine.dart';

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
    reciprocalSkillSuggestion: 'Teach how to send a voice note.',
    outputLanguageCode: 'en',
    origin: SkillCardOrigin.ai,
    sourceDraftFingerprint: SkillCard.fingerprintForDraft(draft),
    modelName: 'gemini-3.5-flash-lite',
  );
}

class FamilyThreadHarness {
  const FamilyThreadHarness({required this.appController, required this.card});

  final AppController appController;
  final SkillCard card;
}

Future<FamilyThreadHarness> pumpFamilyThreadScreen(
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

  final AppController appController = AppController(storage);

  await appController.initialize();

  final TextToSpeechController textToSpeechController = TextToSpeechController(
    FakeTextToSpeechEngine(),
  );

  addTearDown(appController.dispose);
  addTearDown(textToSpeechController.dispose);

  await tester.pumpWidget(
    MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<AppController>.value(value: appController),
        ChangeNotifierProvider<TextToSpeechController>.value(
          value: textToSpeechController,
        ),
      ],
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

  return FamilyThreadHarness(appController: appController, card: card);
}

LearningProgress completedLesson(SkillCard card) {
  return LearningProgress(
    skillCardFingerprint: card.contentFingerprint,
    completedStepIndexes: const <int>[0, 1, 2],
    teachBackResponse: 'I learned how to welcome guests calmly.',
    completedAtIso8601: '2026-08-15T10:00:00.000Z',
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

void main() {
  testWidgets('completed lesson reveals the Family Thread card', (
    WidgetTester tester,
  ) async {
    final SkillCard card = createCard();

    await pumpFamilyThreadScreen(tester, progress: completedLesson(card));

    final Finder familyThreadCard = find.byKey(
      const ValueKey<String>('family_thread_card'),
    );

    await scrollToWidget(tester, familyThreadCard);

    expect(familyThreadCard, findsOneWidget);

    final Finder completeButton = find.byKey(
      const ValueKey<String>('complete_family_thread_button'),
    );

    expect(completeButton, findsOneWidget);

    final BuildContext buttonContext = tester.element(completeButton);

    final AppLocalizations localizations = AppLocalizations.of(buttonContext)!;

    expect(
      find.descendant(
        of: completeButton,
        matching: find.text(localizations.completeFamilyThreadLabel),
      ),
      findsOneWidget,
    );
  });

  testWidgets('suggestion can complete and persist the Family Thread', (
    WidgetTester tester,
  ) async {
    final SkillCard card = createCard();

    final FamilyThreadHarness harness = await pumpFamilyThreadScreen(
      tester,
      progress: completedLesson(card),
    );

    final Finder suggestionButton = find.byKey(
      const ValueKey<String>('use_return_suggestion_button'),
    );

    await scrollToWidget(tester, suggestionButton);

    await tester.tap(suggestionButton);
    await tester.pump();

    // Allow the 600 ms local autosave timer to run.
    await tester.pump(const Duration(milliseconds: 700));

    await tester.pumpAndSettle();

    expect(
      harness.appController.learningProgress?.returnSkillResponse,
      card.reciprocalSkillSuggestion,
    );

    final Finder completeButton = find.byKey(
      const ValueKey<String>('complete_family_thread_button'),
    );

    await scrollToWidget(tester, completeButton);

    final FilledButton button = tester.widget<FilledButton>(completeButton);

    expect(button.onPressed, isNotNull);

    await tester.tap(completeButton);
    await tester.pumpAndSettle();

    expect(harness.appController.learningProgress?.isExchangeCompleted, isTrue);

    final Finder completionBanner = find.byKey(
      const ValueKey<String>('family_thread_complete_banner'),
    );

    // The completed banner appears above the Family Thread,
    // so scroll back upward after completing the exchange.
    await scrollToWidget(tester, completionBanner, delta: -300);

    expect(completionBanner, findsOneWidget);
  });

  testWidgets('editing the return skill invalidates completed thread', (
    WidgetTester tester,
  ) async {
    final SkillCard card = createCard();

    final LearningProgress completed = LearningProgress(
      skillCardFingerprint: card.contentFingerprint,
      completedStepIndexes: const <int>[0, 1, 2],
      teachBackResponse: 'I learned how to welcome guests calmly.',
      completedAtIso8601: '2026-08-15T10:00:00.000Z',
      returnSkillResponse: 'Teach how to send a voice note.',
      exchangeCompletedAtIso8601: '2026-08-15T10:05:00.000Z',
    );

    final FamilyThreadHarness harness = await pumpFamilyThreadScreen(
      tester,
      progress: completed,
    );

    final Finder field = find.byKey(
      const ValueKey<String>('return_skill_response_field'),
    );

    await scrollToWidget(tester, field);

    await tester.enterText(field, 'Teach how to make a video call.');

    await tester.pump(const Duration(milliseconds: 700));

    await tester.pumpAndSettle();

    expect(
      harness.appController.learningProgress?.isExchangeCompleted,
      isFalse,
    );

    expect(
      harness.appController.learningProgress?.exchangeCompletedAtIso8601,
      isNull,
    );
  });

  testWidgets('Arabic Family Thread screen uses RTL', (
    WidgetTester tester,
  ) async {
    final SkillCard card = createCard();

    await pumpFamilyThreadScreen(
      tester,
      locale: const Locale('ar'),
      progress: completedLesson(card),
    );

    final BuildContext screenContext = tester.element(
      find.byKey(const ValueKey<String>('learn_skill_screen')),
    );

    expect(Directionality.of(screenContext), TextDirection.rtl);

    final Finder completeButton = find.byKey(
      const ValueKey<String>('complete_family_thread_button'),
    );

    await scrollToWidget(tester, completeButton);

    final BuildContext buttonContext = tester.element(completeButton);

    final AppLocalizations localizations = AppLocalizations.of(buttonContext)!;

    expect(
      find.descendant(
        of: completeButton,
        matching: find.text(localizations.completeFamilyThreadLabel),
      ),
      findsOneWidget,
    );
  });
}
