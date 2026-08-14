import 'package:flutter_test/flutter_test.dart';
import 'package:naseej/features/learning/domain/learning_progress.dart';
import 'package:naseej/features/skill/domain/skill_card.dart';

void main() {
  const SkillCard card = SkillCard(
    title: 'Welcoming Guests',
    steps: <String>[
      'Prepare the items together.',
      'Demonstrate the greeting slowly.',
      'Let the learner repeat the process.',
    ],
    safetyNote: 'Ask an adult for help with hot items.',
    teachBackQuestion: 'Why is welcoming a guest important?',
    reciprocalSkillSuggestion: 'Teach how to send a voice note.',
    outputLanguageCode: 'en',
    origin: SkillCardOrigin.ai,
    sourceDraftFingerprint: '12345678',
    modelName: 'gemini-3.5-flash-lite',
  );

  test('older Day 9 progress JSON remains compatible', () {
    final LearningProgress? progress = LearningProgress.fromJsonString('''
        {
          "skillCardFingerprint": "${card.contentFingerprint}",
          "completedStepIndexes": [0, 1, 2],
          "teachBackResponse": "I learned how to welcome guests calmly.",
          "completedAtIso8601": "2026-08-15T10:00:00.000Z"
        }
        ''');

    expect(progress, isNotNull);
    expect(progress?.isCompleted, isTrue);
    expect(progress?.returnSkillResponse, isEmpty);
    expect(progress?.isExchangeCompleted, isFalse);
  });

  test('completed Family Thread survives JSON round trip', () {
    final LearningProgress original = LearningProgress(
      skillCardFingerprint: card.contentFingerprint,
      completedStepIndexes: const <int>[0, 1, 2],
      teachBackResponse: 'I learned how to welcome guests calmly.',
      completedAtIso8601: '2026-08-15T10:00:00.000Z',
      returnSkillResponse: 'How to send a voice note.',
      exchangeCompletedAtIso8601: '2026-08-15T10:05:00.000Z',
    );

    final LearningProgress? restored = LearningProgress.fromJsonString(
      original.toJsonString(),
    );

    expect(restored, original);
    expect(restored?.isExchangeCompleted, isTrue);
  });

  test('exchange completion requires a valid return skill', () {
    final LearningProgress? progress = LearningProgress.fromJsonString('''
        {
          "skillCardFingerprint": "${card.contentFingerprint}",
          "completedStepIndexes": [0, 1, 2],
          "teachBackResponse": "I learned how to welcome guests calmly.",
          "completedAtIso8601": "2026-08-15T10:00:00.000Z",
          "returnSkillResponse": "",
          "exchangeCompletedAtIso8601": "2026-08-15T10:05:00.000Z"
        }
        ''');

    expect(progress, isNull);
  });

  test('exchange completion requires lesson completion', () {
    final LearningProgress? progress = LearningProgress.fromJsonString('''
        {
          "skillCardFingerprint": "${card.contentFingerprint}",
          "completedStepIndexes": [0, 1],
          "teachBackResponse": "I learned how to welcome guests calmly.",
          "completedAtIso8601": null,
          "returnSkillResponse": "How to send a voice note.",
          "exchangeCompletedAtIso8601": "2026-08-15T10:05:00.000Z"
        }
        ''');

    expect(progress, isNull);
  });

  test('return skill longer than the limit is rejected', () {
    final String longReturnSkill = List<String>.filled(
      LearningProgress.maximumReturnSkillLength + 1,
      'a',
    ).join();

    final LearningProgress? progress = LearningProgress.fromJsonString('''
        {
          "skillCardFingerprint": "${card.contentFingerprint}",
          "completedStepIndexes": [0, 1, 2],
          "teachBackResponse": "I learned how to welcome guests calmly.",
          "completedAtIso8601": "2026-08-15T10:00:00.000Z",
          "returnSkillResponse": "$longReturnSkill",
          "exchangeCompletedAtIso8601": null
        }
        ''');

    expect(progress, isNull);
  });
}
