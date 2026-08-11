import 'package:flutter_test/flutter_test.dart';
import 'package:naseej/features/profile/domain/family_profile.dart';
import 'package:naseej/features/skill/domain/skill_draft.dart';

void main() {
  test('SkillDraft survives a JSON round trip with a photo', () {
    const SkillDraft originalDraft = SkillDraft(
      teacherNickname: 'Fatima',
      teacherRole: FamilyRole.grandparent,
      learnerNickname: 'Mariam',
      learnerRole: FamilyRole.teen,
      category: SkillCategory.heritage,
      explanation:
          'Explain how our family welcomes guests with patience and care.',
      contextPhotoPath: '/private/context_photos/context.jpg',
    );

    final SkillDraft? restoredDraft = SkillDraft.fromJsonString(
      originalDraft.toJsonString(),
    );

    expect(restoredDraft, originalDraft);
  });

  test('SkillDraft survives a JSON round trip without a photo', () {
    const SkillDraft originalDraft = SkillDraft(
      teacherNickname: 'Fatima',
      teacherRole: FamilyRole.grandparent,
      learnerNickname: 'Mariam',
      learnerRole: FamilyRole.teen,
      category: SkillCategory.heritage,
      explanation:
          'Explain how our family welcomes guests with patience and care.',
    );

    final SkillDraft? restoredDraft = SkillDraft.fromJsonString(
      originalDraft.toJsonString(),
    );

    expect(restoredDraft, originalDraft);
    expect(restoredDraft?.contextPhotoPath, isNull);
  });

  test('SkillDraft accepts legacy JSON without a photo field', () {
    final SkillDraft? draft = SkillDraft.fromJsonString('''
        {
          "teacherNickname": "Fatima",
          "teacherRole": "grandparent",
          "learnerNickname": "Mariam",
          "learnerRole": "teen",
          "category": "heritage",
          "explanation": "This legacy explanation contains more than twenty characters."
        }
        ''');

    expect(draft, isNotNull);
    expect(draft?.contextPhotoPath, isNull);
  });

  test('SkillDraft rejects damaged JSON', () {
    final SkillDraft? draft = SkillDraft.fromJsonString('not valid json');

    expect(draft, isNull);
  });

  test('SkillDraft rejects an unknown category', () {
    final SkillDraft? draft = SkillDraft.fromJsonString('''
      {
        "teacherNickname": "Fatima",
        "teacherRole": "grandparent",
        "learnerNickname": "Mariam",
        "learnerRole": "teen",
        "category": "unknown",
        "explanation": "This explanation contains more than twenty characters."
      }
      ''');

    expect(draft, isNull);
  });

  test('SkillDraft rejects a short explanation', () {
    final SkillDraft? draft = SkillDraft.fromJsonString('''
      {
        "teacherNickname": "Fatima",
        "teacherRole": "grandparent",
        "learnerNickname": "Mariam",
        "learnerRole": "teen",
        "category": "heritage",
        "explanation": "Too short"
      }
      ''');

    expect(draft, isNull);
  });

  test('SkillDraft rejects a non-string photo path', () {
    final SkillDraft? draft = SkillDraft.fromJsonString('''
        {
          "teacherNickname": "Fatima",
          "teacherRole": "grandparent",
          "learnerNickname": "Mariam",
          "learnerRole": "teen",
          "category": "heritage",
          "explanation": "This explanation contains more than twenty characters.",
          "contextPhotoPath": 123
        }
        ''');

    expect(draft, isNull);
  });
}
