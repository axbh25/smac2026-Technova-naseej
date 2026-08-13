import 'package:flutter_tts/flutter_tts.dart';
import 'package:naseej/core/tts/text_to_speech_engine.dart';

class DeviceTextToSpeechEngine implements TextToSpeechEngine {
  DeviceTextToSpeechEngine({FlutterTts? flutterTts})
    : _flutterTts = flutterTts ?? FlutterTts();

  final FlutterTts _flutterTts;

  bool _isDisposed = false;

  @override
  Future<TextToSpeechPreparationResult> prepare(String languageCode) async {
    _ensureAvailable();

    await _flutterTts.awaitSpeakCompletion(true);
    await _flutterTts.setSpeechRate(0.44);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);

    for (final String locale in _candidateLocales(languageCode)) {
      final dynamic available = await _flutterTts.isLanguageAvailable(locale);

      if (!_isSuccessful(available)) {
        continue;
      }

      final dynamic installed = await _flutterTts.isLanguageInstalled(locale);

      if (!_isSuccessful(installed)) {
        continue;
      }

      final dynamic languageResult = await _flutterTts.setLanguage(locale);

      if (!_isSuccessful(languageResult)) {
        continue;
      }

      return TextToSpeechPreparationResult.ready(locale);
    }

    return const TextToSpeechPreparationResult.languageUnavailable();
  }

  @override
  Future<void> speak(String text) async {
    _ensureAvailable();

    final String normalizedText = text.trim();

    if (normalizedText.isEmpty) {
      throw ArgumentError.value(text, 'text', 'Speech text cannot be empty.');
    }

    await _flutterTts.stop();

    final dynamic result = await _flutterTts.speak(normalizedText);

    if (!_isSuccessful(result)) {
      throw StateError('The device did not start text-to-speech.');
    }
  }

  @override
  Future<void> stop() async {
    if (_isDisposed) {
      return;
    }

    await _flutterTts.stop();
  }

  @override
  Future<void> dispose() async {
    if (_isDisposed) {
      return;
    }

    _isDisposed = true;

    await _flutterTts.stop();
  }

  List<String> _candidateLocales(String languageCode) {
    final String normalized = languageCode.trim().toLowerCase();

    if (normalized == 'ar' || normalized.startsWith('ar-')) {
      return const <String>['ar-AE', 'ar-SA', 'ar'];
    }

    return const <String>['en-US', 'en-GB', 'en'];
  }

  bool _isSuccessful(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is num) {
      return value == 1;
    }

    return value?.toString() == '1';
  }

  void _ensureAvailable() {
    if (_isDisposed) {
      throw StateError('The text-to-speech engine has already been disposed.');
    }
  }
}
