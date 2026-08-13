import 'package:flutter_test/flutter_test.dart';
import 'package:naseej/core/state/app_controller.dart';
import 'package:naseej/features/learning/domain/learning_progress.dart';
import 'package:naseej/features/profile/domain/family_profile.dart';
import 'package:naseej/features/skill/domain/skill_card.dart';
import 'package:naseej/features/skill/domain/skill_draft.dart';

import 'support/fake_app_storage.dart';

void main() {
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
    explanation:
        'Explain how our family welcomes guests with patience and care.',
  );

  SkillCard createCard({String title = 'Welcoming Guests'}) {
    return SkillCard(
      title: title,
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

  test('restores progress that matches the saved card', () async {
    final SkillCard card = createCard();

    final LearningProgress progress = LearningProgress(
      skillCardFingerprint: card.contentFingerprint,
      completedStepIndexes: const <int>[0, 1],
      teachBackResponse: 'I learned how to welcome guests carefully.',
    );

    final FakeAppStorage storage = FakeAppStorage(
      localeCode: 'en',
      profileJson: profile.toJsonString(),
      skillDraftJson: draft.toJsonString(),
      skillCardJson: card.toJsonString(),
      learningProgressJson: progress.toJsonString(),
    );

    final AppController controller = AppController(storage);

    addTearDown(controller.dispose);

    await controller.initialize();

    expect(controller.learningProgress, progress);
  });

  test('replacing card content clears old progress', () async {
    final SkillCard firstCard = createCard();

    final LearningProgress progress = LearningProgress(
      skillCardFingerprint: firstCard.contentFingerprint,
      completedStepIndexes: const <int>[0],
      teachBackResponse: '',
    );

    final FakeAppStorage storage = FakeAppStorage(
      localeCode: 'en',
      profileJson: profile.toJsonString(),
      skillDraftJson: draft.toJsonString(),
      skillCardJson: firstCard.toJsonString(),
      learningProgressJson: progress.toJsonString(),
    );

    final AppController controller = AppController(storage);

    addTearDown(controller.dispose);

    await controller.initialize();

    final SkillCard changedCard = createCard(title: 'A Newly Generated Lesson');

    await controller.saveSkillCard(changedCard);

    expect(controller.learningProgress, isNull);

    expect(storage.learningProgressJson, isNull);
  });

  test('editing the draft clears card and progress', () async {
    final SkillCard card = createCard();

    final LearningProgress progress = LearningProgress(
      skillCardFingerprint: card.contentFingerprint,
      completedStepIndexes: const <int>[0, 1, 2],
      teachBackResponse: 'I learned how to welcome guests carefully.',
      completedAtIso8601: '2026-08-15T10:00:00.000Z',
    );

    final FakeAppStorage storage = FakeAppStorage(
      localeCode: 'en',
      profileJson: profile.toJsonString(),
      skillDraftJson: draft.toJsonString(),
      skillCardJson: card.toJsonString(),
      learningProgressJson: progress.toJsonString(),
    );

    final AppController controller = AppController(storage);

    addTearDown(controller.dispose);

    await controller.initialize();

    const SkillDraft changedDraft = SkillDraft(
      teacherNickname: 'Fatima',
      teacherRole: FamilyRole.grandparent,
      learnerNickname: 'Mariam',
      learnerRole: FamilyRole.teen,
      category: SkillCategory.heritage,
      explanation:
          'This explanation has been changed and must generate a new card.',
    );

    await controller.saveSkillDraft(changedDraft);

    expect(controller.skillCard, isNull);

    expect(controller.learningProgress, isNull);

    expect(storage.skillCardJson, isNull);

    expect(storage.learningProgressJson, isNull);
  });
}
