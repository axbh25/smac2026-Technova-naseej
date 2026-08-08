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
  String get nextStepPlaceholder =>
      'ستُضاف خطوة إعداد الملف الشخصي في الإصدار القادم.';
}
