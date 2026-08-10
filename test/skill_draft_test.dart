import 'package:flutter_test/flutter_test.dart';
import 'package:naseej/features/profile/domain/family_profile.dart';
import 'package:naseej/features/skill/domain/skill_draft.dart';

void main() {
  test('SkillDraft survives a JSON round trip', () {
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
}
