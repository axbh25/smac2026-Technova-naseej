import 'package:flutter_test/flutter_test.dart';
import 'package:naseej/features/profile/domain/family_profile.dart';
import 'package:naseej/features/skill/domain/skill_card.dart';
import 'package:naseej/features/skill/domain/skill_draft.dart';

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

  test('SkillCard survives a JSON round trip', () {
    final SkillCard originalCard = SkillCard(
      title: 'Welcoming Guests',
      steps: const <String>[
        'Prepare the items together.',
        'Demonstrate the greeting slowly.',
        'Let the learner repeat the process.',
      ],
      safetyNote: 'Ask an adult for help when handling hot items.',
      teachBackQuestion: 'Why is this practice important to the family?',
      reciprocalSkillSuggestion: 'Teach one phone feature in return.',
      outputLanguageCode: 'en',
      origin: SkillCardOrigin.ai,
      sourceDraftFingerprint: SkillCard.fingerprintForDraft(draft),
      modelName: 'gemini-3.5-flash-lite',
    );

    final SkillCard? restoredCard = SkillCard.fromJsonString(
      originalCard.toJsonString(),
    );

    expect(restoredCard, originalCard);
  });

  test('generated card requires exactly three steps', () {
    final SkillCard? card = SkillCard.fromGeneratedMap(
      map: <String, dynamic>{
        'title': 'Invalid card',
        'steps': <String>['Only one step', 'Only two steps'],
        'safety_note': 'Stay safe.',
        'teach_back_question': 'What did you learn?',
        'reciprocal_skill_suggestion': 'Teach something in return.',
      },
      outputLanguageCode: 'en',
      origin: SkillCardOrigin.ai,
      sourceDraftFingerprint: SkillCard.fingerprintForDraft(draft),
      modelName: 'gemini-3.5-flash-lite',
    );

    expect(card, isNull);
  });

  test('card fingerprint matches only its source draft', () {
    final String firstFingerprint = SkillCard.fingerprintForDraft(draft);

    const SkillDraft changedDraft = SkillDraft(
      teacherNickname: 'Fatima',
      teacherRole: FamilyRole.grandparent,
      learnerNickname: 'Mariam',
      learnerRole: FamilyRole.teen,
      category: SkillCategory.heritage,
      explanation: 'This explanation was changed after generation.',
    );

    final String secondFingerprint = SkillCard.fingerprintForDraft(
      changedDraft,
    );

    expect(firstFingerprint, isNot(secondFingerprint));
  });

  test('AI card requires a model name', () {
    final SkillCard? card = SkillCard.fromJsonString('''
        {
          "title": "A title",
          "steps": ["One", "Two", "Three"],
          "safetyNote": "Stay safe.",
          "teachBackQuestion": "What did you learn?",
          "reciprocalSkillSuggestion": "Teach in return.",
          "outputLanguageCode": "en",
          "origin": "ai",
          "sourceDraftFingerprint": "12345678",
          "modelName": null
        }
        ''');

    expect(card, isNull);
  });
}
