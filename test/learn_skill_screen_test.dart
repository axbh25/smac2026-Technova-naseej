import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naseej/core/state/app_controller.dart';
import 'package:naseej/core/theme/app_theme.dart';
import 'package:naseej/core/tts/text_to_speech_controller.dart';
import 'package:naseej/core/tts/text_to_speech_engine.dart';
import 'package:naseej/features/learning/domain/learning_progress.dart';
import 'package:naseej/features/learning/presentation/learn_skill_screen.dart';
import 'package:naseej/features/profile/domain/family_profile.dart';
import 'package:naseej/features/skill/domain/skill_card.dart';
import 'package:naseej/features/skill/domain/skill_draft.dart';
import 'package:naseej/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

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

SkillCard createCard({String outputLanguageCode = 'en', List<String>? steps}) {
  return SkillCard(
    title: outputLanguageCode == 'ar' ? 'الترحيب بالضيوف' : 'Welcoming Guests',
    steps:
        steps ??
        const <String>[
          'Prepare the items together.',
          'Demonstrate the greeting slowly.',
          'Let the learner repeat the process.',
        ],
    safetyNote: outputLanguageCode == 'ar'
        ? 'اطلب مساعدة شخص بالغ عند استخدام الأشياء الساخنة.'
        : 'Ask an adult for help with hot items.',
    teachBackQuestion: outputLanguageCode == 'ar'
        ? 'لماذا يُعد الترحيب بالضيف مهمًا؟'
        : 'Why is welcoming a guest important?',
    reciprocalSkillSuggestion: outputLanguageCode == 'ar'
        ? 'علّم ميزة في الهاتف في المقابل.'
        : 'Teach one phone feature in return.',
    outputLanguageCode: outputLanguageCode,
    origin: SkillCardOrigin.ai,
    sourceDraftFingerprint: SkillCard.fingerprintForDraft(draft),
    modelName: 'gemini-3.5-flash-lite',
  );
}

class LearningTestHarness {
  const LearningTestHarness({
    required this.appController,
    required this.speechController,
    required this.speechEngine,
    required this.card,
  });

  final AppController appController;
  final TextToSpeechController speechController;
  final FakeTextToSpeechEngine speechEngine;
  final SkillCard card;
}

Future<LearningTestHarness> pumpLearningScreen(
  WidgetTester tester, {
  Locale locale = const Locale('en'),
  LearningProgress? progress,
  SkillCard? card,
  FakeTextToSpeechEngine? speechEngine,
}) async {
  await tester.binding.setSurfaceSize(const Size(412, 892));

  addTearDown(() async {
    await tester.binding.setSurfaceSize(null);
  });

  final SkillCard activeCard = card ?? createCard();

  final FakeAppStorage storage = FakeAppStorage(
    localeCode: locale.languageCode,
    profileJson: profile.toJsonString(),
    skillDraftJson: draft.toJsonString(),
    skillCardJson: activeCard.toJsonString(),
    learningProgressJson: progress?.toJsonString(),
  );

  final AppController appController = AppController(storage);

  await appController.initialize();

  final FakeTextToSpeechEngine activeSpeechEngine =
      speechEngine ?? FakeTextToSpeechEngine();

  final TextToSpeechController textToSpeechController = TextToSpeechController(
    activeSpeechEngine,
  );

  addTearDown(appController.dispose);
  addTearDown(textToSpeechController.dispose);

  await tester.pumpWidget(
    MultiProvider(
      providers: [
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
        home: LearnSkillScreen(card: activeCard, draft: draft),
      ),
    ),
  );

  await tester.pumpAndSettle();

  return LearningTestHarness(
    appController: appController,
    speechController: textToSpeechController,
    speechEngine: activeSpeechEngine,
    card: activeCard,
  );
}

