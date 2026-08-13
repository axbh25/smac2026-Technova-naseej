import 'package:flutter_test/flutter_test.dart';
import 'package:naseej/core/tts/text_to_speech_controller.dart';
import 'package:naseej/core/tts/text_to_speech_engine.dart';

import 'support/fake_text_to_speech_engine.dart';

void main() {
  test('prepares speaks and records the completed item', () async {
    final FakeTextToSpeechEngine engine = FakeTextToSpeechEngine();

    final TextToSpeechController controller = TextToSpeechController(engine);

    addTearDown(controller.dispose);

    await controller.speak(
      itemId: 'step_0',
      text: 'Prepare the items together.',
      languageCode: 'en',
    );

    expect(engine.preparedLanguageCodes, <String>['en']);
    expect(engine.spokenTexts, <String>['Prepare the items together.']);

    expect(controller.status, TextToSpeechStatus.idle);
    expect(controller.lastCompletedItemId, 'step_0');
    expect(controller.activeItemId, isNull);
  });

  test('reports unavailable when the card language is missing', () async {
    final FakeTextToSpeechEngine engine = FakeTextToSpeechEngine(
      preparationResult:
          const TextToSpeechPreparationResult.languageUnavailable(),
    );

    final TextToSpeechController controller = TextToSpeechController(engine);

    addTearDown(controller.dispose);

    await controller.speak(itemId: 'step_0', text: 'مرحبا', languageCode: 'ar');

    expect(controller.status, TextToSpeechStatus.unavailable);

    expect(engine.spokenTexts, isEmpty);
    expect(controller.activeItemId, isNull);
  });

  test('stop cancels an active utterance', () async {
    final FakeTextToSpeechEngine engine = FakeTextToSpeechEngine(
      holdSpeech: true,
    );

    final TextToSpeechController controller = TextToSpeechController(engine);

    addTearDown(controller.dispose);

    final Future<void> speechFuture = controller.speak(
      itemId: 'step_1',
      text: 'Demonstrate the greeting slowly.',
      languageCode: 'en',
    );

    await Future<void>.delayed(Duration.zero);

    expect(controller.status, TextToSpeechStatus.speaking);

    expect(controller.activeItemId, 'step_1');

    await controller.stop();
    await speechFuture;

    expect(controller.status, TextToSpeechStatus.idle);
    expect(controller.activeItemId, isNull);
    expect(controller.lastCompletedItemId, isNull);
  });

  test('reports a non-blocking failure when speaking throws', () async {
    final FakeTextToSpeechEngine engine = FakeTextToSpeechEngine(
      throwOnSpeak: true,
    );

    final TextToSpeechController controller = TextToSpeechController(engine);

    addTearDown(controller.dispose);

    await controller.speak(
      itemId: 'step_2',
      text: 'Let the learner repeat the process.',
      languageCode: 'en',
    );

    expect(controller.status, TextToSpeechStatus.failure);

    expect(controller.activeItemId, isNull);
  });
}
