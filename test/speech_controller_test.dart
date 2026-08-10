import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naseej/core/speech/speech_controller.dart';

import 'support/fake_speech_engine.dart';

void main() {
  test(
    'SpeechController initializes once and selects English locale',
    () async {
      final FakeSpeechEngine engine = FakeSpeechEngine();

      final SpeechController controller = SpeechController(engine);

      addTearDown(controller.dispose);

      String recognizedWords = '';
      bool finalResult = false;

      final bool started = await controller.startListening(
        locale: const Locale('en'),
        onWords: (String words, bool isFinal) {
          recognizedWords = words;
          finalResult = isFinal;
        },
      );

      expect(started, isTrue);
      expect(engine.initializeCalls, 1);
      expect(engine.lastLocaleId, 'en_US');
      expect(controller.isListening, isTrue);

      engine.emitWords('A family skill', isFinal: true);

      expect(recognizedWords, 'A family skill');

      expect(finalResult, isTrue);
      expect(controller.isListening, isFalse);

      await controller.startListening(
        locale: const Locale('en'),
        onWords: (_, _) {},
      );

      expect(engine.initializeCalls, 1);
    },
  );

  test('SpeechController selects Arabic locale', () async {
    final FakeSpeechEngine engine = FakeSpeechEngine();

    final SpeechController controller = SpeechController(engine);

    addTearDown(controller.dispose);

    await controller.startListening(
      locale: const Locale('ar'),
      onWords: (_, _) {},
    );

    expect(engine.lastLocaleId, 'ar_AE');
  });

  test('SpeechController exposes unavailable state', () async {
    final FakeSpeechEngine engine = FakeSpeechEngine(initializeResult: false);

    final SpeechController controller = SpeechController(engine);

    addTearDown(controller.dispose);

    final bool started = await controller.startListening(
      locale: const Locale('en'),
      onWords: (_, _) {},
    );

    expect(started, isFalse);

    expect(controller.initializationAttempted, isTrue);

    expect(controller.isAvailable, isFalse);

    expect(controller.lastErrorCode, 'speech_unavailable');
  });
}
