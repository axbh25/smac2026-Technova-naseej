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
  String get aiReadyBody => 'Firebase AI Logic responded successfully.';

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
      'The AI service responded, but the connection-test result was unexpected.';

  @override
  String get aiGenericError =>
      'The AI check could not be completed. Continue using the local app and try again later.';

  @override
  String get buildSkillCardLabel => 'Build 3-Step Card';

  @override
  String get reviewSkillCardLabel => 'Review 3-Step Card';

  @override
  String get savedSkillCardSummaryTitle => '3-Step Card Ready';

  @override
  String get savedSkillCardSummaryBody =>
      'A reviewed three-step card is saved on this phone.';

  @override
  String get skillCardScreenTitle => '3-Step Skill Card';

  @override
  String get aiDataBoundaryTitle => 'Before generating';

  @override
  String get aiDataSentTitle => 'What will be sent';

  @override
  String get aiDataSentBody =>
      'Your reviewed explanation, teacher and learner roles, skill category, and selected output language.';

  @override
  String get aiDataNotSentTitle => 'What will stay on this phone';

  @override
  String get aiDataNotSentBody =>
      'Stored nicknames and the context photo. A name typed inside your explanation is part of the reviewed text and will be sent.';

  @override
  String get skillCardChoiceTitle => 'Build the family lesson';

  @override
  String get skillCardChoiceBody =>
      'Generate a structured card with AI or continue immediately with a local Offline Guide.';

  @override
  String get generateWithAiLabel => 'Generate with AI';

  @override
  String get useOfflineGuideLabel => 'Use Offline Guide';

  @override
  String get skillCardGeneratingTitle => 'Building your three-step card…';

  @override
  String get skillCardGeneratingBody =>
      'Naseej is structuring the reviewed explanation. The preview will not be saved automatically.';

  @override
  String get skillCardAiOrigin => 'AI-generated draft';

  @override
  String get skillCardOfflineOrigin => 'Offline Guide';

  @override
  String skillCardModelLabel(String model) {
    return 'Model: $model';
  }

  @override
  String skillCardStepLabel(int number) {
    return 'Step $number';
  }

  @override
  String get safetyNoteTitle => 'Safety note';

  @override
  String get teachBackQuestionTitle => 'Teach-back question';

  @override
  String get reciprocalSuggestionTitle => 'Teach in return';

  @override
  String get saveSkillCardLabel => 'Save 3-Step Card';

  @override
  String get savingSkillCardLabel => 'Saving card…';

  @override
  String get backToHomeLabel => 'Back to Home';

  @override
  String get regenerateWithAiLabel => 'Generate again with AI';

  @override
  String get skillCardSaveError =>
      'The card could not be saved. Return to the draft and try again.';

  @override
  String get skillCardFirebaseError =>
      'Firebase is unavailable, so Naseej created a local Offline Guide.';

  @override
  String get skillCardOfflineError =>
      'The AI service could not be reached, so Naseej created a local Offline Guide.';

  @override
  String get skillCardAppCheckError =>
      'App Check rejected the cloud request, so Naseej created a local Offline Guide.';

  @override
  String get skillCardQuotaError =>
      'The AI request limit was reached, so Naseej created a local Offline Guide.';

  @override
  String get skillCardServiceError =>
      'Firebase AI Logic is unavailable, so Naseej created a local Offline Guide.';

  @override
  String get skillCardInvalidResponseError =>
      'The AI response did not pass validation, so Naseej created a local Offline Guide.';

  @override
  String get skillCardClarificationError =>
      'The explanation could not be structured safely. Review the draft; a local Offline Guide is shown for now.';

  @override
  String get skillCardGenericError =>
      'Cloud generation could not be completed, so Naseej created a local Offline Guide.';

  @override
  String get startLearningLabel => 'Start Learning';

  @override
  String get continueLearningLabel => 'Continue Learning';

  @override
  String get reviewCompletedLessonLabel => 'Review Completed Lesson';

  @override
  String get learningRequiresCardBody =>
      'Build and save a 3-Step Card before starting learner practice.';

  @override
  String get learningProgressSummaryTitle => 'Learner progress';

  @override
  String get learningNotStartedBody =>
      'The learner is ready to begin the three steps.';

  @override
  String get learningInProgressBody =>
      'The learner’s progress is saved locally and can continue later.';

  @override
  String get learningCompletedBody =>
      'The learner completed all three steps and the teach-back response.';

  @override
  String get learnSkillScreenTitle => 'Learn a Skill';

  @override
  String learnerLessonTitle(String name) {
    return '$name\'s lesson';
  }

  @override
  String learningProgressCount(int completed, int total) {
    return '$completed of $total steps completed';
  }

  @override
  String get learningOfflineNotice =>
      'Practice and progress work without internet.';

  @override
  String get practiceStepsTitle => 'Practise the three steps';

  @override
  String get teachBackResponseLabel => 'Explain what you learned';

  @override
  String get teachBackResponseHint =>
      'Write the lesson back in your own words.';

  @override
  String teachBackResponseHelper(int minimum) {
    return 'Write at least $minimum characters. This response stays on this phone.';
  }

  @override
  String get learningSavingLabel => 'Saving progress…';

  @override
  String get learningSavedLabel => 'Progress saved on this phone.';

  @override
  String get learningSaveError =>
      'Progress could not be saved. Make another change to try again.';

  @override
  String get learningChangesPendingLabel => 'Changes are waiting to save.';

  @override
  String get learningLocalSaveReadyLabel =>
      'Progress will be saved on this phone.';

  @override
  String get completeAllStepsLabel => 'Complete all 3 steps';

  @override
  String get writeTeachBackLabel => 'Write your teach-back response';

  @override
  String get completeFamilyLessonLabel => 'Complete Family Lesson';

  @override
  String get lessonCompletedLabel => 'Lesson Completed';

  @override
  String get lessonCompletedTitle => 'Family lesson completed';

  @override
  String get lessonCompletedBody =>
      'You practised all three steps and explained what you learned.';

  @override
  String get listenToStepsTitle => 'Listen to each step';

  @override
  String get listenToStepsBody =>
      'Use one Listen button at a time. You can stop playback before choosing another step.';

  @override
  String get ttsDeviceNotice =>
      'Naseej uses a text-to-speech voice installed on this device and does not save an audio file.';

  @override
  String get ttsPreparingLabel => 'Preparing speech…';

  @override
  String get ttsSpeakingLabel => 'A lesson step is being read aloud.';

  @override
  String get ttsUnavailableTitle => 'Spoken playback is unavailable';

  @override
  String get ttsLanguageUnavailableBody =>
      'A voice for the card language is not installed on this device. Continue reading the lesson or install the voice in Android Settings.';

  @override
  String get ttsPlaybackErrorBody =>
      'The device could not read this step. You can continue reading, checking steps, and writing your response.';

  @override
  String get listenLabel => 'Listen';

  @override
  String get stopSpeakingLabel => 'Stop';

  @override
  String get replayLabel => 'Replay';

  @override
  String get familyThreadTitle => 'Complete the Family Thread';

  @override
  String familyThreadBody(String learner, String teacher) {
    return '$learner learned from $teacher. Now choose one skill $learner can teach in return.';
  }

  @override
  String familyThreadConnectionLabel(String teacher, String learner) {
    return '$teacher taught $learner';
  }

  @override
  String get familyThreadTaughtTitle => 'Shared skill';

  @override
  String familyThreadLearnedTitle(String name) {
    return '$name explained';
  }

  @override
  String get familyThreadSuggestionTitle =>
      'Naseej suggests teaching in return';

  @override
  String familyThreadReturnSkillLabel(String name) {
    return 'What will $name teach in return?';
  }

  @override
  String get familyThreadReturnSkillHint =>
      'For example, how to send a voice note';

  @override
  String familyThreadReturnSkillHelper(int minimum) {
    return 'Write at least $minimum characters or use Naseej\'s suggestion.';
  }

  @override
  String get familyThreadLocalNotice =>
      'This family exchange stays on this phone.';

  @override
  String get useNaseejSuggestionLabel => 'Use Naseej\'s Suggestion';

  @override
  String get completeFamilyThreadLabel => 'Complete Family Thread';

  @override
  String get familyThreadSavingLabel => 'Saving Family Thread…';

  @override
  String get familyThreadCompletedLabel => 'Family Thread Completed';

  @override
  String get familyThreadCompletedTitle => 'One Family Thread Completed';

  @override
  String familyThreadCompletedBody(String teacher, String learner) {
    return '$teacher shared one skill. $learner chose one skill to teach in return.';
  }

  @override
  String get reviewFamilyThreadLabel => 'Review Family Thread';

  @override
  String get familyThreadHomeTitle => 'Family Thread completed';

  @override
  String familyThreadHomeBody(String teacher, String learner) {
    return '$teacher and $learner completed a two-way skill exchange.';
  }

  @override
  String familyThreadReturnSummary(String skill) {
    return 'Return skill: $skill';
  }

  @override
  String get demoDataTooltip => 'Demo and local data';

  @override
  String get demoDataWelcomeLabel => 'Demo & Local Data';

  @override
  String get demoDataScreenTitle => 'Demo & Local Data';

  @override
  String get recoveryRepairedTitle => 'Local data repaired';

  @override
  String get recoveryRepairedBody =>
      'Naseej found information that no longer matched the current family journey. Valid information was kept and invalid later steps were cleared.';

  @override
  String get recoveryStorageTitle => 'Local storage is unavailable';

  @override
  String get recoveryStorageBody =>
      'Naseej could not safely read or save local family data. The app remains open, but changes may not survive a restart.';

  @override
  String get dismissLabel => 'Dismiss';

  @override
  String get localDataStatusTitle => 'Local journey status';

  @override
  String get localDataStatusBody =>
      'Review which parts of the current family journey are stored on this phone.';

  @override
  String get profileDataLabel => 'Family profile';

  @override
  String get draftDataLabel => 'Skill draft';

  @override
  String get cardDataLabel => '3-Step Card';

  @override
  String get progressDataLabel => 'Learner progress';

  @override
  String get familyThreadDataLabel => 'Family Thread';

  @override
  String get statusPresentLabel => 'Available';

  @override
  String get statusMissingLabel => 'Missing';

  @override
  String get statusCompletedLabel => 'Completed';

  @override
  String get demoPreparationTitle => 'Prepare a reliable demo';

  @override
  String get demoPreparationBody =>
      'Load clearly labeled local sample data without copying private family information into the public repository.';

  @override
  String get aiReadyDemoTitle => 'AI-ready sample';

  @override
  String get aiReadyDemoBody =>
      'Loads a local profile and reviewed draft. Continue through the normal card screen to make the real AI request.';

  @override
  String get loadAiReadyDemoLabel => 'Load AI-Ready Sample';

  @override
  String get completedDemoTitle => 'Completed offline sample';

  @override
  String get completedDemoBody =>
      'Loads a complete local Family Thread using an Offline Guide so later screens remain demonstrable without Wi-Fi.';

  @override
  String get loadCompletedDemoLabel => 'Load Completed Offline Sample';

  @override
  String get demoSampleNotice =>
      'This sample contains no generated result. Use the normal Generate with AI action to demonstrate cloud AI.';

  @override
  String get completedSampleNotice =>
      'This sample is an Offline Guide and is never presented as a live AI result.';

  @override
  String get resetDataTitle => 'Reset local family data';

  @override
  String get resetDataBody =>
      'Remove the local profile, draft, card, learner progress, Family Thread, and current private context photo when possible. The selected language is kept.';

  @override
  String get resetLocalDataLabel => 'Reset Local Family Data';

  @override
  String get confirmDemoReplaceTitle => 'Replace current local data?';

  @override
  String get confirmDemoReplaceBody =>
      'The current profile, draft, card, progress, and Family Thread will be replaced by clearly labeled sample data.';

  @override
  String get confirmResetDataTitle => 'Reset all local family data?';

  @override
  String get confirmResetDataBody =>
      'This removes the local family journey from this phone. This action cannot be undone.';

  @override
  String get replaceDataLabel => 'Replace Data';

  @override
  String get resetDataConfirmLabel => 'Reset Data';

  @override
  String get demoLoadedSuccess => 'Local sample data loaded.';

  @override
  String get dataResetSuccess => 'Local family data reset.';

  @override
  String get dataOperationError =>
      'The local-data operation could not be completed. Existing data was restored when possible.';

  @override
  String get photoCleanupWarning =>
      'The previous private photo could not be deleted automatically.';
}
