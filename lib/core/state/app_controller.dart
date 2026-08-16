import 'package:flutter/widgets.dart';
import 'package:naseej/core/storage/app_storage.dart';
import 'package:naseej/features/demo/domain/demo_journey.dart';
import 'package:naseej/features/learning/domain/learning_progress.dart';
import 'package:naseej/features/profile/domain/family_profile.dart';
import 'package:naseej/features/skill/domain/skill_card.dart';
import 'package:naseej/features/skill/domain/skill_draft.dart';

enum AppRecoveryNotice { none, repairedInvalidData, storageUnavailable }

class AppController extends ChangeNotifier {
  AppController(this._storage);

  final AppStorage _storage;

  Locale _locale = const Locale('en');
  FamilyProfile? _profile;
  SkillDraft? _skillDraft;
  SkillCard? _skillCard;
  LearningProgress? _learningProgress;

  AppRecoveryNotice _recoveryNotice = AppRecoveryNotice.none;

  Locale get locale => _locale;

  FamilyProfile? get profile => _profile;

  SkillDraft? get skillDraft => _skillDraft;

  SkillCard? get skillCard => _skillCard;

  LearningProgress? get learningProgress => _learningProgress;

  AppRecoveryNotice get recoveryNotice => _recoveryNotice;

  bool get hasProfile => _profile != null;

  bool get hasSkillDraft => _skillDraft != null;

  bool get hasSkillCard => _skillCard != null;

  bool get hasLearningProgress => _learningProgress != null;

  bool get hasAnyFamilyData {
    return _profile != null ||
        _skillDraft != null ||
        _skillCard != null ||
        _learningProgress != null;
  }

  Future<void> initialize() async {
    try {
      final String? storedLocaleCode = await _storage.readLocaleCode();

      final String? storedProfileJson = await _storage.readProfileJson();

      final String? storedSkillDraftJson = await _storage.readSkillDraftJson();

      final String? storedSkillCardJson = await _storage.readSkillCardJson();

      final String? storedProgressJson = await _storage
          .readLearningProgressJson();

      final bool localeIsValid =
          storedLocaleCode == null ||
          storedLocaleCode == 'en' ||
          storedLocaleCode == 'ar';

      _locale = Locale(storedLocaleCode == 'ar' ? 'ar' : 'en');

      final FamilyProfile? parsedProfile = FamilyProfile.fromJsonString(
        storedProfileJson,
      );

      final SkillDraft? parsedDraft = SkillDraft.fromJsonString(
        storedSkillDraftJson,
      );

      final SkillCard? parsedCard = SkillCard.fromJsonString(
        storedSkillCardJson,
      );

      final LearningProgress? parsedProgress = LearningProgress.fromJsonString(
        storedProgressJson,
      );

      FamilyProfile? acceptedProfile;
      SkillDraft? acceptedDraft;
      SkillCard? acceptedCard;
      LearningProgress? acceptedProgress;

      bool clearProfileChain = false;
      bool clearDraftChain = false;
      bool clearCardChain = false;
      bool clearProgress = false;

      final bool hasAnyStoredFamilyData =
          storedProfileJson != null ||
          storedSkillDraftJson != null ||
          storedSkillCardJson != null ||
          storedProgressJson != null;

      if (parsedProfile == null) {
        clearProfileChain = hasAnyStoredFamilyData;
      } else {
        acceptedProfile = parsedProfile;

        final bool draftMatchesProfile =
            parsedDraft != null &&
            parsedDraft.teacherNickname == parsedProfile.nickname &&
            parsedDraft.teacherRole == parsedProfile.role;

        if (!draftMatchesProfile) {
          clearDraftChain =
              storedSkillDraftJson != null ||
              storedSkillCardJson != null ||
              storedProgressJson != null;
        } else {
          acceptedDraft = parsedDraft;

          final bool cardMatchesDraft =
              parsedCard != null && parsedCard.matchesDraft(parsedDraft);

          if (!cardMatchesDraft) {
            clearCardChain =
                storedSkillCardJson != null || storedProgressJson != null;
          } else {
            acceptedCard = parsedCard;

            final bool progressMatchesCard =
                parsedProgress != null &&
                parsedProgress.matchesCard(parsedCard);

            if (!progressMatchesCard) {
              clearProgress = storedProgressJson != null;
            } else {
              acceptedProgress = parsedProgress;
            }
          }
        }
      }

      _profile = acceptedProfile;
      _skillDraft = acceptedDraft;
      _skillCard = acceptedCard;
      _learningProgress = acceptedProgress;

      final bool repaired =
          !localeIsValid ||
          clearProfileChain ||
          clearDraftChain ||
          clearCardChain ||
          clearProgress;

      if (!repaired) {
        _recoveryNotice = AppRecoveryNotice.none;

        notifyListeners();
        return;
      }

      try {
        if (!localeIsValid) {
          await _storage.writeLocaleCode('en');
        }

        if (clearProfileChain) {
          await _storage.clearLearningProgress();

          await _storage.clearSkillCard();
          await _storage.clearSkillDraft();
          await _storage.clearProfile();
        } else if (clearDraftChain) {
          await _storage.clearLearningProgress();

          await _storage.clearSkillCard();
          await _storage.clearSkillDraft();
        } else if (clearCardChain) {
          await _storage.clearLearningProgress();

          await _storage.clearSkillCard();
        } else if (clearProgress) {
          await _storage.clearLearningProgress();
        }

        _recoveryNotice = AppRecoveryNotice.repairedInvalidData;
      } catch (_) {
        _recoveryNotice = AppRecoveryNotice.storageUnavailable;
      }
    } catch (_) {
      _locale = const Locale('en');
      _profile = null;
      _skillDraft = null;
      _skillCard = null;
      _learningProgress = null;

      _recoveryNotice = AppRecoveryNotice.storageUnavailable;
    }

    notifyListeners();
  }

