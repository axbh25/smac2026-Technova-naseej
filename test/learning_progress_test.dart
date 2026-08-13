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
    reciprocalSkillSuggestion: 'Teach one phone feature in return.',
    outputLanguageCode: 'en',
    origin: SkillCardOrigin.ai,
    sourceDraftFingerprint: '12345678',
    modelName: 'gemini-3.5-flash-lite',
  );

  test('LearningProgress survives a JSON round trip', () {
    final LearningProgress original = LearningProgress(
      skillCardFingerprint: card.contentFingerprint,
      completedStepIndexes: const <int>[0, 2],
      teachBackResponse: 'I learned how to welcome a guest calmly.',
    );

    final LearningProgress? restored = LearningProgress.fromJsonString(
      original.toJsonString(),
    );

    expect(restored, original);
  });

  test('completed progress requires all three steps and teach-back', () {
    final LearningProgress? invalid = LearningProgress.fromJsonString('''
        {
          "skillCardFingerprint": "${card.contentFingerprint}",
          "completedStepIndexes": [0, 1],
          "teachBackResponse": "This is long enough.",
          "completedAtIso8601": "2026-08-15T10:00:00.000Z"
        }
        ''');

    expect(invalid, isNull);
  });

  test('progress rejects duplicate step indexes', () {
    final LearningProgress? invalid = LearningProgress.fromJsonString('''
        {
          "skillCardFingerprint": "${card.contentFingerprint}",
          "completedStepIndexes": [0, 0, 1],
          "teachBackResponse": "",
          "completedAtIso8601": null
        }
        ''');

    expect(invalid, isNull);
  });

  test('progress matches only the exact SkillCard content', () {
    final LearningProgress progress = LearningProgress(
      skillCardFingerprint: card.contentFingerprint,
      completedStepIndexes: const <int>[0],
      teachBackResponse: '',
    );

    const SkillCard changedCard = SkillCard(
      title: 'Changed Lesson',
      steps: <String>[
        'Prepare the items together.',
        'Demonstrate the greeting slowly.',
        'Let the learner repeat the process.',
      ],
      safetyNote: 'Ask an adult for help with hot items.',
      teachBackQuestion: 'Why is welcoming a guest important?',
      reciprocalSkillSuggestion: 'Teach one phone feature in return.',
      outputLanguageCode: 'en',
      origin: SkillCardOrigin.ai,
      sourceDraftFingerprint: '12345678',
      modelName: 'gemini-3.5-flash-lite',
    );

    expect(progress.matchesCard(card), isTrue);

    expect(progress.matchesCard(changedCard), isFalse);
  });
}
