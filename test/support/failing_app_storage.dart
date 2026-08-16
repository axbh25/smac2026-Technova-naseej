import 'package:naseej/core/storage/app_storage.dart';

class FailingAppStorage implements AppStorage {
  FailingAppStorage({
    this.localeCode,
    this.profileJson,
    this.skillDraftJson,
    this.skillCardJson,
    this.learningProgressJson,
    this.failNextOperation,
  });

  String? localeCode;
  String? profileJson;
  String? skillDraftJson;
  String? skillCardJson;
  String? learningProgressJson;

  String? failNextOperation;

  void _maybeFail(String operation) {
    if (failNextOperation != operation) {
      return;
    }

    failNextOperation = null;

    throw StateError('Intentional storage failure: $operation');
  }

  @override
  Future<String?> readLocaleCode() async {
    _maybeFail('readLocaleCode');
    return localeCode;
  }

  @override
  Future<void> writeLocaleCode(String localeCode) async {
    _maybeFail('writeLocaleCode');
    this.localeCode = localeCode;
  }

  @override
  Future<String?> readProfileJson() async {
    _maybeFail('readProfileJson');
    return profileJson;
  }

  @override
  Future<void> writeProfileJson(String profileJson) async {
    _maybeFail('writeProfileJson');
    this.profileJson = profileJson;
  }

  @override
  Future<void> clearProfile() async {
    _maybeFail('clearProfile');
    profileJson = null;
  }

  @override
  Future<String?> readSkillDraftJson() async {
    _maybeFail('readSkillDraftJson');
    return skillDraftJson;
  }

  @override
  Future<void> writeSkillDraftJson(String skillDraftJson) async {
    _maybeFail('writeSkillDraftJson');
    this.skillDraftJson = skillDraftJson;
  }

  @override
  Future<void> clearSkillDraft() async {
    _maybeFail('clearSkillDraft');
    skillDraftJson = null;
  }

  @override
  Future<String?> readSkillCardJson() async {
    _maybeFail('readSkillCardJson');
    return skillCardJson;
  }

  @override
  Future<void> writeSkillCardJson(String skillCardJson) async {
    _maybeFail('writeSkillCardJson');
    this.skillCardJson = skillCardJson;
  }

  @override
  Future<void> clearSkillCard() async {
    _maybeFail('clearSkillCard');
    skillCardJson = null;
  }

  @override
  Future<String?> readLearningProgressJson() async {
    _maybeFail('readLearningProgressJson');

    return learningProgressJson;
  }

  @override
  Future<void> writeLearningProgressJson(String learningProgressJson) async {
    _maybeFail('writeLearningProgressJson');

    this.learningProgressJson = learningProgressJson;
  }

  @override
  Future<void> clearLearningProgress() async {
    _maybeFail('clearLearningProgress');

    learningProgressJson = null;
  }
}