  void dismissRecoveryNotice() {
    if (_recoveryNotice == AppRecoveryNotice.none) {
      return;
    }

    _recoveryNotice = AppRecoveryNotice.none;

    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    final String normalizedCode = locale.languageCode == 'ar' ? 'ar' : 'en';

    if (_locale.languageCode == normalizedCode) {
      return;
    }

    _locale = Locale(normalizedCode);
    notifyListeners();

    try {
      await _storage.writeLocaleCode(normalizedCode);
    } catch (_) {
      _recoveryNotice = AppRecoveryNotice.storageUnavailable;

      notifyListeners();
    }
  }

  Future<void> saveProfile(FamilyProfile profile) async {
    await _replaceFamilyState(_LocalFamilyState(profile: profile));
  }

  Future<void> clearProfile() async {
    await resetFamilyData();
  }

  Future<void> saveSkillDraft(SkillDraft draft) async {
    final FamilyProfile? currentProfile = _profile;

    if (currentProfile == null ||
        draft.teacherNickname != currentProfile.nickname ||
        draft.teacherRole != currentProfile.role) {
      throw StateError('The draft does not match the active profile.');
    }

    await _replaceFamilyState(
      _LocalFamilyState(profile: currentProfile, draft: draft),
    );
  }

  Future<void> clearSkillDraft() async {
    await _replaceFamilyState(_LocalFamilyState(profile: _profile));
  }

  Future<void> saveSkillCard(SkillCard card) async {
    final FamilyProfile? currentProfile = _profile;

    final SkillDraft? currentDraft = _skillDraft;

    if (currentProfile == null ||
        currentDraft == null ||
        !card.matchesDraft(currentDraft)) {
      throw StateError('The skill card does not match the current draft.');
    }

    final bool cardChanged =
        _skillCard?.contentFingerprint != card.contentFingerprint;

    await _replaceFamilyState(
      _LocalFamilyState(
        profile: currentProfile,
        draft: currentDraft,
        card: card,
        progress: cardChanged ? null : _learningProgress,
      ),
    );
  }

  Future<void> clearSkillCard() async {
    await _replaceFamilyState(
      _LocalFamilyState(profile: _profile, draft: _skillDraft),
    );
  }

  Future<void> saveLearningProgress(LearningProgress progress) async {
    final FamilyProfile? currentProfile = _profile;

    final SkillDraft? currentDraft = _skillDraft;

    final SkillCard? currentCard = _skillCard;

    if (currentProfile == null ||
        currentDraft == null ||
        currentCard == null ||
        !progress.matchesCard(currentCard)) {
      throw StateError(
        'The learning progress does not match the current card.',
      );
    }

    await _replaceFamilyState(
      _LocalFamilyState(
        profile: currentProfile,
        draft: currentDraft,
        card: currentCard,
        progress: progress,
      ),
    );
  }

