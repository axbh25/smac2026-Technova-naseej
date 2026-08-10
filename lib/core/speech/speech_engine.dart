typedef SpeechWordsCallback = void Function(String words, bool isFinal);

typedef SpeechListeningChangedCallback = void Function(bool isListening);

typedef SpeechErrorCallback = void Function(String errorCode, bool permanent);

class SpeechLocale {
  const SpeechLocale({required this.localeId, required this.name});

  final String localeId;
  final String name;
}

abstract interface class SpeechEngine {
  bool get isListening;

  Future<bool> initialize({
    required SpeechListeningChangedCallback onListeningChanged,
    required SpeechErrorCallback onErrorReceived,
  });

  Future<List<SpeechLocale>> locales();

  Future<void> startListening({
    required SpeechWordsCallback onWords,
    required String? localeId,
  });

  Future<void> stopListening();

  Future<void> cancelListening();
}
