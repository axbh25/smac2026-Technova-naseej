import 'package:flutter_test/flutter_test.dart';
import 'package:naseej/core/ai/offline_skill_card_factory.dart';
import 'package:naseej/core/ai/skill_card_generation_controller.dart';
import 'package:naseej/core/ai/skill_card_generation_service.dart';
import 'package:naseej/features/profile/domain/family_profile.dart';
import 'package:naseej/features/skill/domain/skill_card.dart';
import 'package:naseej/features/skill/domain/skill_draft.dart';

import 'support/fake_skill_card_generation_service.dart';

void main() {
  const SkillDraft draft = SkillDraft(
    teacherNickname: 'Fatima',
    teacherRole: FamilyRole.grandparent,
    learnerNickname: 'Mariam',
    learnerRole: FamilyRole.teen,
    category: SkillCategory.heritage,
    explanation:
        'Explain how our family welcomes guests with patience and care.',
  );

  SkillCard aiCard() {
    return SkillCard(
      title: 'Welcoming Guests',
      steps: const <String>[
        'Prepare the items together.',
        'Demonstrate the greeting slowly.',
        'Let the learner repeat it.',
      ],
      safetyNote: 'Ask an adult for help with hot items.',
      teachBackQuestion: 'Why is this important to the family?',
      reciprocalSkillSuggestion: 'Teach one phone feature in return.',
      outputLanguageCode: 'en',
      origin: SkillCardOrigin.ai,
      sourceDraftFingerprint: SkillCard.fingerprintForDraft(draft),
      modelName: 'gemini-3.5-flash-lite',
    );
  }

  test('controller exposes a valid AI preview', () async {
    final FakeSkillCardGenerationService service =
        FakeSkillCardGenerationService(
          result: SkillCardGenerationResult.success(aiCard()),
        );

    final SkillCardGenerationController controller =
        SkillCardGenerationController(service, const OfflineSkillCardFactory());

    addTearDown(controller.dispose);

    await controller.generateWithAi(draft: draft, outputLanguageCode: 'en');

    expect(controller.status, SkillCardGenerationStatus.previewReady);

    expect(controller.preview?.origin, SkillCardOrigin.ai);

    expect(controller.usedOfflineFallback, isFalse);

    expect(controller.previewNeedsSaving, isTrue);
  });

  test('cloud failure creates a labeled Offline Guide', () async {
    final FakeSkillCardGenerationService service =
        FakeSkillCardGenerationService(
          result: const SkillCardGenerationResult.failed(
            SkillCardGenerationFailure.offlineOrTimeout,
          ),
        );

    final SkillCardGenerationController controller =
        SkillCardGenerationController(service, const OfflineSkillCardFactory());

    addTearDown(controller.dispose);

    await controller.generateWithAi(draft: draft, outputLanguageCode: 'en');

    expect(controller.preview?.origin, SkillCardOrigin.offlineGuide);

    expect(controller.usedOfflineFallback, isTrue);

    expect(controller.failure, SkillCardGenerationFailure.offlineOrTimeout);
  });

  test('manual Offline Guide does not call cloud service', () {
    final FakeSkillCardGenerationService service =
        FakeSkillCardGenerationService(
          result: SkillCardGenerationResult.success(aiCard()),
        );

    final SkillCardGenerationController controller =
        SkillCardGenerationController(service, const OfflineSkillCardFactory());

    addTearDown(controller.dispose);

    controller.useOfflineGuide(draft: draft, outputLanguageCode: 'ar');

    expect(service.generationCalls, 0);

    expect(controller.preview?.origin, SkillCardOrigin.offlineGuide);

    expect(controller.preview?.outputLanguageCode, 'ar');
  });
}
