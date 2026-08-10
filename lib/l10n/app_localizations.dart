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
  /// **'Write at least 20 characters. Voice input will be added next.'**
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
