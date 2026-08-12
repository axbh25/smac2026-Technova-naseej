import 'package:naseej/core/ai/skill_card_generation_service.dart';

class UnavailableSkillCardGenerationService
    implements SkillCardGenerationService {
  const UnavailableSkillCardGenerationService(this.failure);

  final SkillCardGenerationFailure failure;

  @override
  Future<SkillCardGenerationResult> generate(
    SkillCardGenerationRequest request,
  ) async {
    return SkillCardGenerationResult.failed(failure);
  }
}
