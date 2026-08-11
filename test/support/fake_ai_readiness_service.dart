import 'package:naseej/core/ai/ai_readiness_service.dart';

class FakeAiReadinessService implements AiReadinessService {
  FakeAiReadinessService({required this.result, this.delay = Duration.zero});

  AiReadinessResult result;
  Duration delay;

  int checkCalls = 0;

  @override
  Future<AiReadinessResult> checkReadiness() async {
    checkCalls += 1;

    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }

    return result;
  }
}
