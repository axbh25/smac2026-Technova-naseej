abstract interface class AppStorage {
  Future<String?> readLocaleCode();

  Future<void> writeLocaleCode(String localeCode);

  Future<String?> readProfileJson();

  Future<void> writeProfileJson(String profileJson);

  Future<void> clearProfile();
}
