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
  String get contextPhotoSectionTitle => 'Context photo';

  @override
  String get contextPhotoTitle => 'Show the object or setting';

  @override
  String get contextPhotoBody =>
      'Add one optional photo to help the learner understand the skill.';

  @override
  String get addContextPhotoLabel => 'Add context photo';

  @override
  String get replaceContextPhotoLabel => 'Replace photo';

  @override
  String get removeContextPhotoLabel => 'Remove photo';

  @override
  String get takePhotoLabel => 'Take a photo';

  @override
  String get chooseFromGalleryLabel => 'Choose from gallery';

  @override
  String get cancelLabel => 'Cancel';

  @override
  String get photoProcessingLabel => 'Preparing photo…';

  @override
  String get photoPrivacyNotice =>
      'This photo stays on this phone and is not sent to AI in this MVP.';

  @override
  String get photoPermissionDenied =>
      'Photo access was denied. Continue without a photo or change the permission in Android Settings.';

  @override
  String get photoSourceUnavailable =>
      'The camera or photo source is unavailable. Continue without a photo.';

  @override
  String get photoInvalidFile =>
      'The selected image could not be opened. Choose another image.';

  @override
  String get photoStorageError =>
      'The photo could not be copied into private app storage. Continue without it or try again.';

  @override
  String get photoGenericError =>
      'The photo could not be added. Try again or continue without it.';

  @override
  String get contextPhotoUnavailable =>
      'The saved photo is no longer available on this phone.';

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

  @override
  String get explanationSectionTitle => 'Explain the skill';

  @override
  String get explanationHint =>
      'Describe what you want to teach in your own words.';

  @override
  String get explanationHelper =>
      'Write or dictate at least 20 characters. Review the text before saving.';

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
  String get aiReadinessTitle => 'AI connection';

  @override
  String get aiReadinessIdleBody =>
      'Check the secure AI connection before generating a family lesson.';

  @override
  String get aiCheckingTitle => 'Checking AI connection…';

  @override
  String get aiCheckingBody => 'Naseej is sending one fixed test phrase only.';

  @override
  String get aiReadyTitle => 'AI connection is ready';

  @override
  String get aiReadyBody =>
      'Firebase AI Logic responded successfully. Lesson generation will be added in the next build.';

  @override
  String get aiUnavailableTitle => 'AI is unavailable right now';

  @override
  String get aiCheckConnectionLabel => 'Check AI connection';

  @override
  String get aiCheckAgainLabel => 'Check again';

  @override
  String get aiCheckingButtonLabel => 'Checking…';

  @override
  String get aiNoFamilyDataNotice =>
      'This check does not send your draft text or context photo.';

  @override
  String aiModelLabel(String model) {
    return 'Model: $model';
  }

  @override
  String get aiFirebaseConfigError =>
      'Firebase is not configured correctly in this build. Your local draft remains safe.';

  @override
  String get aiOfflineError =>
      'The AI service could not be reached. Continue using your locally saved draft and try again when connected.';

  @override
  String get aiAppCheckError =>
      'This test device has not been approved by App Check yet. Register its debug token and try again.';

  @override
  String get aiQuotaError =>
      'The AI request limit has been reached. Your local draft remains available.';

  @override
  String get aiServiceDisabledError =>
      'Firebase AI Logic is not enabled for this project yet.';

  @override
  String get aiInvalidResponseError =>
      'The AI service responded, but the connection test result was unexpected. Try again.';

  @override
  String get aiGenericError =>
      'The AI check could not be completed. Continue using the local app and try again later.';
}
