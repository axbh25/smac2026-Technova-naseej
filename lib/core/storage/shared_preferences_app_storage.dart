import 'package:naseej/core/storage/app_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesAppStorage implements AppStorage {
  SharedPreferencesAppStorage({SharedPreferencesAsync? preferences})
    : _preferences = preferences ?? SharedPreferencesAsync();

  static const String _localeCodeKey = 'naseej.locale_code';
  static const String _profileJsonKey = 'naseej.active_profile_json';

  final SharedPreferencesAsync _preferences;

  @override
  Future<String?> readLocaleCode() {
    return _preferences.getString(_localeCodeKey);
  }

  @override
  Future<void> writeLocaleCode(String localeCode) {
    return _preferences.setString(_localeCodeKey, localeCode);
  }

  @override
  Future<String?> readProfileJson() {
    return _preferences.getString(_profileJsonKey);
  }

  @override
  Future<void> writeProfileJson(String profileJson) {
    return _preferences.setString(_profileJsonKey, profileJson);
  }

  @override
  Future<void> clearProfile() {
    return _preferences.remove(_profileJsonKey);
  }
}
