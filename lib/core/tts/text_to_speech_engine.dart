enum TextToSpeechPreparationStatus { ready, languageUnavailable }

class TextToSpeechPreparationResult {
  const TextToSpeechPreparationResult.ready(this.resolvedLocale)
    : status = TextToSpeechPreparationStatus.ready;

  const TextToSpeechPreparationResult.languageUnavailable()
    : status = TextToSpeechPreparationStatus.languageUnavailable,
      resolvedLocale = null;

  final TextToSpeechPreparationStatus status;
  final String? resolvedLocale;

  bool get isReady {
    return status == TextToSpeechPreparationStatus.ready &&
        resolvedLocale != null;
  }
}

abstract interface class TextToSpeechEngine {
  Future<TextToSpeechPreparationResult> prepare(String languageCode);

  Future<void> speak(String text);

  Future<void> stop();

  Future<void> dispose();
}
