import 'package:flutter/widgets.dart';
import 'package:naseej/core/storage/app_storage.dart';
import 'package:naseej/features/learning/domain/learning_progress.dart';
import 'package:naseej/features/profile/domain/family_profile.dart';
import 'package:naseej/features/skill/domain/skill_card.dart';
import 'package:naseej/features/skill/domain/skill_draft.dart';

class AppController extends ChangeNotifier {
  AppController(this._storage);

  final AppStorage _storage;

  Locale _locale = const Locale('en');
  FamilyProfile? _profile;
  SkillDraft? _skillDraft;
  SkillCard? _skillCard;
  LearningProgress? _learningProgress;

  Locale get locale => _locale;

  FamilyProfile? get profile => _profile;

  SkillDraft? get skillDraft => _skillDraft;

  SkillCard? get skillCard => _skillCard;

  LearningProgress? get learningProgress => _learningProgress;

  bool get hasProfile => _profile != null;

  bool get hasSkillDraft => _skillDraft != null;

  bool get hasSkillCard => _skillCard != null;

  bool get hasLearningProgress => _learningProgress != null;

  Future<void> initialize() async {
    try {
      final String? storedLocaleCode = await _storage.readLocaleCode();

      final String? storedProfileJson = await _storage.readProfileJson();

      final String? storedSkillDraftJson = await _storage.readSkillDraftJson();

      final String? storedSkillCardJson = await _storage.readSkillCardJson();

      final String? storedLearningProgressJson = await _storage
          .readLearningProgressJson();

      if (storedLocaleCode == 'ar' || storedLocaleCode == 'en') {
        _locale = Locale(storedLocaleCode!);
      }

      final FamilyProfile? restoredProfile = FamilyProfile.fromJsonString(
        storedProfileJson,
      );

      final SkillDraft? restoredDraft = SkillDraft.fromJsonString(
        storedSkillDraftJson,
      );

      final SkillCard? restoredCard = SkillCard.fromJsonString(
        storedSkillCardJson,
      );

      final LearningProgress? restoredProgress =
          LearningProgress.fromJsonString(storedLearningProgressJson);

      _profile = restoredProfile;

      if (restoredProfile != null &&
          restoredDraft != null &&
          restoredDraft.teacherNickname == restoredProfile.nickname &&
          restoredDraft.teacherRole == restoredProfile.role) {
        _skillDraft = restoredDraft;
      } else {
        _skillDraft = null;
      }

      if (_skillDraft != null &&
          restoredCard != null &&
          restoredCard.matchesDraft(_skillDraft!)) {
        _skillCard = restoredCard;
      } else {
        _skillCard = null;
      }

      if (_skillCard != null &&
          restoredProgress != null &&
          restoredProgress.matchesCard(_skillCard!)) {
        _learningProgress = restoredProgress;
      } else {
        _learningProgress = null;
      }
    } catch (_) {
      _locale = const Locale('en');
      _profile = null;
      _skillDraft = null;
      _skillCard = null;
      _learningProgress = null;
    }
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
      // The in-memory language remains usable.
    }
  }

  Future<void> saveProfile(FamilyProfile profile) async {
    await _storage.writeProfileJson(profile.toJsonString());

    await _storage.clearSkillDraft();
    await _storage.clearSkillCard();
    await _storage.clearLearningProgress();

    _profile = profile;
    _skillDraft = null;
    _skillCard = null;
    _learningProgress = null;

    notifyListeners();
  }

  Future<void> clearProfile() async {
    await _storage.clearProfile();
    await _storage.clearSkillDraft();
    await _storage.clearSkillCard();
    await _storage.clearLearningProgress();

    _profile = null;
    _skillDraft = null;
    _skillCard = null;
    _learningProgress = null;

    notifyListeners();
  }

  Future<void> saveSkillDraft(SkillDraft draft) async {
    await _storage.writeSkillDraftJson(draft.toJsonString());

    await _storage.clearSkillCard();
    await _storage.clearLearningProgress();

    _skillDraft = draft;
    _skillCard = null;
    _learningProgress = null;

    notifyListeners();
  }

  Future<void> clearSkillDraft() async {
    await _storage.clearSkillDraft();
    await _storage.clearSkillCard();
    await _storage.clearLearningProgress();

    _skillDraft = null;
    _skillCard = null;
    _learningProgress = null;

    notifyListeners();
  }

  Future<void> saveSkillCard(SkillCard card) async {
    final SkillDraft? currentDraft = _skillDraft;

    if (currentDraft == null || !card.matchesDraft(currentDraft)) {
      throw StateError('The skill card does not match the current draft.');
    }

    final bool cardChanged =
        _skillCard?.contentFingerprint != card.contentFingerprint;

    if (cardChanged) {
      await _storage.clearLearningProgress();
    }

    await _storage.writeSkillCardJson(card.toJsonString());

    _skillCard = card;

    if (cardChanged) {
      _learningProgress = null;
    }

    notifyListeners();
  }

  Future<void> clearSkillCard() async {
    await _storage.clearSkillCard();
    await _storage.clearLearningProgress();

    _skillCard = null;
    _learningProgress = null;

    notifyListeners();
  }

  Future<void> saveLearningProgress(LearningProgress progress) async {
    final SkillCard? currentCard = _skillCard;

    if (currentCard == null || !progress.matchesCard(currentCard)) {
      throw StateError(
        'The learning progress does not match the current card.',
      );
    }

    await _storage.writeLearningProgressJson(progress.toJsonString());

    _learningProgress = progress;
    notifyListeners();
  }

  Future<void> clearLearningProgress() async {
    await _storage.clearLearningProgress();

    _learningProgress = null;
    notifyListeners();
  }
}
