import 'package:naseej/features/profile/domain/family_profile.dart';
import 'package:naseej/features/skill/domain/skill_card.dart';
import 'package:naseej/features/skill/domain/skill_draft.dart';

enum SkillCardGenerationFailure {
  firebaseNotConfigured,
  offlineOrTimeout,
  appCheckRejected,
  quotaExceeded,
  serviceNotEnabled,
  invalidResponse,
  needsClarification,
  unknown,
}

class SkillCardGenerationRequest {
  const SkillCardGenerationRequest({
    required this.teacherRole,
    required this.learnerRole,
    required this.category,
    required this.explanation,
    required this.outputLanguageCode,
    required this.sourceDraftFingerprint,
  });

  factory SkillCardGenerationRequest.fromDraft({
    required SkillDraft draft,
    required String outputLanguageCode,
  }) {
    return SkillCardGenerationRequest(
      teacherRole: draft.teacherRole,
      learnerRole: draft.learnerRole,
      category: draft.category,
      explanation: draft.explanation.trim(),
      outputLanguageCode: outputLanguageCode.toLowerCase() == 'ar'
          ? 'ar'
          : 'en',
      sourceDraftFingerprint: SkillCard.fingerprintForDraft(draft),
    );
  }

  final FamilyRole teacherRole;
  final FamilyRole learnerRole;
  final SkillCategory category;
  final String explanation;
  final String outputLanguageCode;
  final String sourceDraftFingerprint;
}

class SkillCardGenerationResult {
  const SkillCardGenerationResult._({
    required this.isSuccess,
    this.card,
    this.failure,
  });

  const SkillCardGenerationResult.success(SkillCard card)
    : this._(isSuccess: true, card: card);

  const SkillCardGenerationResult.failed(SkillCardGenerationFailure failure)
    : this._(isSuccess: false, failure: failure);

  final bool isSuccess;
  final SkillCard? card;
  final SkillCardGenerationFailure? failure;
}

abstract interface class SkillCardGenerationService {
  Future<SkillCardGenerationResult> generate(
    SkillCardGenerationRequest request,
  );
}
