import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// The application title
  ///
  /// In en, this message translates to:
  /// **'Naseej'**
  String get appTitle;

  /// No description provided for @appNameEnglish.
  ///
  /// In en, this message translates to:
  /// **'Naseej'**
  String get appNameEnglish;

  /// No description provided for @appNameArabic.
  ///
  /// In en, this message translates to:
  /// **'نسيج'**
  String get appNameArabic;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Every generation teaches. Every generation learns.'**
  String get tagline;

  /// No description provided for @englishLanguage.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishLanguage;

  /// No description provided for @arabicLanguage.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabicLanguage;

  /// No description provided for @privacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Private by design'**
  String get privacyTitle;

  /// No description provided for @privacyBody.
  ///
  /// In en, this message translates to:
  /// **'No account or location is needed to begin.'**
  String get privacyBody;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @changeLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get changeLanguageLabel;

  /// No description provided for @profileSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your local profile'**
  String get profileSetupTitle;

  /// No description provided for @profileSetupBody.
  ///
  /// In en, this message translates to:
  /// **'Choose a nickname and role. This information stays on this phone.'**
  String get profileSetupBody;

  /// No description provided for @nicknameLabel.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get nicknameLabel;

  /// No description provided for @nicknameHint.
  ///
  /// In en, this message translates to:
  /// **'For example, Fatima'**
  String get nicknameHint;

  /// No description provided for @chooseRoleLabel.
  ///
  /// In en, this message translates to:
  /// **'Choose your role'**
  String get chooseRoleLabel;

  /// No description provided for @roleGrandparent.
  ///
  /// In en, this message translates to:
  /// **'Grandparent'**
  String get roleGrandparent;

  /// No description provided for @roleParent.
  ///
  /// In en, this message translates to:
  /// **'Parent'**
  String get roleParent;

  /// No description provided for @roleTeen.
  ///
  /// In en, this message translates to:
  /// **'Teen'**
  String get roleTeen;

  /// No description provided for @roleChild.
  ///
  /// In en, this message translates to:
  /// **'Child'**
  String get roleChild;

  /// No description provided for @saveProfileLabel.
  ///
  /// In en, this message translates to:
  /// **'Save profile'**
  String get saveProfileLabel;

  /// No description provided for @savingProfileLabel.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get savingProfileLabel;

  /// No description provided for @profileSaveError.
  ///
  /// In en, this message translates to:
  /// **'We could not save this profile. Please try again.'**
  String get profileSaveError;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String homeGreeting(String name);

  /// No description provided for @profileStoredLocally.
  ///
  /// In en, this message translates to:
  /// **'Saved on this phone'**
  String get profileStoredLocally;

  /// No description provided for @emptyWeaveTitle.
  ///
  /// In en, this message translates to:
  /// **'Your family weave starts here'**
  String get emptyWeaveTitle;

  /// No description provided for @emptyWeaveBody.
  ///
  /// In en, this message translates to:
  /// **'Teach one skill and learn one skill to create your first thread.'**
  String get emptyWeaveBody;

  /// No description provided for @teachSkillLabel.
  ///
  /// In en, this message translates to:
  /// **'Teach a Skill'**
  String get teachSkillLabel;

  /// No description provided for @learnSkillLabel.
  ///
  /// In en, this message translates to:
  /// **'Learn a Skill'**
  String get learnSkillLabel;

  /// No description provided for @featureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'This feature will be connected in the next build.'**
  String get featureComingSoon;

  /// No description provided for @teachSkillScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Teach a Skill'**
  String get teachSkillScreenTitle;

  /// No description provided for @teacherSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Teacher'**
  String get teacherSectionTitle;

  /// No description provided for @teacherCardBody.
  ///
  /// In en, this message translates to:
  /// **'This profile will be the teacher for this draft.'**
  String get teacherCardBody;

  /// No description provided for @learnerSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Who will learn?'**
  String get learnerSectionTitle;

  /// No description provided for @learnerNicknameLabel.
  ///
  /// In en, this message translates to:
  /// **'Learner nickname'**
  String get learnerNicknameLabel;

  /// No description provided for @learnerNicknameHint.
  ///
  /// In en, this message translates to:
  /// **'For example, Mariam'**
  String get learnerNicknameHint;

  /// No description provided for @learnerRoleLabel.
  ///
  /// In en, this message translates to:
  /// **'Choose the learner\'s role'**
  String get learnerRoleLabel;

  /// No description provided for @categorySectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a skill category'**
  String get categorySectionTitle;

  /// No description provided for @skillCategoryHeritage.
  ///
  /// In en, this message translates to:
  /// **'Heritage & Etiquette'**
  String get skillCategoryHeritage;

  /// No description provided for @skillCategoryEveryday.
  ///
  /// In en, this message translates to:
  /// **'Everyday Skill'**
  String get skillCategoryEveryday;

  /// No description provided for @skillCategoryDigital.
  ///
  /// In en, this message translates to:
  /// **'Digital Confidence'**
  String get skillCategoryDigital;

  /// No description provided for @skillCategoryFamilyCare.
  ///
  /// In en, this message translates to:
  /// **'Family Care'**
  String get skillCategoryFamilyCare;

  /// No description provided for @contextPhotoSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Context photo'**
  String get contextPhotoSectionTitle;

  /// No description provided for @contextPhotoTitle.
  ///
  /// In en, this message translates to:
  /// **'Show the object or setting'**
  String get contextPhotoTitle;

  /// No description provided for @contextPhotoBody.
  ///
  /// In en, this message translates to:
  /// **'Add one optional photo to help the learner understand the skill.'**
  String get contextPhotoBody;

  /// No description provided for @addContextPhotoLabel.
  ///
  /// In en, this message translates to:
  /// **'Add context photo'**
  String get addContextPhotoLabel;

  /// No description provided for @replaceContextPhotoLabel.
  ///
  /// In en, this message translates to:
  /// **'Replace photo'**
  String get replaceContextPhotoLabel;

  /// No description provided for @removeContextPhotoLabel.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get removeContextPhotoLabel;

  /// No description provided for @takePhotoLabel.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get takePhotoLabel;

  /// No description provided for @chooseFromGalleryLabel.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseFromGalleryLabel;

  /// No description provided for @cancelLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelLabel;

  /// No description provided for @photoProcessingLabel.
  ///
  /// In en, this message translates to:
  /// **'Preparing photo…'**
  String get photoProcessingLabel;

  /// No description provided for @photoPrivacyNotice.
  ///
  /// In en, this message translates to:
  /// **'This photo stays on this phone and is not sent to AI in this MVP.'**
  String get photoPrivacyNotice;

  /// No description provided for @photoPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Photo access was denied. Continue without a photo or change the permission in Android Settings.'**
  String get photoPermissionDenied;

  /// No description provided for @photoSourceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The camera or photo source is unavailable. Continue without a photo.'**
  String get photoSourceUnavailable;

  /// No description provided for @photoInvalidFile.
  ///
  /// In en, this message translates to:
  /// **'The selected image could not be opened. Choose another image.'**
  String get photoInvalidFile;

  /// No description provided for @photoStorageError.
  ///
  /// In en, this message translates to:
  /// **'The photo could not be copied into private app storage. Continue without it or try again.'**
  String get photoStorageError;

  /// No description provided for @photoGenericError.
  ///
  /// In en, this message translates to:
  /// **'The photo could not be added. Try again or continue without it.'**
  String get photoGenericError;

  /// No description provided for @contextPhotoUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The saved photo is no longer available on this phone.'**
  String get contextPhotoUnavailable;

  /// No description provided for @voiceInputSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Voice input'**
  String get voiceInputSectionTitle;

  /// No description provided for @voiceInputTitle.
  ///
  /// In en, this message translates to:
  /// **'Speak your explanation'**
  String get voiceInputTitle;

  /// No description provided for @voiceInputBody.
  ///
  /// In en, this message translates to:
  /// **'Speak a short explanation. Recognized words will appear in the editable field below.'**
  String get voiceInputBody;

  /// No description provided for @speechListeningTitle.
  ///
  /// In en, this message translates to:
  /// **'Listening…'**
  String get speechListeningTitle;

  /// No description provided for @speechListeningBody.
  ///
  /// In en, this message translates to:
  /// **'Speak clearly. Recognized words are appearing below.'**
  String get speechListeningBody;

  /// No description provided for @speechUnavailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Microphone unavailable'**
  String get speechUnavailableTitle;

  /// No description provided for @speechPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission was denied. Continue by typing below. To enable it later, use Android Settings.'**
  String get speechPermissionDenied;

  /// No description provided for @speechNetworkError.
  ///
  /// In en, this message translates to:
  /// **'The speech service could not connect. Continue by typing or try again later.'**
  String get speechNetworkError;

  /// No description provided for @speechNoMatch.
  ///
  /// In en, this message translates to:
  /// **'No clear speech was recognized. Try again or continue typing.'**
  String get speechNoMatch;

  /// No description provided for @speechGenericError.
  ///
  /// In en, this message translates to:
  /// **'Voice input was interrupted. Try again or continue typing.'**
  String get speechGenericError;

  /// No description provided for @startSpeakingLabel.
  ///
  /// In en, this message translates to:
  /// **'Start speaking'**
  String get startSpeakingLabel;

  /// No description provided for @stopListeningLabel.
  ///
  /// In en, this message translates to:
  /// **'Stop listening'**
  String get stopListeningLabel;

  /// No description provided for @typedFallbackLabel.
  ///
  /// In en, this message translates to:
  /// **'Type below instead'**
  String get typedFallbackLabel;

  /// No description provided for @voicePrivacyNotice.
  ///
  /// In en, this message translates to:
  /// **'Naseej does not save audio. Your device’s speech service may process speech online. Review and edit the text before saving.'**
  String get voicePrivacyNotice;

  /// No description provided for @explanationSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Explain the skill'**
  String get explanationSectionTitle;

  /// No description provided for @explanationHint.
  ///
  /// In en, this message translates to:
  /// **'Describe what you want to teach in your own words.'**
  String get explanationHint;

  /// No description provided for @explanationHelper.
  ///
  /// In en, this message translates to:
  /// **'Write or dictate at least 20 characters. Review the text before saving.'**
  String get explanationHelper;

  /// No description provided for @saveDraftLabel.
  ///
  /// In en, this message translates to:
  /// **'Save Draft'**
  String get saveDraftLabel;

  /// No description provided for @savingDraftLabel.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get savingDraftLabel;

  /// No description provided for @draftSaveError.
  ///
  /// In en, this message translates to:
  /// **'We could not save this draft. Please try again.'**
  String get draftSaveError;

  /// No description provided for @savedDraftTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved skill draft'**
  String get savedDraftTitle;

  /// No description provided for @draftLearnerSummary.
  ///
  /// In en, this message translates to:
  /// **'Learner: {name} — {role}'**
  String draftLearnerSummary(String name, String role);

  /// No description provided for @draftCategorySummary.
  ///
  /// In en, this message translates to:
  /// **'Category: {category}'**
  String draftCategorySummary(String category);

  /// No description provided for @draftStoredLocally.
  ///
  /// In en, this message translates to:
  /// **'Saved on this phone and ready to continue.'**
  String get draftStoredLocally;

  /// No description provided for @continueDraftLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue Draft'**
  String get continueDraftLabel;

  /// No description provided for @aiReadinessTitle.
  ///
  /// In en, this message translates to:
  /// **'AI connection'**
  String get aiReadinessTitle;

  /// No description provided for @aiReadinessIdleBody.
  ///
  /// In en, this message translates to:
  /// **'Check the secure AI connection before generating a family lesson.'**
  String get aiReadinessIdleBody;

  /// No description provided for @aiCheckingTitle.
  ///
  /// In en, this message translates to:
  /// **'Checking AI connection…'**
  String get aiCheckingTitle;

  /// No description provided for @aiCheckingBody.
  ///
  /// In en, this message translates to:
  /// **'Naseej is sending one fixed test phrase only.'**
  String get aiCheckingBody;

  /// No description provided for @aiReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'AI connection is ready'**
  String get aiReadyTitle;

  /// No description provided for @aiReadyBody.
  ///
  /// In en, this message translates to:
  /// **'Firebase AI Logic responded successfully.'**
  String get aiReadyBody;

  /// No description provided for @aiUnavailableTitle.
  ///
  /// In en, this message translates to:
  /// **'AI is unavailable right now'**
  String get aiUnavailableTitle;

  /// No description provided for @aiCheckConnectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Check AI connection'**
  String get aiCheckConnectionLabel;

  /// No description provided for @aiCheckAgainLabel.
  ///
  /// In en, this message translates to:
  /// **'Check again'**
  String get aiCheckAgainLabel;

  /// No description provided for @aiCheckingButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Checking…'**
  String get aiCheckingButtonLabel;

  /// No description provided for @aiNoFamilyDataNotice.
  ///
  /// In en, this message translates to:
  /// **'This check does not send your draft text or context photo.'**
  String get aiNoFamilyDataNotice;

  /// No description provided for @aiModelLabel.
  ///
  /// In en, this message translates to:
  /// **'Model: {model}'**
  String aiModelLabel(String model);

  /// No description provided for @aiFirebaseConfigError.
  ///
  /// In en, this message translates to:
  /// **'Firebase is not configured correctly in this build. Your local draft remains safe.'**
  String get aiFirebaseConfigError;

  /// No description provided for @aiOfflineError.
  ///
  /// In en, this message translates to:
  /// **'The AI service could not be reached. Continue using your locally saved draft and try again when connected.'**
  String get aiOfflineError;

  /// No description provided for @aiAppCheckError.
  ///
  /// In en, this message translates to:
  /// **'This test device has not been approved by App Check yet. Register its debug token and try again.'**
  String get aiAppCheckError;

  /// No description provided for @aiQuotaError.
  ///
  /// In en, this message translates to:
  /// **'The AI request limit has been reached. Your local draft remains available.'**
  String get aiQuotaError;

  /// No description provided for @aiServiceDisabledError.
  ///
  /// In en, this message translates to:
  /// **'Firebase AI Logic is not enabled for this project yet.'**
  String get aiServiceDisabledError;

  /// No description provided for @aiInvalidResponseError.
  ///
  /// In en, this message translates to:
  /// **'The AI service responded, but the connection-test result was unexpected.'**
  String get aiInvalidResponseError;

  /// No description provided for @aiGenericError.
  ///
  /// In en, this message translates to:
  /// **'The AI check could not be completed. Continue using the local app and try again later.'**
  String get aiGenericError;

  /// No description provided for @buildSkillCardLabel.
  ///
  /// In en, this message translates to:
  /// **'Build 3-Step Card'**
  String get buildSkillCardLabel;

  /// No description provided for @reviewSkillCardLabel.
  ///
  /// In en, this message translates to:
  /// **'Review 3-Step Card'**
  String get reviewSkillCardLabel;

  /// No description provided for @savedSkillCardSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'3-Step Card Ready'**
  String get savedSkillCardSummaryTitle;

  /// No description provided for @savedSkillCardSummaryBody.
  ///
  /// In en, this message translates to:
  /// **'A reviewed three-step card is saved on this phone.'**
  String get savedSkillCardSummaryBody;

  /// No description provided for @skillCardScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'3-Step Skill Card'**
  String get skillCardScreenTitle;

  /// No description provided for @aiDataBoundaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Before generating'**
  String get aiDataBoundaryTitle;

  /// No description provided for @aiDataSentTitle.
  ///
  /// In en, this message translates to:
  /// **'What will be sent'**
  String get aiDataSentTitle;

  /// No description provided for @aiDataSentBody.
  ///
  /// In en, this message translates to:
  /// **'Your reviewed explanation, teacher and learner roles, skill category, and selected output language.'**
  String get aiDataSentBody;

  /// No description provided for @aiDataNotSentTitle.
  ///
  /// In en, this message translates to:
  /// **'What will stay on this phone'**
  String get aiDataNotSentTitle;

  /// No description provided for @aiDataNotSentBody.
  ///
  /// In en, this message translates to:
  /// **'Stored nicknames and the context photo. A name typed inside your explanation is part of the reviewed text and will be sent.'**
  String get aiDataNotSentBody;

  /// No description provided for @skillCardChoiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Build the family lesson'**
  String get skillCardChoiceTitle;

  /// No description provided for @skillCardChoiceBody.
  ///
  /// In en, this message translates to:
  /// **'Generate a structured card with AI or continue immediately with a local Offline Guide.'**
  String get skillCardChoiceBody;

  /// No description provided for @generateWithAiLabel.
  ///
  /// In en, this message translates to:
  /// **'Generate with AI'**
  String get generateWithAiLabel;

  /// No description provided for @useOfflineGuideLabel.
  ///
  /// In en, this message translates to:
  /// **'Use Offline Guide'**
  String get useOfflineGuideLabel;

  /// No description provided for @skillCardGeneratingTitle.
  ///
  /// In en, this message translates to:
  /// **'Building your three-step card…'**
  String get skillCardGeneratingTitle;

  /// No description provided for @skillCardGeneratingBody.
  ///
  /// In en, this message translates to:
  /// **'Naseej is structuring the reviewed explanation. The preview will not be saved automatically.'**
  String get skillCardGeneratingBody;

  /// No description provided for @skillCardAiOrigin.
  ///
  /// In en, this message translates to:
  /// **'AI-generated draft'**
  String get skillCardAiOrigin;

  /// No description provided for @skillCardOfflineOrigin.
  ///
  /// In en, this message translates to:
  /// **'Offline Guide'**
  String get skillCardOfflineOrigin;

  /// No description provided for @skillCardModelLabel.
  ///
  /// In en, this message translates to:
  /// **'Model: {model}'**
  String skillCardModelLabel(String model);

  /// No description provided for @skillCardStepLabel.
  ///
  /// In en, this message translates to:
  /// **'Step {number}'**
  String skillCardStepLabel(int number);

  /// No description provided for @safetyNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Safety note'**
  String get safetyNoteTitle;

  /// No description provided for @teachBackQuestionTitle.
  ///
  /// In en, this message translates to:
  /// **'Teach-back question'**
  String get teachBackQuestionTitle;

  /// No description provided for @reciprocalSuggestionTitle.
  ///
  /// In en, this message translates to:
  /// **'Teach in return'**
  String get reciprocalSuggestionTitle;

  /// No description provided for @saveSkillCardLabel.
  ///
  /// In en, this message translates to:
  /// **'Save 3-Step Card'**
  String get saveSkillCardLabel;

  /// No description provided for @savingSkillCardLabel.
  ///
  /// In en, this message translates to:
  /// **'Saving card…'**
  String get savingSkillCardLabel;

  /// No description provided for @backToHomeLabel.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHomeLabel;

  /// No description provided for @regenerateWithAiLabel.
  ///
  /// In en, this message translates to:
  /// **'Generate again with AI'**
  String get regenerateWithAiLabel;

  /// No description provided for @skillCardSaveError.
  ///
  /// In en, this message translates to:
  /// **'The card could not be saved. Return to the draft and try again.'**
  String get skillCardSaveError;

  /// No description provided for @skillCardFirebaseError.
  ///
  /// In en, this message translates to:
  /// **'Firebase is unavailable, so Naseej created a local Offline Guide.'**
  String get skillCardFirebaseError;

  /// No description provided for @skillCardOfflineError.
  ///
  /// In en, this message translates to:
  /// **'The AI service could not be reached, so Naseej created a local Offline Guide.'**
  String get skillCardOfflineError;

  /// No description provided for @skillCardAppCheckError.
  ///
  /// In en, this message translates to:
  /// **'App Check rejected the cloud request, so Naseej created a local Offline Guide.'**
  String get skillCardAppCheckError;

  /// No description provided for @skillCardQuotaError.
  ///
  /// In en, this message translates to:
  /// **'The AI request limit was reached, so Naseej created a local Offline Guide.'**
  String get skillCardQuotaError;

  /// No description provided for @skillCardServiceError.
  ///
  /// In en, this message translates to:
  /// **'Firebase AI Logic is unavailable, so Naseej created a local Offline Guide.'**
  String get skillCardServiceError;

  /// No description provided for @skillCardInvalidResponseError.
  ///
  /// In en, this message translates to:
  /// **'The AI response did not pass validation, so Naseej created a local Offline Guide.'**
  String get skillCardInvalidResponseError;

  /// No description provided for @skillCardClarificationError.
  ///
  /// In en, this message translates to:
  /// **'The explanation could not be structured safely. Review the draft; a local Offline Guide is shown for now.'**
  String get skillCardClarificationError;

  /// No description provided for @skillCardGenericError.
  ///
  /// In en, this message translates to:
  /// **'Cloud generation could not be completed, so Naseej created a local Offline Guide.'**
  String get skillCardGenericError;

  /// No description provided for @startLearningLabel.
  ///
  /// In en, this message translates to:
  /// **'Start Learning'**
  String get startLearningLabel;

  /// No description provided for @continueLearningLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue Learning'**
  String get continueLearningLabel;

  /// No description provided for @reviewCompletedLessonLabel.
  ///
  /// In en, this message translates to:
  /// **'Review Completed Lesson'**
  String get reviewCompletedLessonLabel;

  /// No description provided for @learningRequiresCardBody.
  ///
  /// In en, this message translates to:
  /// **'Build and save a 3-Step Card before starting learner practice.'**
  String get learningRequiresCardBody;

  /// No description provided for @learningProgressSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Learner progress'**
  String get learningProgressSummaryTitle;

  /// No description provided for @learningNotStartedBody.
  ///
  /// In en, this message translates to:
  /// **'The learner is ready to begin the three steps.'**
  String get learningNotStartedBody;

  /// No description provided for @learningInProgressBody.
  ///
  /// In en, this message translates to:
  /// **'The learner’s progress is saved locally and can continue later.'**
  String get learningInProgressBody;

  /// No description provided for @learningCompletedBody.
  ///
  /// In en, this message translates to:
  /// **'The learner completed all three steps and the teach-back response.'**
  String get learningCompletedBody;

  /// No description provided for @learnSkillScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Learn a Skill'**
  String get learnSkillScreenTitle;

  /// No description provided for @learnerLessonTitle.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s lesson'**
  String learnerLessonTitle(String name);

  /// No description provided for @learningProgressCount.
  ///
  /// In en, this message translates to:
  /// **'{completed} of {total} steps completed'**
  String learningProgressCount(int completed, int total);

  /// No description provided for @learningOfflineNotice.
  ///
  /// In en, this message translates to:
  /// **'Practice and progress work without internet.'**
  String get learningOfflineNotice;

  /// No description provided for @practiceStepsTitle.
  ///
  /// In en, this message translates to:
  /// **'Practise the three steps'**
  String get practiceStepsTitle;

  /// No description provided for @teachBackResponseLabel.
  ///
  /// In en, this message translates to:
  /// **'Explain what you learned'**
  String get teachBackResponseLabel;

  /// No description provided for @teachBackResponseHint.
  ///
  /// In en, this message translates to:
  /// **'Write the lesson back in your own words.'**
  String get teachBackResponseHint;

  /// No description provided for @teachBackResponseHelper.
  ///
  /// In en, this message translates to:
  /// **'Write at least {minimum} characters. This response stays on this phone.'**
  String teachBackResponseHelper(int minimum);

  /// No description provided for @learningSavingLabel.
  ///
  /// In en, this message translates to:
  /// **'Saving progress…'**
  String get learningSavingLabel;

  /// No description provided for @learningSavedLabel.
  ///
  /// In en, this message translates to:
  /// **'Progress saved on this phone.'**
  String get learningSavedLabel;

  /// No description provided for @learningSaveError.
  ///
  /// In en, this message translates to:
  /// **'Progress could not be saved. Make another change to try again.'**
  String get learningSaveError;

  /// No description provided for @learningChangesPendingLabel.
  ///
  /// In en, this message translates to:
  /// **'Changes are waiting to save.'**
  String get learningChangesPendingLabel;

  /// No description provided for @learningLocalSaveReadyLabel.
  ///
  /// In en, this message translates to:
  /// **'Progress will be saved on this phone.'**
  String get learningLocalSaveReadyLabel;

  /// No description provided for @completeAllStepsLabel.
  ///
  /// In en, this message translates to:
  /// **'Complete all 3 steps'**
  String get completeAllStepsLabel;

  /// No description provided for @writeTeachBackLabel.
  ///
  /// In en, this message translates to:
  /// **'Write your teach-back response'**
  String get writeTeachBackLabel;

  /// No description provided for @completeFamilyLessonLabel.
  ///
  /// In en, this message translates to:
  /// **'Complete Family Lesson'**
  String get completeFamilyLessonLabel;

  /// No description provided for @lessonCompletedLabel.
  ///
  /// In en, this message translates to:
  /// **'Lesson Completed'**
  String get lessonCompletedLabel;

  /// No description provided for @lessonCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Family lesson completed'**
  String get lessonCompletedTitle;

  /// No description provided for @lessonCompletedBody.
  ///
  /// In en, this message translates to:
  /// **'You practised all three steps and explained what you learned.'**
  String get lessonCompletedBody;

  /// No description provided for @listenToStepsTitle.
  ///
  /// In en, this message translates to:
  /// **'Listen to each step'**
  String get listenToStepsTitle;

  /// No description provided for @listenToStepsBody.
  ///
  /// In en, this message translates to:
  /// **'Use one Listen button at a time. You can stop playback before choosing another step.'**
  String get listenToStepsBody;

  /// No description provided for @ttsDeviceNotice.
  ///
  /// In en, this message translates to:
  /// **'Naseej uses a text-to-speech voice installed on this device and does not save an audio file.'**
  String get ttsDeviceNotice;

  /// No description provided for @ttsPreparingLabel.
  ///
  /// In en, this message translates to:
  /// **'Preparing speech…'**
  String get ttsPreparingLabel;

  /// No description provided for @ttsSpeakingLabel.
  ///
  /// In en, this message translates to:
  /// **'A lesson step is being read aloud.'**
  String get ttsSpeakingLabel;

  /// No description provided for @ttsUnavailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Spoken playback is unavailable'**
  String get ttsUnavailableTitle;

  /// No description provided for @ttsLanguageUnavailableBody.
  ///
  /// In en, this message translates to:
  /// **'A voice for the card language is not installed on this device. Continue reading the lesson or install the voice in Android Settings.'**
  String get ttsLanguageUnavailableBody;

  /// No description provided for @ttsPlaybackErrorBody.
  ///
  /// In en, this message translates to:
  /// **'The device could not read this step. You can continue reading, checking steps, and writing your response.'**
  String get ttsPlaybackErrorBody;

  /// No description provided for @listenLabel.
  ///
  /// In en, this message translates to:
  /// **'Listen'**
  String get listenLabel;

  /// No description provided for @stopSpeakingLabel.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stopSpeakingLabel;

  /// No description provided for @replayLabel.
  ///
  /// In en, this message translates to:
  /// **'Replay'**
  String get replayLabel;

  /// No description provided for @familyThreadTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete the Family Thread'**
  String get familyThreadTitle;

  /// No description provided for @familyThreadBody.
  ///
  /// In en, this message translates to:
  /// **'{learner} learned from {teacher}. Now choose one skill {learner} can teach in return.'**
  String familyThreadBody(String learner, String teacher);

  /// No description provided for @familyThreadConnectionLabel.
  ///
  /// In en, this message translates to:
  /// **'{teacher} taught {learner}'**
  String familyThreadConnectionLabel(String teacher, String learner);

  /// No description provided for @familyThreadTaughtTitle.
  ///
  /// In en, this message translates to:
  /// **'Shared skill'**
  String get familyThreadTaughtTitle;

  /// No description provided for @familyThreadLearnedTitle.
  ///
  /// In en, this message translates to:
  /// **'{name} explained'**
  String familyThreadLearnedTitle(String name);

  /// No description provided for @familyThreadSuggestionTitle.
  ///
  /// In en, this message translates to:
  /// **'Naseej suggests teaching in return'**
  String get familyThreadSuggestionTitle;

  /// No description provided for @familyThreadReturnSkillLabel.
  ///
  /// In en, this message translates to:
  /// **'What will {name} teach in return?'**
  String familyThreadReturnSkillLabel(String name);

  /// No description provided for @familyThreadReturnSkillHint.
  ///
  /// In en, this message translates to:
  /// **'For example, how to send a voice note'**
  String get familyThreadReturnSkillHint;

  /// No description provided for @familyThreadReturnSkillHelper.
  ///
  /// In en, this message translates to:
  /// **'Write at least {minimum} characters or use Naseej\'s suggestion.'**
  String familyThreadReturnSkillHelper(int minimum);

  /// No description provided for @familyThreadLocalNotice.
  ///
  /// In en, this message translates to:
  /// **'This family exchange stays on this phone.'**
  String get familyThreadLocalNotice;

  /// No description provided for @useNaseejSuggestionLabel.
  ///
  /// In en, this message translates to:
  /// **'Use Naseej\'s Suggestion'**
  String get useNaseejSuggestionLabel;

  /// No description provided for @completeFamilyThreadLabel.
  ///
  /// In en, this message translates to:
  /// **'Complete Family Thread'**
  String get completeFamilyThreadLabel;

  /// No description provided for @familyThreadSavingLabel.
  ///
  /// In en, this message translates to:
  /// **'Saving Family Thread…'**
  String get familyThreadSavingLabel;

  /// No description provided for @familyThreadCompletedLabel.
  ///
  /// In en, this message translates to:
  /// **'Family Thread Completed'**
  String get familyThreadCompletedLabel;

  /// No description provided for @familyThreadCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'One Family Thread Completed'**
  String get familyThreadCompletedTitle;

  /// No description provided for @familyThreadCompletedBody.
  ///
  /// In en, this message translates to:
  /// **'{teacher} shared one skill. {learner} chose one skill to teach in return.'**
  String familyThreadCompletedBody(String teacher, String learner);

  /// No description provided for @reviewFamilyThreadLabel.
  ///
  /// In en, this message translates to:
  /// **'Review Family Thread'**
  String get reviewFamilyThreadLabel;

  /// No description provided for @familyThreadHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Family Thread completed'**
  String get familyThreadHomeTitle;

  /// No description provided for @familyThreadHomeBody.
  ///
  /// In en, this message translates to:
  /// **'{teacher} and {learner} completed a two-way skill exchange.'**
  String familyThreadHomeBody(String teacher, String learner);

  /// No description provided for @familyThreadReturnSummary.
  ///
  /// In en, this message translates to:
  /// **'Return skill: {skill}'**
  String familyThreadReturnSummary(String skill);

  /// No description provided for @demoDataTooltip.
  ///
  /// In en, this message translates to:
  /// **'Demo and local data'**
  String get demoDataTooltip;

  /// No description provided for @demoDataWelcomeLabel.
  ///
  /// In en, this message translates to:
  /// **'Demo & Local Data'**
  String get demoDataWelcomeLabel;

  /// No description provided for @demoDataScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Demo & Local Data'**
  String get demoDataScreenTitle;

  /// No description provided for @recoveryRepairedTitle.
  ///
  /// In en, this message translates to:
  /// **'Local data repaired'**
  String get recoveryRepairedTitle;

  /// No description provided for @recoveryRepairedBody.
  ///
  /// In en, this message translates to:
  /// **'Naseej found information that no longer matched the current family journey. Valid information was kept and invalid later steps were cleared.'**
  String get recoveryRepairedBody;

  /// No description provided for @recoveryStorageTitle.
  ///
  /// In en, this message translates to:
  /// **'Local storage is unavailable'**
  String get recoveryStorageTitle;

  /// No description provided for @recoveryStorageBody.
  ///
  /// In en, this message translates to:
  /// **'Naseej could not safely read or save local family data. The app remains open, but changes may not survive a restart.'**
  String get recoveryStorageBody;

  /// No description provided for @dismissLabel.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismissLabel;

  /// No description provided for @localDataStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Local journey status'**
  String get localDataStatusTitle;

  /// No description provided for @localDataStatusBody.
  ///
  /// In en, this message translates to:
  /// **'Review which parts of the current family journey are stored on this phone.'**
  String get localDataStatusBody;

  /// No description provided for @profileDataLabel.
  ///
  /// In en, this message translates to:
  /// **'Family profile'**
  String get profileDataLabel;

  /// No description provided for @draftDataLabel.
  ///
  /// In en, this message translates to:
  /// **'Skill draft'**
  String get draftDataLabel;

  /// No description provided for @cardDataLabel.
  ///
  /// In en, this message translates to:
  /// **'3-Step Card'**
  String get cardDataLabel;

  /// No description provided for @progressDataLabel.
  ///
  /// In en, this message translates to:
  /// **'Learner progress'**
  String get progressDataLabel;

  /// No description provided for @familyThreadDataLabel.
  ///
  /// In en, this message translates to:
  /// **'Family Thread'**
  String get familyThreadDataLabel;

  /// No description provided for @statusPresentLabel.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get statusPresentLabel;

  /// No description provided for @statusMissingLabel.
  ///
  /// In en, this message translates to:
  /// **'Missing'**
  String get statusMissingLabel;

  /// No description provided for @statusCompletedLabel.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompletedLabel;

  /// No description provided for @demoPreparationTitle.
  ///
  /// In en, this message translates to:
  /// **'Prepare a reliable demo'**
  String get demoPreparationTitle;

  /// No description provided for @demoPreparationBody.
  ///
  /// In en, this message translates to:
  /// **'Load clearly labeled local sample data without copying private family information into the public repository.'**
  String get demoPreparationBody;

  /// No description provided for @aiReadyDemoTitle.
  ///
  /// In en, this message translates to:
  /// **'AI-ready sample'**
  String get aiReadyDemoTitle;

  /// No description provided for @aiReadyDemoBody.
  ///
  /// In en, this message translates to:
  /// **'Loads a local profile and reviewed draft. Continue through the normal card screen to make the real AI request.'**
  String get aiReadyDemoBody;

  /// No description provided for @loadAiReadyDemoLabel.
  ///
  /// In en, this message translates to:
  /// **'Load AI-Ready Sample'**
  String get loadAiReadyDemoLabel;

  /// No description provided for @completedDemoTitle.
  ///
  /// In en, this message translates to:
  /// **'Completed offline sample'**
  String get completedDemoTitle;

  /// No description provided for @completedDemoBody.
  ///
  /// In en, this message translates to:
  /// **'Loads a complete local Family Thread using an Offline Guide so later screens remain demonstrable without Wi-Fi.'**
  String get completedDemoBody;

  /// No description provided for @loadCompletedDemoLabel.
  ///
  /// In en, this message translates to:
  /// **'Load Completed Offline Sample'**
  String get loadCompletedDemoLabel;

  /// No description provided for @demoSampleNotice.
  ///
  /// In en, this message translates to:
  /// **'This sample contains no generated result. Use the normal Generate with AI action to demonstrate cloud AI.'**
  String get demoSampleNotice;

  /// No description provided for @completedSampleNotice.
  ///
  /// In en, this message translates to:
  /// **'This sample is an Offline Guide and is never presented as a live AI result.'**
  String get completedSampleNotice;

  /// No description provided for @resetDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset local family data'**
  String get resetDataTitle;

  /// No description provided for @resetDataBody.
  ///
  /// In en, this message translates to:
  /// **'Remove the local profile, draft, card, learner progress, Family Thread, and current private context photo when possible. The selected language is kept.'**
  String get resetDataBody;

  /// No description provided for @resetLocalDataLabel.
  ///
  /// In en, this message translates to:
  /// **'Reset Local Family Data'**
  String get resetLocalDataLabel;

  /// No description provided for @confirmDemoReplaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Replace current local data?'**
  String get confirmDemoReplaceTitle;

  /// No description provided for @confirmDemoReplaceBody.
  ///
  /// In en, this message translates to:
  /// **'The current profile, draft, card, progress, and Family Thread will be replaced by clearly labeled sample data.'**
  String get confirmDemoReplaceBody;

  /// No description provided for @confirmResetDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset all local family data?'**
  String get confirmResetDataTitle;

  /// No description provided for @confirmResetDataBody.
  ///
  /// In en, this message translates to:
  /// **'This removes the local family journey from this phone. This action cannot be undone.'**
  String get confirmResetDataBody;

  /// No description provided for @replaceDataLabel.
  ///
  /// In en, this message translates to:
  /// **'Replace Data'**
  String get replaceDataLabel;

  /// No description provided for @resetDataConfirmLabel.
  ///
  /// In en, this message translates to:
  /// **'Reset Data'**
  String get resetDataConfirmLabel;

  /// No description provided for @demoLoadedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Local sample data loaded.'**
  String get demoLoadedSuccess;

  /// No description provided for @dataResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Local family data reset.'**
  String get dataResetSuccess;

  /// No description provided for @dataOperationError.
  ///
  /// In en, this message translates to:
  /// **'The local-data operation could not be completed. Existing data was restored when possible.'**
  String get dataOperationError;

  /// No description provided for @photoCleanupWarning.
  ///
  /// In en, this message translates to:
  /// **'The previous private photo could not be deleted automatically.'**
  String get photoCleanupWarning;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
