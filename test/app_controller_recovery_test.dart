import 'package:flutter_test/flutter_test.dart';
import 'package:naseej/core/state/app_controller.dart';
import 'package:naseej/features/demo/domain/demo_journey.dart';
import 'package:naseej/features/profile/domain/family_profile.dart';
import 'package:naseej/features/skill/domain/skill_draft.dart';

import 'support/failing_app_storage.dart';
import 'support/fake_app_storage.dart';

void main() {
  test('invalid profile clears its dependent local chain', () async {
    final FakeAppStorage storage = FakeAppStorage(
      localeCode: 'en',
      profileJson: 'not-json',
      skillDraftJson: 'not-json',
      skillCardJson: 'not-json',
      learningProgressJson: 'not-json',
    );

    final AppController controller = AppController(storage);

    addTearDown(controller.dispose);

    await controller.initialize();

    expect(controller.profile, isNull);
    expect(controller.skillDraft, isNull);
    expect(controller.skillCard, isNull);

    expect(controller.learningProgress, isNull);

    expect(controller.recoveryNotice, AppRecoveryNotice.repairedInvalidData);

    expect(storage.profileJson, isNull);
    expect(storage.skillDraftJson, isNull);
    expect(storage.skillCardJson, isNull);

    expect(storage.learningProgressJson, isNull);
  });

  test('invalid card preserves a valid profile and draft', () async {
    const FamilyProfile profile = FamilyProfile(
      nickname: 'Fatima',
      role: FamilyRole.grandparent,
    );

    const SkillDraft draft = SkillDraft(
      teacherNickname: 'Fatima',
      teacherRole: FamilyRole.grandparent,
      learnerNickname: 'Mariam',
      learnerRole: FamilyRole.teen,
      category: SkillCategory.heritage,
      explanation:
          'Explain how our family welcomes guests with patience and care.',
    );

    final FakeAppStorage storage = FakeAppStorage(
      localeCode: 'en',
      profileJson: profile.toJsonString(),
      skillDraftJson: draft.toJsonString(),
      skillCardJson: 'not-json',
      learningProgressJson: 'not-json',
    );

    final AppController controller = AppController(storage);

    addTearDown(controller.dispose);

    await controller.initialize();

    expect(controller.profile, profile);
    expect(controller.skillDraft, draft);
    expect(controller.skillCard, isNull);

    expect(controller.learningProgress, isNull);

    expect(controller.recoveryNotice, AppRecoveryNotice.repairedInvalidData);

    expect(storage.profileJson, isNotNull);
    expect(storage.skillDraftJson, isNotNull);

    expect(storage.skillCardJson, isNull);

    expect(storage.learningProgressJson, isNull);
  });

  test('completed demo journey persists and reset preserves locale', () async {
    final FakeAppStorage storage = FakeAppStorage(localeCode: 'ar');

    final AppController controller = AppController(storage);

    addTearDown(controller.dispose);

    await controller.initialize();

    await controller.loadDemoJourney(DemoJourneyFactory.completedOffline('ar'));

    expect(controller.profile, isNotNull);
    expect(controller.skillDraft, isNotNull);
    expect(controller.skillCard, isNotNull);

    expect(controller.learningProgress?.isExchangeCompleted, isTrue);

    await controller.resetFamilyData();

    expect(controller.profile, isNull);
    expect(controller.skillDraft, isNull);
    expect(controller.skillCard, isNull);

    expect(controller.learningProgress, isNull);

    expect(controller.locale.languageCode, 'ar');

    expect(storage.localeCode, 'ar');
  });

  test(
    'failed demo write restores previous in-memory and stored state',
    () async {
      const FamilyProfile oldProfile = FamilyProfile(
        nickname: 'Aisha',
        role: FamilyRole.parent,
      );

      final FailingAppStorage storage = FailingAppStorage(
        localeCode: 'en',
        profileJson: oldProfile.toJsonString(),
      );

      final AppController controller = AppController(storage);

      addTearDown(controller.dispose);

      await controller.initialize();

      storage.failNextOperation = 'writeSkillCardJson';

      await expectLater(
        controller.loadDemoJourney(DemoJourneyFactory.completedOffline('en')),
        throwsStateError,
      );

      expect(controller.profile, oldProfile);
      expect(controller.skillDraft, isNull);
      expect(controller.skillCard, isNull);

      expect(controller.learningProgress, isNull);

      expect(controller.recoveryNotice, AppRecoveryNotice.storageUnavailable);

      expect(FamilyProfile.fromJsonString(storage.profileJson), oldProfile);

      expect(storage.skillDraftJson, isNull);
      expect(storage.skillCardJson, isNull);

      expect(storage.learningProgressJson, isNull);
    },
  );

  test(
    'read failure produces storage-unavailable notice without crashing',
    () async {
      final FailingAppStorage storage = FailingAppStorage(
        failNextOperation: 'readProfileJson',
      );

      final AppController controller = AppController(storage);

      addTearDown(controller.dispose);

      await controller.initialize();

      expect(controller.profile, isNull);

      expect(controller.recoveryNotice, AppRecoveryNotice.storageUnavailable);
    },
  );
}
