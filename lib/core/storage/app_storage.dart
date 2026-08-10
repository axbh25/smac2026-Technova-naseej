abstract interface class AppStorage {
  Future<String?> readLocaleCode();

  Future<void> writeLocaleCode(String localeCode);

  Future<String?> readProfileJson();

  Future<void> writeProfileJson(String profileJson);

  Future<void> clearProfile();

  Future<String?> readSkillDraftJson();

  Future<void> writeSkillDraftJson(String skillDraftJson);

  Future<void> clearSkillDraft();
}
