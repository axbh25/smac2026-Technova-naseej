import 'package:naseej/features/learning/domain/learning_progress.dart';
import 'package:naseej/features/profile/domain/family_profile.dart';
import 'package:naseej/features/skill/domain/skill_card.dart';
import 'package:naseej/features/skill/domain/skill_draft.dart';

class DemoJourney {
  const DemoJourney({
    required this.profile,
    required this.draft,
    this.card,
    this.progress,
  });

  final FamilyProfile profile;
  final SkillDraft draft;
  final SkillCard? card;
  final LearningProgress? progress;
}

abstract final class DemoJourneyFactory {
  static DemoJourney aiReady(String languageCode) {
    final bool isArabic = languageCode.toLowerCase() == 'ar';

    final FamilyProfile profile = FamilyProfile(
      nickname: isArabic ? 'فاطمة' : 'Fatima',
      role: FamilyRole.grandparent,
    );

    final SkillDraft draft = SkillDraft(
      teacherNickname: profile.nickname,
      teacherRole: profile.role,
      learnerNickname: isArabic ? 'مريم' : 'Mariam',
      learnerRole: FamilyRole.teen,
      category: SkillCategory.heritage,
      explanation: isArabic
          ? 'في عائلتنا نجهّز المجلس معًا، ونرحّب بالضيوف بهدوء، ونقدّم الضيافة بعناية، ثم نشرح كل خطوة قبل أن يجرّبها المتعلّم.'
          : 'In our family, we prepare the majlis together, welcome guests calmly, offer refreshments carefully, and explain each step before the learner practises.',
    );

    return DemoJourney(profile: profile, draft: draft);
  }

  static DemoJourney completedOffline(String languageCode) {
    final bool isArabic = languageCode.toLowerCase() == 'ar';

    final DemoJourney base = aiReady(languageCode);

    final SkillCard card = SkillCard(
      title: isArabic ? 'الترحيب بالضيوف معًا' : 'Welcoming Guests Together',
      steps: isArabic
          ? const <String>[
              'جهّزوا المجلس وأدوات الضيافة معًا.',
              'اعرض طريقة الترحيب وتقديم الضيافة ببطء.',
              'دع المتعلّم يكرر الخطوات ويشرحها بكلماته.',
            ]
          : const <String>[
              'Prepare the majlis and hospitality items together.',
              'Demonstrate the welcome and refreshments slowly.',
              'Let the learner repeat the steps and explain them back.',
            ],
      safetyNote: isArabic
          ? 'اطلب مساعدة شخص بالغ مسؤول عند التعامل مع المشروبات الساخنة.'
          : 'Ask a responsible adult for help when handling hot drinks.',
      teachBackQuestion: isArabic
          ? 'كيف تشرح طريقة الترحيب بالضيف لفرد آخر من العائلة؟'
          : 'How would you explain welcoming a guest to another family member?',
      reciprocalSkillSuggestion: isArabic
          ? 'علّم كيفية إرسال رسالة صوتية إلى مجموعة العائلة.'
          : 'Teach how to send a voice note to the family group.',
      outputLanguageCode: isArabic ? 'ar' : 'en',
      origin: SkillCardOrigin.offlineGuide,
      sourceDraftFingerprint: SkillCard.fingerprintForDraft(base.draft),
    );

    final LearningProgress progress = LearningProgress(
      skillCardFingerprint: card.contentFingerprint,
      completedStepIndexes: const <int>[0, 1, 2],
      teachBackResponse: isArabic
          ? 'تعلّمت أن الترحيب بالضيف يبدأ بالتجهيز الهادئ والاحترام وشرح كل خطوة.'
          : 'I learned that welcoming a guest begins with calm preparation, respect, and explaining each step.',
      completedAtIso8601: '2026-01-01T10:00:00.000Z',
      returnSkillResponse: isArabic
          ? 'كيفية إرسال رسالة صوتية إلى مجموعة العائلة.'
          : 'How to send a voice note to the family group.',
      exchangeCompletedAtIso8601: '2026-01-01T10:05:00.000Z',
    );

    return DemoJourney(
      profile: base.profile,
      draft: base.draft,
      card: card,
      progress: progress,
    );
  }
}
