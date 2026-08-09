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
}