void main() {
  testWidgets('learner completes all steps and teach-back', (
    WidgetTester tester,
  ) async {
    final LearningTestHarness harness = await pumpLearningScreen(tester);

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

    await tester.pump(const Duration(milliseconds: 700));

    await tester.pumpAndSettle();

    final Finder primaryButton = find.byKey(
      const ValueKey<String>('learning_primary_button'),
    );

    await tester.scrollUntilVisible(primaryButton, 250, scrollable: scrollable);

    await tester.pumpAndSettle();

    expect(primaryButton, findsOneWidget);

    await tester.tap(primaryButton);
    await tester.pumpAndSettle();

    expect(harness.appController.learningProgress?.isCompleted, isTrue);
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

    await pumpLearningScreen(tester, progress: progress, card: card);

    final Finder scrollable = find.byType(Scrollable).first;

    for (int index = 0; index < 3; index += 1) {
      final Finder checkboxFinder = find.byKey(
        ValueKey<String>('learning_step_checkbox_$index'),
      );

      await tester.scrollUntilVisible(
        checkboxFinder,
        250,
        scrollable: scrollable,
      );

      await tester.pumpAndSettle();

      expect(checkboxFinder, findsOneWidget);

      final Checkbox checkbox = tester.widget<Checkbox>(checkboxFinder);

      expect(checkbox.value, index < 2);
    }
  });

  testWidgets('Arabic learner screen uses RTL', (WidgetTester tester) async {
    await pumpLearningScreen(tester, locale: const Locale('ar'));

    final BuildContext screenContext = tester.element(
      find.byKey(const ValueKey<String>('learn_skill_screen')),
    );

    expect(Directionality.of(screenContext), TextDirection.rtl);

    expect(find.text('تعلّم مهارة'), findsOneWidget);
  });

  testWidgets('Listen changes to Stop and then Replay', (
    WidgetTester tester,
  ) async {
    final FakeTextToSpeechEngine engine = FakeTextToSpeechEngine(
      holdSpeech: true,
    );

    final LearningTestHarness harness = await pumpLearningScreen(
      tester,
      speechEngine: engine,
    );

    final Finder scrollable = find.byType(Scrollable).first;

    final Finder listenButton = find.byKey(
      const ValueKey<String>('learning_step_speak_0'),
    );

    await tester.scrollUntilVisible(listenButton, 250, scrollable: scrollable);

    await tester.pumpAndSettle();

    expect(listenButton, findsOneWidget);

    await tester.tap(listenButton);
    await tester.pump();

    expect(engine.preparedLanguageCodes, <String>['en']);

    expect(engine.spokenTexts, <String>['Prepare the items together.']);

    expect(harness.speechController.status, TextToSpeechStatus.speaking);

    expect(find.text('Stop'), findsOneWidget);

    engine.completeSpeech();

    await tester.pumpAndSettle();

    expect(find.text('Replay'), findsOneWidget);
  });

  testWidgets('missing TTS language does not block learning', (
    WidgetTester tester,
  ) async {
    final FakeTextToSpeechEngine engine = FakeTextToSpeechEngine(
      preparationResult:
          const TextToSpeechPreparationResult.languageUnavailable(),
    );

    final LearningTestHarness harness = await pumpLearningScreen(
      tester,
      speechEngine: engine,
    );

    final Finder scrollable = find.byType(Scrollable).first;

    final Finder listenButton = find.byKey(
      const ValueKey<String>('learning_step_speak_0'),
    );

    await tester.scrollUntilVisible(listenButton, 250, scrollable: scrollable);

    await tester.pumpAndSettle();

    expect(listenButton, findsOneWidget);

    await tester.tap(listenButton);
    await tester.pumpAndSettle();

    expect(harness.speechController.status, TextToSpeechStatus.unavailable);

    // The speech-support card is above the step cards.
    // Scroll back up before checking its unavailable message.
    final Finder speechSupportCard = find.byKey(
      const ValueKey<String>('speech_support_card'),
    );

    await tester.scrollUntilVisible(
      speechSupportCard,
      -250,
      scrollable: scrollable,
    );

    await tester.pumpAndSettle();

    expect(speechSupportCard, findsOneWidget);

    expect(
      find.text(
        'A voice for the card language is not installed on this device. '
        'Continue reading the lesson or install the voice in Android Settings.',
      ),
      findsOneWidget,
    );

    // TTS being unavailable must not stop normal lesson progress.
    final Finder checkbox = find.byKey(
      const ValueKey<String>('learning_step_checkbox_0'),
    );

    await tester.scrollUntilVisible(checkbox, 250, scrollable: scrollable);

    await tester.pumpAndSettle();

    expect(checkbox, findsOneWidget);

    await tester.tap(checkbox);
    await tester.pumpAndSettle();

    expect(harness.appController.learningProgress?.completedCount, 1);
  });

  testWidgets('speech uses the saved card language', (
    WidgetTester tester,
  ) async {
    final SkillCard arabicCard = createCard(
      outputLanguageCode: 'ar',
      steps: const <String>[
        'جهّز الأدوات معًا.',
        'اعرض طريقة الترحيب ببطء.',
        'دع المتعلّم يكرر العملية.',
      ],
    );

    final FakeTextToSpeechEngine engine = FakeTextToSpeechEngine(
      preparationResult: const TextToSpeechPreparationResult.ready('ar-AE'),
    );

    await pumpLearningScreen(
      tester,
      locale: const Locale('en'),
      card: arabicCard,
      speechEngine: engine,
    );

    final Finder listenButton = find.byKey(
      const ValueKey<String>('learning_step_speak_0'),
    );

    await tester.scrollUntilVisible(
      listenButton,
      250,
      scrollable: find.byType(Scrollable).first,
    );

    await tester.pumpAndSettle();

    expect(listenButton, findsOneWidget);

    await tester.tap(listenButton);
    await tester.pumpAndSettle();

    expect(engine.preparedLanguageCodes, <String>['ar']);

    expect(engine.spokenTexts, <String>['جهّز الأدوات معًا.']);
  });
}
