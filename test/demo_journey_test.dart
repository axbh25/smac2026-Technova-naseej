import 'package:flutter_test/flutter_test.dart';
import 'package:naseej/features/demo/domain/demo_journey.dart';
import 'package:naseej/features/skill/domain/skill_card.dart';

void main() {
  test('AI-ready sample contains no generated result', () {
    final DemoJourney journey = DemoJourneyFactory.aiReady('en');

    expect(journey.profile.nickname, 'Fatima');

    expect(journey.draft.teacherNickname, journey.profile.nickname);

    expect(journey.card, isNull);
    expect(journey.progress, isNull);
    expect(journey.draft.contextPhotoPath, isNull);
  });

  test('completed English sample is a valid Offline Guide journey', () {
    final DemoJourney journey = DemoJourneyFactory.completedOffline('en');

    expect(journey.card, isNotNull);
    expect(journey.card?.origin, SkillCardOrigin.offlineGuide);

    expect(journey.card?.modelName, isNull);

    expect(journey.card?.matchesDraft(journey.draft), isTrue);

    expect(journey.progress?.matchesCard(journey.card!), isTrue);

    expect(journey.progress?.isExchangeCompleted, isTrue);
  });

  test('completed Arabic sample contains Arabic local content', () {
    final DemoJourney journey = DemoJourneyFactory.completedOffline('ar');

    expect(journey.card?.outputLanguageCode, 'ar');

    expect(journey.profile.nickname, 'فاطمة');

    expect(journey.progress?.isExchangeCompleted, isTrue);
  });
}
