// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'نسيج';

  @override
  String get appNameEnglish => 'Naseej';

  @override
  String get appNameArabic => 'نسيج';

  @override
  String get tagline => 'كل جيل يعلّم، وكل جيل يتعلّم.';

  @override
  String get englishLanguage => 'English';

  @override
  String get arabicLanguage => 'العربية';

  @override
  String get privacyTitle => 'الخصوصية أولًا';

  @override
  String get privacyBody => 'لا تحتاج إلى حساب أو مشاركة موقعك للبدء.';

  @override
  String get continueLabel => 'متابعة';

  @override
  String get changeLanguageLabel => 'تغيير اللغة';

  @override
  String get profileSetupTitle => 'أنشئ ملفك المحلي';

  @override
  String get profileSetupBody =>
      'اختر اسمًا مختصرًا ودورك في الأسرة. تبقى هذه البيانات على هذا الهاتف.';

  @override
  String get nicknameLabel => 'الاسم أو اللقب';

  @override
  String get nicknameHint => 'مثل: فاطمة';

  @override
  String get chooseRoleLabel => 'اختر دورك';

  @override
  String get roleGrandparent => 'جد أو جدة';

  @override
  String get roleParent => 'أب أو أم';

  @override
  String get roleTeen => 'مراهق أو مراهقة';

  @override
  String get roleChild => 'طفل أو طفلة';

  @override
  String get saveProfileLabel => 'حفظ الملف';

  @override
  String get savingProfileLabel => 'جارٍ الحفظ...';

  @override
  String get profileSaveError => 'تعذر حفظ هذا الملف. حاول مرة أخرى.';

  @override
  String homeGreeting(String name) {
    return 'مرحبًا، $name';
  }

  @override
  String get profileStoredLocally => 'محفوظ على هذا الهاتف';

  @override
  String get emptyWeaveTitle => 'يبدأ نسيج عائلتك من هنا';

  @override
  String get emptyWeaveBody => 'علِّم مهارة وتعلَّم مهارة لتضيفوا أول خيط.';

  @override
  String get teachSkillLabel => 'علِّم مهارة';

  @override
  String get learnSkillLabel => 'تعلَّم مهارة';

  @override
  String get featureComingSoon => 'ستُربط هذه الميزة في الإصدار القادم.';

  @override
  String get teachSkillScreenTitle => 'علِّم مهارة';

  @override
  String get teacherSectionTitle => 'المعلّم';

  @override
  String get teacherCardBody => 'سيكون هذا الملف هو المعلّم في هذه المسودة.';

  @override
  String get learnerSectionTitle => 'من سيتعلّم؟';

  @override
  String get learnerNicknameLabel => 'اسم المتعلّم أو لقبه';

  @override
  String get learnerNicknameHint => 'مثل: مريم';

  @override
  String get learnerRoleLabel => 'اختر دور المتعلّم في الأسرة';

  @override
  String get categorySectionTitle => 'اختر فئة المهارة';

  @override
  String get skillCategoryHeritage => 'التراث والآداب';

  @override
  String get skillCategoryEveryday => 'مهارة يومية';

  @override
  String get skillCategoryDigital => 'الثقة الرقمية';

  @override
  String get skillCategoryFamilyCare => 'الرعاية العائلية';

  @override
  String get explanationSectionTitle => 'اشرح المهارة';

  @override
  String get explanationHint => 'اكتب ما تريد تعليمه بكلماتك.';

  @override
  String get explanationHelper =>
      'اكتب 20 حرفًا على الأقل. ستُضاف ميزة الإدخال الصوتي لاحقًا.';

  @override
  String get saveDraftLabel => 'حفظ المسودة';

  @override
  String get savingDraftLabel => 'جارٍ الحفظ...';

  @override
  String get draftSaveError => 'تعذر حفظ المسودة. حاول مرة أخرى.';

  @override
  String get savedDraftTitle => 'مسودة مهارة محفوظة';

  @override
  String draftLearnerSummary(String name, String role) {
    return 'المتعلّم: $name — $role';
  }

  @override
  String draftCategorySummary(String category) {
    return 'الفئة: $category';
  }

  @override
  String get draftStoredLocally => 'محفوظة على هذا الهاتف وجاهزة للمتابعة.';

  @override
  String get continueDraftLabel => 'متابعة المسودة';

  @override
  String get voiceInputSectionTitle => 'الإدخال الصوتي';

  @override
  String get voiceInputTitle => 'تحدّث بشرحك';

  @override
  String get voiceInputBody =>
      'تحدّث بشرح قصير، وستظهر الكلمات التي تم التعرف إليها في الحقل القابل للتعديل أدناه.';

  @override
  String get speechListeningTitle => 'جارٍ الاستماع…';

  @override
  String get speechListeningBody =>
      'تحدّث بوضوح. تظهر الكلمات التي تم التعرف إليها أدناه.';

  @override
  String get speechUnavailableTitle => 'الميكروفون غير متاح';

  @override
  String get speechPermissionDenied =>
      'تم رفض إذن الميكروفون. تابع بالكتابة أدناه. ويمكنك تفعيل الإذن لاحقًا من إعدادات Android.';

  @override
  String get speechNetworkError =>
      'تعذر اتصال خدمة التعرّف إلى الكلام. تابع بالكتابة أو حاول مرة أخرى لاحقًا.';

  @override
  String get speechNoMatch =>
      'لم يتم التعرف إلى كلام واضح. حاول مرة أخرى أو تابع بالكتابة.';

  @override
  String get speechGenericError =>
      'توقف الإدخال الصوتي. حاول مرة أخرى أو تابع بالكتابة.';

  @override
  String get startSpeakingLabel => 'ابدأ التحدث';

  @override
  String get stopListeningLabel => 'إيقاف الاستماع';

  @override
  String get typedFallbackLabel => 'تابع بالكتابة أدناه';

  @override
  String get voicePrivacyNotice =>
      'لا يحفظ نسيج التسجيل الصوتي. قد تعالج خدمة التعرّف في جهازك الكلام عبر الإنترنت. راجع النص وعدّله قبل الحفظ.';
}
