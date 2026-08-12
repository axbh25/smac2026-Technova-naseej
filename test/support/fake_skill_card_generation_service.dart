import 'package:naseej/core/ai/skill_card_generation_service.dart';

class FakeSkillCardGenerationService implements SkillCardGenerationService {
  FakeSkillCardGenerationService({
    required this.result,
    this.delay = Duration.zero,
  });

  SkillCardGenerationResult result;
  Duration delay;

  int generationCalls = 0;

  final List<SkillCardGenerationRequest> requests =
      <SkillCardGenerationRequest>[];

  @override
  Future<SkillCardGenerationResult> generate(
    SkillCardGenerationRequest request,
  ) async {
    generationCalls += 1;
    requests.add(request);

    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }

    return result;
  }
}
