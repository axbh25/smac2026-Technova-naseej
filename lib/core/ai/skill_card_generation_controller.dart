import 'package:flutter/foundation.dart';
import 'package:naseej/core/ai/offline_skill_card_factory.dart';
import 'package:naseej/core/ai/skill_card_generation_service.dart';
import 'package:naseej/features/skill/domain/skill_card.dart';
import 'package:naseej/features/skill/domain/skill_draft.dart';

enum SkillCardGenerationStatus { idle, generating, previewReady }

class SkillCardGenerationController extends ChangeNotifier {
  SkillCardGenerationController(this._service, this._offlineFactory);

  final SkillCardGenerationService _service;
  final OfflineSkillCardFactory _offlineFactory;

  SkillCardGenerationStatus _status = SkillCardGenerationStatus.idle;

  SkillCard? _preview;
  SkillCardGenerationFailure? _failure;

  bool _usedOfflineFallback = false;
  bool _previewNeedsSaving = false;

  SkillCardGenerationStatus get status => _status;

  SkillCard? get preview => _preview;

  SkillCardGenerationFailure? get failure => _failure;

  bool get usedOfflineFallback => _usedOfflineFallback;

  bool get previewNeedsSaving => _previewNeedsSaving;

  void loadExisting(SkillCard? card) {
    _preview = card;
    _failure = null;
    _usedOfflineFallback = card?.origin == SkillCardOrigin.offlineGuide;

    _previewNeedsSaving = false;

    _status = card == null
        ? SkillCardGenerationStatus.idle
        : SkillCardGenerationStatus.previewReady;

    notifyListeners();
  }

  Future<void> generateWithAi({
    required SkillDraft draft,
    required String outputLanguageCode,
  }) async {
    if (_status == SkillCardGenerationStatus.generating) {
      return;
    }

    _status = SkillCardGenerationStatus.generating;

    _failure = null;
    _usedOfflineFallback = false;
    _previewNeedsSaving = false;

    notifyListeners();

    final SkillCardGenerationRequest request =
        SkillCardGenerationRequest.fromDraft(
          draft: draft,
          outputLanguageCode: outputLanguageCode,
        );

    SkillCardGenerationResult result;

    try {
      result = await _service.generate(request);
    } catch (_) {
      result = const SkillCardGenerationResult.failed(
        SkillCardGenerationFailure.unknown,
      );
    }

    final SkillCard? generatedCard = result.card;

    if (result.isSuccess && generatedCard != null) {
      _preview = generatedCard;
      _failure = null;
      _usedOfflineFallback = false;
    } else {
      _preview = _offlineFactory.create(
        draft: draft,
        outputLanguageCode: outputLanguageCode,
      );

      _failure = result.failure ?? SkillCardGenerationFailure.unknown;

      _usedOfflineFallback = true;
    }

    _previewNeedsSaving = true;
    _status = SkillCardGenerationStatus.previewReady;

    notifyListeners();
  }

  void useOfflineGuide({
    required SkillDraft draft,
    required String outputLanguageCode,
  }) {
    if (_status == SkillCardGenerationStatus.generating) {
      return;
    }

    _preview = _offlineFactory.create(
      draft: draft,
      outputLanguageCode: outputLanguageCode,
    );

    _failure = null;
    _usedOfflineFallback = false;
    _previewNeedsSaving = true;
    _status = SkillCardGenerationStatus.previewReady;

    notifyListeners();
  }

  void markSaved() {
    _previewNeedsSaving = false;
    notifyListeners();
  }

  void reset() {
    if (_status == SkillCardGenerationStatus.generating) {
      return;
    }

    _status = SkillCardGenerationStatus.idle;
    _preview = null;
    _failure = null;
    _usedOfflineFallback = false;
    _previewNeedsSaving = false;

    notifyListeners();
  }
}
