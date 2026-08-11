enum AiReadinessFailure {
  firebaseNotConfigured,
  offlineOrTimeout,
  appCheckRejected,
  quotaExceeded,
  serviceNotEnabled,
  invalidResponse,
  unknown,
}

class AiReadinessResult {
  const AiReadinessResult._({
    required this.isReady,
    this.modelName,
    this.failure,
  });

  const AiReadinessResult.ready(String modelName)
    : this._(isReady: true, modelName: modelName);

  const AiReadinessResult.failed(AiReadinessFailure failure)
    : this._(isReady: false, failure: failure);

  final bool isReady;
  final String? modelName;
  final AiReadinessFailure? failure;
}

abstract interface class AiReadinessService {
  Future<AiReadinessResult> checkReadiness();
}
