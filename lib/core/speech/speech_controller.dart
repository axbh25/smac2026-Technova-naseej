import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:naseej/core/speech/speech_engine.dart';

class SpeechController extends ChangeNotifier {
  SpeechController(this._engine);

  final SpeechEngine _engine;

  Future<bool>? _initializationFuture;
  bool _disposed = false;

  bool _initializationAttempted = false;
  bool _available = false;
  bool _isListening = false;

  String? _lastErrorCode;
  bool _lastErrorPermanent = false;
  String? _lastSelectedLocaleId;

  List<SpeechLocale> _locales = const <SpeechLocale>[];

  bool get initializationAttempted => _initializationAttempted;

  bool get isAvailable => _available;

  bool get isListening => _isListening;

  String? get lastErrorCode => _lastErrorCode;

  bool get lastErrorPermanent => _lastErrorPermanent;

  String? get lastSelectedLocaleId => _lastSelectedLocaleId;

  Future<bool> ensureInitialized() {
    return _initializationFuture ??= _initialize();
  }

  Future<bool> _initialize() async {
    _initializationAttempted = true;
    _safeNotifyListeners();

    try {
      _available = await _engine.initialize(
        onListeningChanged: _handleListeningChanged,
        onErrorReceived: _handleError,
      );

      if (_available) {
        _locales = await _engine.locales();
      } else {
        _lastErrorCode ??= 'speech_unavailable';
      }
    } catch (_) {
      _available = false;
      _lastErrorCode = 'speech_initialization_failed';
      _lastErrorPermanent = true;
    }

    _safeNotifyListeners();
    return _available;
  }

  Future<bool> startListening({
    required Locale locale,
    required SpeechWordsCallback onWords,
  }) async {
    final bool available = await ensureInitialized();

    if (!available) {
      _lastErrorCode ??= 'speech_unavailable';
      _safeNotifyListeners();
      return false;
    }

    _lastErrorCode = null;
    _lastErrorPermanent = false;

    final String? localeId = _findBestLocaleId(locale);
    _lastSelectedLocaleId = localeId;

    try {
      await _engine.startListening(onWords: onWords, localeId: localeId);

      _isListening = _engine.isListening;
      _safeNotifyListeners();
      return true;
    } catch (_) {
      _isListening = false;
      _lastErrorCode = 'speech_start_failed';
      _lastErrorPermanent = false;
      _safeNotifyListeners();
      return false;
    }
  }

  Future<void> stopListening() async {
    if (!_available || (!_isListening && !_engine.isListening)) {
      return;
    }

    await _engine.stopListening();
    _isListening = false;
    _safeNotifyListeners();
  }

  Future<void> cancelListening() async {
    if (!_available || (!_isListening && !_engine.isListening)) {
      return;
    }

    await _engine.cancelListening();
    _isListening = false;
    _safeNotifyListeners();
  }

  void clearError() {
    _lastErrorCode = null;
    _lastErrorPermanent = false;
    _safeNotifyListeners();
  }

  void _handleListeningChanged(bool isListening) {
    _isListening = isListening;
    _safeNotifyListeners();
  }

  void _handleError(String errorCode, bool permanent) {
    _isListening = false;
    _lastErrorCode = errorCode;
    _lastErrorPermanent = permanent;
    _safeNotifyListeners();
  }

  String? _findBestLocaleId(Locale locale) {
    final String languageCode = locale.languageCode.toLowerCase();

    final List<String> preferredLocaleIds = languageCode == 'ar'
        ? <String>['ar_AE', 'ar-AE', 'ar_SA', 'ar-SA', 'ar_EG', 'ar-EG']
        : <String>['en_AE', 'en-AE', 'en_US', 'en-US', 'en_GB', 'en-GB'];

    for (final String preferredId in preferredLocaleIds) {
      final String normalizedPreferred = preferredId
          .replaceAll('-', '_')
          .toLowerCase();

      for (final SpeechLocale speechLocale in _locales) {
        final String normalizedAvailable = speechLocale.localeId
            .replaceAll('-', '_')
            .toLowerCase();

        if (normalizedAvailable == normalizedPreferred) {
          return speechLocale.localeId;
        }
      }
    }

    for (final SpeechLocale speechLocale in _locales) {
      final String normalizedAvailable = speechLocale.localeId
          .replaceAll('-', '_')
          .toLowerCase();

      if (normalizedAvailable == languageCode ||
          normalizedAvailable.startsWith('${languageCode}_')) {
        return speechLocale.localeId;
      }
    }

    return null;
  }

  void _safeNotifyListeners() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    unawaited(_engine.cancelListening());
    super.dispose();
  }
}
