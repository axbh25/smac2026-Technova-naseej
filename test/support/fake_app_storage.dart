import 'package:naseej/core/storage/app_storage.dart';

class FakeAppStorage implements AppStorage {
  FakeAppStorage({
    this.localeCode,
    this.profileJson,
    this.skillDraftJson,
    this.skillCardJson,
  });

  String? localeCode;
  String? profileJson;
  String? skillDraftJson;
  String? skillCardJson;

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

  @override
  Future<String?> readSkillDraftJson() async {
    return skillDraftJson;
  }

  @override
  Future<void> writeSkillDraftJson(String skillDraftJson) async {
    this.skillDraftJson = skillDraftJson;
  }

  @override
  Future<void> clearSkillDraft() async {
    skillDraftJson = null;
  }

  @override
  Future<String?> readSkillCardJson() async {
    return skillCardJson;
  }

  @override
  Future<void> writeSkillCardJson(String skillCardJson) async {
    this.skillCardJson = skillCardJson;
  }

  @override
  Future<void> clearSkillCard() async {
    skillCardJson = null;
  }
}
