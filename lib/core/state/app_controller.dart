import 'package:flutter/widgets.dart';
import 'package:naseej/core/storage/app_storage.dart';
import 'package:naseej/features/profile/domain/family_profile.dart';
import 'package:naseej/features/skill/domain/skill_draft.dart';

class AppController extends ChangeNotifier {
  AppController(this._storage);

  final AppStorage _storage;

  Locale _locale = const Locale('en');
  FamilyProfile? _profile;
  SkillDraft? _skillDraft;

  Locale get locale => _locale;

  FamilyProfile? get profile => _profile;

  SkillDraft? get skillDraft => _skillDraft;

  bool get hasProfile => _profile != null;

  bool get hasSkillDraft => _skillDraft != null;

  Future<void> initialize() async {
    try {
      final String? storedLocaleCode = await _storage.readLocaleCode();
      final String? storedProfileJson = await _storage.readProfileJson();
      final String? storedSkillDraftJson = await _storage.readSkillDraftJson();

      if (storedLocaleCode == 'ar' || storedLocaleCode == 'en') {
        _locale = Locale(storedLocaleCode!);
      }

      final FamilyProfile? restoredProfile = FamilyProfile.fromJsonString(
        storedProfileJson,
      );
      final SkillDraft? restoredDraft = SkillDraft.fromJsonString(
        storedSkillDraftJson,
      );

      _profile = restoredProfile;

      if (restoredProfile != null &&
          restoredDraft != null &&
          restoredDraft.teacherNickname == restoredProfile.nickname &&
          restoredDraft.teacherRole == restoredProfile.role) {
        _skillDraft = restoredDraft;
      } else {
        _skillDraft = null;
      }
    } catch (_) {
      _locale = const Locale('en');
      _profile = null;
      _skillDraft = null;
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

    _profile = profile;
    _skillDraft = null;
    notifyListeners();
  }

  Future<void> clearProfile() async {
    await _storage.clearProfile();
    await _storage.clearSkillDraft();

    _profile = null;
    _skillDraft = null;
    notifyListeners();
  }

  Future<void> saveSkillDraft(SkillDraft draft) async {
    await _storage.writeSkillDraftJson(draft.toJsonString());

    _skillDraft = draft;
    notifyListeners();
  }

  Future<void> clearSkillDraft() async {
    await _storage.clearSkillDraft();

    _skillDraft = null;
    notifyListeners();
  }
}
