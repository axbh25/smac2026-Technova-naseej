import 'package:naseej/core/ai/ai_readiness_service.dart';

class UnavailableAiReadinessService implements AiReadinessService {
  const UnavailableAiReadinessService(this.failure);

  final AiReadinessFailure failure;

  @override
  Future<AiReadinessResult> checkReadiness() async {
    return AiReadinessResult.failed(failure);
  }
}