  Future<void> clearLearningProgress() async {
    await _replaceFamilyState(
      _LocalFamilyState(
        profile: _profile,
        draft: _skillDraft,
        card: _skillCard,
      ),
    );
  }

  Future<void> loadDemoJourney(DemoJourney journey) async {
    final _LocalFamilyState nextState = _LocalFamilyState(
      profile: journey.profile,
      draft: journey.draft,
      card: journey.card,
      progress: journey.progress,
    );

    _validateFamilyState(nextState);

    await _replaceFamilyState(nextState);
  }

  Future<void> resetFamilyData() async {
    await _replaceFamilyState(const _LocalFamilyState());
  }

  _LocalFamilyState _captureFamilyState() {
    return _LocalFamilyState(
      profile: _profile,
      draft: _skillDraft,
      card: _skillCard,
      progress: _learningProgress,
    );
  }

  Future<void> _replaceFamilyState(_LocalFamilyState nextState) async {
    _validateFamilyState(nextState);

    final _LocalFamilyState previousState = _captureFamilyState();

    try {
      await _persistFamilyState(nextState);

      _applyFamilyState(nextState);

      if (_recoveryNotice == AppRecoveryNotice.storageUnavailable) {
        _recoveryNotice = AppRecoveryNotice.none;
      }

      notifyListeners();
    } catch (_) {
      try {
        await _persistFamilyState(previousState);
      } catch (_) {
        // The original failure is reported.
      }

      _applyFamilyState(previousState);

      _recoveryNotice = AppRecoveryNotice.storageUnavailable;

      notifyListeners();

      rethrow;
    }
  }

  Future<void> _persistFamilyState(_LocalFamilyState state) async {
    if (state.profile == null) {
      await _storage.clearLearningProgress();

      await _storage.clearSkillCard();
      await _storage.clearSkillDraft();
      await _storage.clearProfile();

      return;
    }

    await _storage.writeProfileJson(state.profile!.toJsonString());

    if (state.draft == null) {
      await _storage.clearLearningProgress();

      await _storage.clearSkillCard();
      await _storage.clearSkillDraft();

      return;
    }

    await _storage.writeSkillDraftJson(state.draft!.toJsonString());

    if (state.card == null) {
      await _storage.clearLearningProgress();

      await _storage.clearSkillCard();

      return;
    }

    await _storage.writeSkillCardJson(state.card!.toJsonString());

    if (state.progress == null) {
      await _storage.clearLearningProgress();

      return;
    }

    await _storage.writeLearningProgressJson(state.progress!.toJsonString());
  }

  void _validateFamilyState(_LocalFamilyState state) {
    if (state.profile == null) {
      if (state.draft != null || state.card != null || state.progress != null) {
        throw StateError('Family data cannot exist without a profile.');
      }

      return;
    }

    if (state.draft == null) {
      if (state.card != null || state.progress != null) {
        throw StateError('Card data cannot exist without a draft.');
      }

      return;
    }

    if (state.draft!.teacherNickname != state.profile!.nickname ||
        state.draft!.teacherRole != state.profile!.role) {
      throw StateError('The draft does not match the profile.');
    }

    if (state.card == null) {
      if (state.progress != null) {
        throw StateError('Progress cannot exist without a card.');
      }

      return;
    }

    if (!state.card!.matchesDraft(state.draft!)) {
      throw StateError('The card does not match the draft.');
    }

    if (state.progress != null && !state.progress!.matchesCard(state.card!)) {
      throw StateError('The progress does not match the card.');
    }
  }

  void _applyFamilyState(_LocalFamilyState state) {
    _profile = state.profile;
    _skillDraft = state.draft;
    _skillCard = state.card;
    _learningProgress = state.progress;
  }
}

class _LocalFamilyState {
  const _LocalFamilyState({this.profile, this.draft, this.card, this.progress});

  final FamilyProfile? profile;
  final SkillDraft? draft;
  final SkillCard? card;
  final LearningProgress? progress;
}
