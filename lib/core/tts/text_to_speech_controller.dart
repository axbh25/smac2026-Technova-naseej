import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:naseej/core/tts/text_to_speech_engine.dart';

enum TextToSpeechStatus { idle, preparing, speaking, unavailable, failure }

class TextToSpeechController extends ChangeNotifier {
  TextToSpeechController(this._engine);

  final TextToSpeechEngine _engine;

  TextToSpeechStatus _status = TextToSpeechStatus.idle;
  String? _activeItemId;
  String? _lastCompletedItemId;
  String? _resolvedLocale;

  int _operationId = 0;
  bool _isDisposed = false;

  TextToSpeechStatus get status => _status;

  String? get activeItemId => _activeItemId;

  String? get lastCompletedItemId => _lastCompletedItemId;

  String? get resolvedLocale => _resolvedLocale;

  bool get isBusy {
    return _status == TextToSpeechStatus.preparing ||
        _status == TextToSpeechStatus.speaking;
  }

  bool isActive(String itemId) {
    return _activeItemId == itemId;
  }

  Future<void> toggle({
    required String itemId,
    required String text,
    required String languageCode,
  }) async {
    if (isActive(itemId) && isBusy) {
      await stop();
      return;
    }

    await speak(itemId: itemId, text: text, languageCode: languageCode);
  }

  Future<void> speak({
    required String itemId,
    required String text,
    required String languageCode,
  }) async {
    if (_isDisposed) {
      return;
    }

    final String normalizedText = text.trim();

    if (normalizedText.isEmpty) {
      _status = TextToSpeechStatus.failure;
      _activeItemId = null;
      _notify();
      return;
    }

    final int currentOperation = ++_operationId;

    _activeItemId = itemId;
    _status = TextToSpeechStatus.preparing;
    _notify();

    try {
      await _engine.stop();

      if (!_isCurrent(currentOperation)) {
        return;
      }

      final TextToSpeechPreparationResult preparation = await _engine.prepare(
        languageCode,
      );

      if (!_isCurrent(currentOperation)) {
        return;
      }

      if (!preparation.isReady) {
        _resolvedLocale = null;
        _activeItemId = null;
        _status = TextToSpeechStatus.unavailable;
        _notify();
        return;
      }

      _resolvedLocale = preparation.resolvedLocale;
      _status = TextToSpeechStatus.speaking;
      _notify();

      await _engine.speak(normalizedText);

      if (!_isCurrent(currentOperation)) {
        return;
      }

      _lastCompletedItemId = itemId;
      _activeItemId = null;
      _status = TextToSpeechStatus.idle;
      _notify();
    } catch (_) {
      if (!_isCurrent(currentOperation)) {
        return;
      }

      _activeItemId = null;
      _status = TextToSpeechStatus.failure;
      _notify();
    }
  }

  Future<void> stop() async {
    if (_isDisposed) {
      return;
    }

    ++_operationId;

    _activeItemId = null;
    _status = TextToSpeechStatus.idle;
    _notify();

    try {
      await _engine.stop();
    } catch (_) {
      if (_isDisposed) {
        return;
      }

      _status = TextToSpeechStatus.failure;
      _notify();
    }
  }

  bool _isCurrent(int operation) {
    return !_isDisposed && operation == _operationId;
  }

  void _notify() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    if (_isDisposed) {
      return;
    }

    _isDisposed = true;
    ++_operationId;

    unawaited(_engine.dispose());

    super.dispose();
  }
}
