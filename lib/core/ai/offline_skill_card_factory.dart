import 'package:naseej/features/skill/domain/skill_card.dart';
import 'package:naseej/features/skill/domain/skill_draft.dart';

class OfflineSkillCardFactory {
  const OfflineSkillCardFactory();

  SkillCard create({
    required SkillDraft draft,
    required String outputLanguageCode,
  }) {
    final bool isArabic = outputLanguageCode.toLowerCase() == 'ar';

    return SkillCard(
      title: _title(draft.category, isArabic: isArabic),
      steps: isArabic
          ? const <String>[
              'اقرأ شرح المعلّم معًا وحددا أول عمل تريدان تنفيذه.',
              'اطلب من المعلّم عرض المهارة ببطء، وتابعوا عملًا واحدًا في كل مرة.',
              'دع المتعلّم يكرر المهارة ثم يشرحها بكلماته.',
            ]
          : const <String>[
              'Read the teacher’s explanation together and choose the first action to practise.',
              'Ask the teacher to demonstrate the skill slowly while the learner follows one action at a time.',
              'Let the learner repeat the skill and explain it back in their own words.',
            ],
      safetyNote: isArabic
          ? 'توقفوا إذا بدت أي خطوة غير آمنة، واطلبوا مساعدة شخص بالغ مسؤول عند الحاجة.'
          : 'Pause if any step feels unsafe, and ask a responsible adult for help when needed.',
      teachBackQuestion: isArabic
          ? 'ما الجزء الذي تستطيع شرحه الآن لفرد آخر من الأسرة؟'
          : 'Which part could you now explain to another family member?',
      reciprocalSkillSuggestion: isArabic
          ? 'اطلب من المتعلّم اختيار مهارة صغيرة يستطيع تعليمها للمعلّم في المقابل.'
          : 'Ask the learner to choose one small skill they can teach the teacher in return.',
      outputLanguageCode: isArabic ? 'ar' : 'en',
      origin: SkillCardOrigin.offlineGuide,
      sourceDraftFingerprint: SkillCard.fingerprintForDraft(draft),
    );
  }

  String _title(SkillCategory category, {required bool isArabic}) {
    if (isArabic) {
      return switch (category) {
        SkillCategory.heritage => 'شارك مهارة في التراث والآداب',
        SkillCategory.everyday => 'علّم مهارة يومية',
        SkillCategory.digital => 'شارك مهارة رقمية',
        SkillCategory.familyCare => 'شارك مهارة في الرعاية العائلية',
      };
    }

    return switch (category) {
      SkillCategory.heritage => 'Share a Heritage & Etiquette Skill',
      SkillCategory.everyday => 'Teach an Everyday Skill',
      SkillCategory.digital => 'Share a Digital Skill',
      SkillCategory.familyCare => 'Share a Family Care Skill',
    };
  }
}
