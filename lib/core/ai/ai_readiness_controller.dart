import 'package:flutter/foundation.dart';
import 'package:naseej/core/ai/ai_readiness_service.dart';

enum AiReadinessStatus { idle, checking, ready, unavailable }

class AiReadinessController extends ChangeNotifier {
  AiReadinessController(this._service);

  final AiReadinessService _service;

  AiReadinessStatus _status = AiReadinessStatus.idle;

  AiReadinessFailure? _failure;
  String? _modelName;

  AiReadinessStatus get status => _status;

  AiReadinessFailure? get failure => _failure;

  String? get modelName => _modelName;

  Future<void> checkReadiness() async {
    if (_status == AiReadinessStatus.checking) {
      return;
    }

    _status = AiReadinessStatus.checking;
    _failure = null;
    _modelName = null;
    notifyListeners();

    try {
      final AiReadinessResult result = await _service.checkReadiness();

      if (result.isReady) {
        _status = AiReadinessStatus.ready;
        _modelName = result.modelName;
        _failure = null;
      } else {
        _status = AiReadinessStatus.unavailable;

        _modelName = null;

        _failure = result.failure ?? AiReadinessFailure.unknown;
      }
    } catch (_) {
      _status = AiReadinessStatus.unavailable;

      _modelName = null;
      _failure = AiReadinessFailure.unknown;
    }

    notifyListeners();
  }

  void reset() {
    if (_status == AiReadinessStatus.checking) {
      return;
    }

    _status = AiReadinessStatus.idle;
    _failure = null;
    _modelName = null;
    notifyListeners();
  }
}
