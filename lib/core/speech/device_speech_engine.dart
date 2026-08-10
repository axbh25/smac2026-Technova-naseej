import 'package:naseej/core/speech/speech_engine.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class DeviceSpeechEngine implements SpeechEngine {
  final SpeechToText _speechToText = SpeechToText();

  @override
  bool get isListening => _speechToText.isListening;

  @override
  Future<bool> initialize({
    required SpeechListeningChangedCallback onListeningChanged,
    required SpeechErrorCallback onErrorReceived,
  }) {
    return _speechToText.initialize(
      onStatus: (String status) {
        onListeningChanged(status == SpeechToText.listeningStatus);
      },
      onError: (SpeechRecognitionError error) {
        onListeningChanged(false);

        onErrorReceived(error.errorMsg, error.permanent);
      },
      options: <SpeechConfigOption>[SpeechToText.androidNoBluetooth],
    );
  }

  @override
  Future<List<SpeechLocale>> locales() async {
    final List<LocaleName> availableLocales = await _speechToText.locales();

    return availableLocales
        .map((LocaleName locale) {
          return SpeechLocale(localeId: locale.localeId, name: locale.name);
        })
        .toList(growable: false);
  }

  @override
  Future<void> startListening({
    required SpeechWordsCallback onWords,
    required String? localeId,
  }) async {
    await _speechToText.listen(
      onResult: (SpeechRecognitionResult result) {
        onWords(result.recognizedWords, result.finalResult);
      },
      listenOptions: SpeechListenOptions(
        cancelOnError: true,
        partialResults: true,
        onDevice: false,
        listenMode: ListenMode.dictation,
        pauseFor: const Duration(seconds: 3),
        listenFor: const Duration(seconds: 55),
        localeId: localeId,
      ),
    );
  }

  @override
  Future<void> stopListening() {
    return _speechToText.stop();
  }

  @override
  Future<void> cancelListening() {
    return _speechToText.cancel();
  }
}
