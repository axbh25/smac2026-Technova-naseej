import 'package:flutter_test/flutter_test.dart';
import 'package:naseej/core/ai/ai_readiness_controller.dart';
import 'package:naseej/core/ai/ai_readiness_service.dart';

import 'support/fake_ai_readiness_service.dart';

void main() {
  test('controller reports a successful AI connection', () async {
    final FakeAiReadinessService service = FakeAiReadinessService(
      result: const AiReadinessResult.ready('gemini-2.5-flash-lite'),
    );

    final AiReadinessController controller = AiReadinessController(service);

    addTearDown(controller.dispose);

    expect(controller.status, AiReadinessStatus.idle);

    await controller.checkReadiness();

    expect(controller.status, AiReadinessStatus.ready);

    expect(controller.modelName, 'gemini-2.5-flash-lite');

    expect(controller.failure, isNull);
    expect(service.checkCalls, 1);
  });

  test('controller reports an offline fallback', () async {
    final FakeAiReadinessService service = FakeAiReadinessService(
      result: const AiReadinessResult.failed(
        AiReadinessFailure.offlineOrTimeout,
      ),
    );

    final AiReadinessController controller = AiReadinessController(service);

    addTearDown(controller.dispose);

    await controller.checkReadiness();

    expect(controller.status, AiReadinessStatus.unavailable);

    expect(controller.failure, AiReadinessFailure.offlineOrTimeout);

    expect(controller.modelName, isNull);
  });

  test('controller ignores a second check while checking', () async {
    final FakeAiReadinessService service = FakeAiReadinessService(
      result: const AiReadinessResult.ready('gemini-2.5-flash-lite'),
      delay: const Duration(milliseconds: 100),
    );

    final AiReadinessController controller = AiReadinessController(service);

    addTearDown(controller.dispose);

    final Future<void> firstCheck = controller.checkReadiness();

    final Future<void> secondCheck = controller.checkReadiness();

    await Future.wait<void>(<Future<void>>[firstCheck, secondCheck]);

    expect(service.checkCalls, 1);
  });
}
