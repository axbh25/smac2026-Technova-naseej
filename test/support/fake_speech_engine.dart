import 'package:naseej/core/speech/speech_engine.dart';

class FakeSpeechEngine implements SpeechEngine {
  FakeSpeechEngine({
    this.initializeResult = true,
    List<SpeechLocale>? supportedLocales,
  }) : _supportedLocales =
           supportedLocales ??
           const <SpeechLocale>[
             SpeechLocale(localeId: 'en_US', name: 'English'),
             SpeechLocale(localeId: 'ar_AE', name: 'Arabic'),
           ];

  final bool initializeResult;
  final List<SpeechLocale> _supportedLocales;

  SpeechListeningChangedCallback? _onListeningChanged;

  SpeechErrorCallback? _onErrorReceived;
  SpeechWordsCallback? _onWords;

  bool _isListening = false;

  int initializeCalls = 0;
  String? lastLocaleId;

  @override
  bool get isListening => _isListening;

  @override
  Future<bool> initialize({
    required SpeechListeningChangedCallback onListeningChanged,
    required SpeechErrorCallback onErrorReceived,
  }) async {
    initializeCalls += 1;
    _onListeningChanged = onListeningChanged;
    _onErrorReceived = onErrorReceived;

    return initializeResult;
  }

  @override
  Future<List<SpeechLocale>> locales() async {
    return _supportedLocales;
  }

  @override
  Future<void> startListening({
    required SpeechWordsCallback onWords,
    required String? localeId,
  }) async {
    if (!initializeResult) {
      throw StateError('Speech is unavailable.');
    }

    lastLocaleId = localeId;
    _onWords = onWords;

    _isListening = true;
    _onListeningChanged?.call(true);
  }

  @override
  Future<void> stopListening() async {
    _isListening = false;
    _onListeningChanged?.call(false);
  }

  @override
  Future<void> cancelListening() async {
    _isListening = false;
    _onListeningChanged?.call(false);
  }

  void emitWords(String words, {bool isFinal = false}) {
    _onWords?.call(words, isFinal);

    if (isFinal) {
      _isListening = false;
      _onListeningChanged?.call(false);
    }
  }

  void emitError(String errorCode, {bool permanent = false}) {
    _isListening = false;

    _onErrorReceived?.call(errorCode, permanent);

    _onListeningChanged?.call(false);
  }
}
