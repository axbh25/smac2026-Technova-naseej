// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Naseej';

  @override
  String get appNameEnglish => 'Naseej';

  @override
  String get appNameArabic => 'نسيج';

  @override
  String get tagline => 'Every generation teaches. Every generation learns.';

  @override
  String get englishLanguage => 'English';

  @override
  String get arabicLanguage => 'العربية';

  @override
  String get privacyTitle => 'Private by design';

  @override
  String get privacyBody => 'No account or location is needed to begin.';

  @override
  String get continueLabel => 'Continue';

  @override
  String get changeLanguageLabel => 'Change language';

  @override
  String get profileSetupTitle => 'Create your local profile';

  @override
  String get profileSetupBody =>
      'Choose a nickname and role. This information stays on this phone.';

  @override
  String get nicknameLabel => 'Nickname';

  @override
  String get nicknameHint => 'For example, Fatima';

  @override
  String get chooseRoleLabel => 'Choose your role';

  @override
  String get roleGrandparent => 'Grandparent';

  @override
  String get roleParent => 'Parent';

  @override
  String get roleTeen => 'Teen';

  @override
  String get roleChild => 'Child';

  @override
  String get saveProfileLabel => 'Save profile';

  @override
  String get savingProfileLabel => 'Saving...';

  @override
  String get profileSaveError =>
      'We could not save this profile. Please try again.';

  @override
  String homeGreeting(String name) {
    return 'Hello, $name';
  }

  @override
  String get profileStoredLocally => 'Saved on this phone';

  @override
  String get emptyWeaveTitle => 'Your family weave starts here';

  @override
  String get emptyWeaveBody =>
      'Teach one skill and learn one skill to create your first thread.';

  @override
  String get teachSkillLabel => 'Teach a Skill';

  @override
  String get learnSkillLabel => 'Learn a Skill';

  @override
  String get featureComingSoon =>
      'This feature will be connected in the next build.';

  @override
  String get teachSkillScreenTitle => 'Teach a Skill';

  @override
  String get teacherSectionTitle => 'Teacher';

  @override
  String get teacherCardBody =>
      'This profile will be the teacher for this draft.';

  @override
  String get learnerSectionTitle => 'Who will learn?';

  @override
  String get learnerNicknameLabel => 'Learner nickname';

  @override
  String get learnerNicknameHint => 'For example, Mariam';

  @override
  String get learnerRoleLabel => 'Choose the learner\'s role';

  @override
  String get categorySectionTitle => 'Choose a skill category';

  @override
  String get skillCategoryHeritage => 'Heritage & Etiquette';

  @override
  String get skillCategoryEveryday => 'Everyday Skill';

  @override
  String get skillCategoryDigital => 'Digital Confidence';

  @override
  String get skillCategoryFamilyCare => 'Family Care';

  @override
  String get explanationSectionTitle => 'Explain the skill';

  @override
  String get explanationHint =>
      'Describe what you want to teach in your own words.';

  @override
  String get explanationHelper =>
      'Write at least 20 characters. Voice input will be added next.';

  @override
  String get saveDraftLabel => 'Save Draft';

  @override
  String get savingDraftLabel => 'Saving...';

  @override
  String get draftSaveError =>
      'We could not save this draft. Please try again.';

  @override
  String get savedDraftTitle => 'Saved skill draft';

  @override
  String draftLearnerSummary(String name, String role) {
    return 'Learner: $name — $role';
  }

  @override
  String draftCategorySummary(String category) {
    return 'Category: $category';
  }

  @override
  String get draftStoredLocally => 'Saved on this phone and ready to continue.';

  @override
  String get continueDraftLabel => 'Continue Draft';

  @override
  String get voiceInputSectionTitle => 'Voice input';

  @override
  String get voiceInputTitle => 'Speak your explanation';

  @override
  String get voiceInputBody =>
      'Speak a short explanation. Recognized words will appear in the editable field below.';

  @override
  String get speechListeningTitle => 'Listening…';

  @override
  String get speechListeningBody =>
      'Speak clearly. Recognized words are appearing below.';

  @override
  String get speechUnavailableTitle => 'Microphone unavailable';

  @override
  String get speechPermissionDenied =>
      'Microphone permission was denied. Continue by typing below. To enable it later, use Android Settings.';

  @override
  String get speechNetworkError =>
      'The speech service could not connect. Continue by typing or try again later.';

  @override
  String get speechNoMatch =>
      'No clear speech was recognized. Try again or continue typing.';

  @override
  String get speechGenericError =>
      'Voice input was interrupted. Try again or continue typing.';

  @override
  String get startSpeakingLabel => 'Start speaking';

  @override
  String get stopListeningLabel => 'Stop listening';

  @override
  String get typedFallbackLabel => 'Type below instead';

  @override
  String get voicePrivacyNotice =>
      'Naseej does not save audio. Your device’s speech service may process speech online. Review and edit the text before saving.';
}
