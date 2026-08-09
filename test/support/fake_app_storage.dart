import 'package:naseej/core/storage/app_storage.dart';

class FakeAppStorage implements AppStorage {
  FakeAppStorage({this.localeCode, this.profileJson});

  String? localeCode;
  String? profileJson;

  @override
  Future<String?> readLocaleCode() async {
    return localeCode;
  }

  @override
  Future<void> writeLocaleCode(String localeCode) async {
    this.localeCode = localeCode;
  }

  @override
  Future<String?> readProfileJson() async {
    return profileJson;
  }

  @override
  Future<void> writeProfileJson(String profileJson) async {
    this.profileJson = profileJson;
  }

  @override
  Future<void> clearProfile() async {
    profileJson = null;
  }
}
