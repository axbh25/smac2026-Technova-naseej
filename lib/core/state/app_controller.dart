import 'package:flutter/widgets.dart';
import 'package:naseej/core/storage/app_storage.dart';
import 'package:naseej/features/profile/domain/family_profile.dart';

class AppController extends ChangeNotifier {
  AppController(this._storage);

  final AppStorage _storage;

  Locale _locale = const Locale('en');
  FamilyProfile? _profile;

  Locale get locale => _locale;

  FamilyProfile? get profile => _profile;

  bool get hasProfile => _profile != null;

  Future<void> initialize() async {
    try {
      final String? storedLocaleCode = await _storage.readLocaleCode();
      final String? storedProfileJson = await _storage.readProfileJson();

      if (storedLocaleCode == 'ar' || storedLocaleCode == 'en') {
        _locale = Locale(storedLocaleCode!);
      }

      _profile = FamilyProfile.fromJsonString(storedProfileJson);
    } catch (_) {
      _locale = const Locale('en');
      _profile = null;
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
      // The current in-memory locale still works when persistence fails.
    }
  }

  Future<void> saveProfile(FamilyProfile profile) async {
    await _storage.writeProfileJson(profile.toJsonString());

    _profile = profile;
    notifyListeners();
  }

  Future<void> clearProfile() async {
    await _storage.clearProfile();

    _profile = null;
    notifyListeners();
  }
}
