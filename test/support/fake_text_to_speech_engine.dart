import 'dart:async';

import 'package:naseej/core/tts/text_to_speech_engine.dart';

class FakeTextToSpeechEngine implements TextToSpeechEngine {
  FakeTextToSpeechEngine({
    this.preparationResult = const TextToSpeechPreparationResult.ready('en-US'),
    this.holdSpeech = false,
    this.throwOnPrepare = false,
    this.throwOnSpeak = false,
  });

  TextToSpeechPreparationResult preparationResult;

  bool holdSpeech;
  bool throwOnPrepare;
  bool throwOnSpeak;

  final List<String> preparedLanguageCodes = <String>[];
  final List<String> spokenTexts = <String>[];

  int stopCalls = 0;
  bool isDisposed = false;

  Completer<void>? _activeSpeechCompleter;

  @override
  Future<TextToSpeechPreparationResult> prepare(String languageCode) async {
    preparedLanguageCodes.add(languageCode);

    if (throwOnPrepare) {
      throw StateError('Fake preparation failure.');
    }

    return preparationResult;
  }

  @override
  Future<void> speak(String text) async {
    spokenTexts.add(text);

    if (throwOnSpeak) {
      throw StateError('Fake speech failure.');
    }

    if (!holdSpeech) {
      return;
    }

    _activeSpeechCompleter = Completer<void>();

    await _activeSpeechCompleter!.future;
  }

  @override
  Future<void> stop() async {
    stopCalls += 1;

    completeSpeech();
  }

  void completeSpeech() {
    final Completer<void>? completer = _activeSpeechCompleter;

    if (completer != null && !completer.isCompleted) {
      completer.complete();
    }

    _activeSpeechCompleter = null;
  }

  @override
  Future<void> dispose() async {
    if (isDisposed) {
      return;
    }

    isDisposed = true;

    completeSpeech();
  }
}
