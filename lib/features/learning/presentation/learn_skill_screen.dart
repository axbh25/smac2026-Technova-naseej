import 'dart:async';

import 'package:flutter/material.dart';
import 'package:naseej/core/state/app_controller.dart';
import 'package:naseej/core/theme/app_colors.dart';
import 'package:naseej/core/theme/app_spacing.dart';
import 'package:naseej/core/tts/text_to_speech_controller.dart';
import 'package:naseej/core/widgets/language_toggle_button.dart';
import 'package:naseej/features/learning/domain/learning_progress.dart';
import 'package:naseej/features/skill/domain/skill_card.dart';
import 'package:naseej/features/skill/domain/skill_draft.dart';
import 'package:naseej/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class LearnSkillScreen extends StatefulWidget {
  const LearnSkillScreen({required this.card, required this.draft, super.key});

  final SkillCard card;
  final SkillDraft draft;

  @override
  State<LearnSkillScreen> createState() => _LearnSkillScreenState();
}

class _LearnSkillScreenState extends State<LearnSkillScreen> {
  late final TextEditingController _teachBackController;

  late final TextEditingController _returnSkillController;

  final List<bool> _completedSteps = List<bool>.filled(
    LearningProgress.stepCount,
    false,
  );

  Timer? _saveTimer;
  TextToSpeechController? _textToSpeechController;

  bool _initialized = false;
  bool _listenersAdded = false;
  bool _isSaving = false;
  bool _saveFailed = false;
  bool _hasPersistedProgress = false;

  int _revision = 0;
  int _lastSavedRevision = 0;

  String? _completedAtIso8601;
  String? _exchangeCompletedAtIso8601;

  int get _completedCount {
    return _completedSteps.where((bool value) => value).length;
  }

  bool get _allStepsCompleted {
    return _completedCount == LearningProgress.stepCount;
  }

  bool get _hasValidTeachBack {
    final int length = _teachBackController.text.trim().length;

    return length >= LearningProgress.minimumTeachBackLength &&
        length <= LearningProgress.maximumTeachBackLength;
  }

  bool get _hasValidReturnSkill {
    final int length = _returnSkillController.text.trim().length;

    return length >= LearningProgress.minimumReturnSkillLength &&
        length <= LearningProgress.maximumReturnSkillLength;
  }

  bool get _readyToCompleteLesson {
    return _allStepsCompleted && _hasValidTeachBack;
  }

  bool get _isLessonCompleted {
    return _readyToCompleteLesson && _completedAtIso8601 != null;
  }

  bool get _readyToCompleteExchange {
    return _isLessonCompleted && _hasValidReturnSkill;
  }

  bool get _isExchangeCompleted {
    return _readyToCompleteExchange && _exchangeCompletedAtIso8601 != null;
  }

  @override
  void initState() {
    super.initState();

    _teachBackController = TextEditingController();

    _returnSkillController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _textToSpeechController ??= context.read<TextToSpeechController>();

    if (_initialized) {
      return;
    }

    _initialized = true;

    final LearningProgress? existingProgress = context
        .read<AppController>()
        .learningProgress;

    if (existingProgress != null && existingProgress.matchesCard(widget.card)) {
      for (int index = 0; index < _completedSteps.length; index += 1) {
        _completedSteps[index] = existingProgress.isStepCompleted(index);
      }

      _teachBackController.text = existingProgress.teachBackResponse;

      _returnSkillController.text = existingProgress.returnSkillResponse;

      _completedAtIso8601 = existingProgress.completedAtIso8601;

      _exchangeCompletedAtIso8601 = existingProgress.exchangeCompletedAtIso8601;

      _hasPersistedProgress = true;
    }

    if (!_listenersAdded) {
      _listenersAdded = true;

      _teachBackController.addListener(_handleTeachBackChanged);

      _returnSkillController.addListener(_handleReturnSkillChanged);
    }
  }

  @override
  void dispose() {
    _saveTimer?.cancel();

    if (_listenersAdded) {
      _teachBackController.removeListener(_handleTeachBackChanged);

      _returnSkillController.removeListener(_handleReturnSkillChanged);
    }

    _teachBackController.dispose();
    _returnSkillController.dispose();

    final TextToSpeechController? controller = _textToSpeechController;

    if (controller != null) {
      unawaited(controller.stop());
    }

    super.dispose();
  }

  void _handleTeachBackChanged() {
    if (!_initialized) {
      return;
    }

    setState(() {
      _completedAtIso8601 = null;
      _exchangeCompletedAtIso8601 = null;
      _revision += 1;
      _saveFailed = false;
    });

    _scheduleAutoSave();
  }

  void _handleReturnSkillChanged() {
    if (!_initialized) {
      return;
    }

    setState(() {
      _exchangeCompletedAtIso8601 = null;
      _revision += 1;
      _saveFailed = false;
    });

    _scheduleAutoSave();
  }

  void _handleStepChanged(int index, bool value) {
    if (_isSaving) {
      return;
    }

    setState(() {
      _completedSteps[index] = value;
      _completedAtIso8601 = null;
      _exchangeCompletedAtIso8601 = null;
      _revision += 1;
      _saveFailed = false;
    });

    _saveTimer?.cancel();

    unawaited(_persistProgress());
  }

  void _scheduleAutoSave() {
    _saveTimer?.cancel();

    _saveTimer = Timer(const Duration(milliseconds: 600), () {
      if (!mounted) {
        return;
      }

      unawaited(_persistProgress());
    });
  }

  Future<void> _persistProgress({
    bool markLessonCompleted = false,
    bool markExchangeCompleted = false,
  }) async {
    if (_isSaving) {
      _scheduleAutoSave();
      return;
    }

    if (markLessonCompleted && !_readyToCompleteLesson) {
      return;
    }

    if (markExchangeCompleted && !_readyToCompleteExchange) {
      return;
    }

    if (markLessonCompleted && _completedAtIso8601 == null) {
      _completedAtIso8601 = DateTime.now().toUtc().toIso8601String();

      _revision += 1;
    }

    if (!_readyToCompleteLesson) {
      _completedAtIso8601 = null;
      _exchangeCompletedAtIso8601 = null;
    }

    if (_completedAtIso8601 == null || !_hasValidReturnSkill) {
      _exchangeCompletedAtIso8601 = null;
    }

    if (markExchangeCompleted && _exchangeCompletedAtIso8601 == null) {
      _exchangeCompletedAtIso8601 = DateTime.now().toUtc().toIso8601String();

      _revision += 1;
    }

    final List<int> completedIndexes = <int>[];

    for (int index = 0; index < _completedSteps.length; index += 1) {
      if (_completedSteps[index]) {
        completedIndexes.add(index);
      }
    }

    final LearningProgress progress = LearningProgress(
      skillCardFingerprint: widget.card.contentFingerprint,
      completedStepIndexes: completedIndexes,
      teachBackResponse: _teachBackController.text.trim(),
      completedAtIso8601: _completedAtIso8601,
      returnSkillResponse: _returnSkillController.text.trim(),
      exchangeCompletedAtIso8601: _exchangeCompletedAtIso8601,
    );

    final int revisionToSave = _revision;

    setState(() {
      _isSaving = true;
      _saveFailed = false;
    });

    try {
      await context.read<AppController>().saveLearningProgress(progress);

      if (!mounted) {
        return;
      }

      setState(() {
        _isSaving = false;
        _saveFailed = false;
        _hasPersistedProgress = true;
        _lastSavedRevision = revisionToSave;
      });

      if (_revision != revisionToSave) {
        _scheduleAutoSave();
      }
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSaving = false;
        _saveFailed = true;
      });
    }
  }

  Future<void> _completeLesson() async {
    _saveTimer?.cancel();

    FocusManager.instance.primaryFocus?.unfocus();

    await _textToSpeechController?.stop();

    await _persistProgress(markLessonCompleted: true);
  }

  Future<void> _completeFamilyThread() async {
    _saveTimer?.cancel();

    FocusManager.instance.primaryFocus?.unfocus();

    await _textToSpeechController?.stop();

    await _persistProgress(markExchangeCompleted: true);
  }

  void _useReciprocalSuggestion() {
    final String suggestion = widget.card.reciprocalSkillSuggestion;

    _returnSkillController.value = TextEditingValue(
      text: suggestion,
      selection: TextSelection.collapsed(offset: suggestion.length),
    );
  }

  Future<void> _returnHome() async {
    _saveTimer?.cancel();

    if (!_isSaving && _revision != _lastSavedRevision) {
      await _persistProgress();
    }

    await _textToSpeechController?.stop();

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop();
  }

  String _saveStatus(AppLocalizations localizations) {
    if (_isSaving) {
      return localizations.learningSavingLabel;
    }

    if (_saveFailed) {
      return localizations.learningSaveError;
    }

    if (_revision != _lastSavedRevision) {
      return localizations.learningChangesPendingLabel;
    }

    if (_hasPersistedProgress) {
      return localizations.learningSavedLabel;
    }

    return localizations.learningLocalSaveReadyLabel;
  }

  IconData _saveStatusIcon() {
    if (_isSaving) {
      return Icons.sync_rounded;
    }

    if (_saveFailed) {
      return Icons.error_outline_rounded;
    }

    if (_revision != _lastSavedRevision) {
      return Icons.schedule_rounded;
    }

    return Icons.save_outlined;
  }

  Color _saveStatusColor() {
    if (_saveFailed) {
      return AppColors.error;
    }

    if (_hasPersistedProgress &&
        !_isSaving &&
        _revision == _lastSavedRevision) {
      return AppColors.success;
    }

    return AppColors.textSecondary;
  }

  String _primaryButtonLabel(AppLocalizations localizations) {
    if (_isLessonCompleted) {
      return localizations.backToHomeLabel;
    }

    if (!_allStepsCompleted) {
      return localizations.completeAllStepsLabel;
    }

    if (!_hasValidTeachBack) {
      return localizations.writeTeachBackLabel;
    }

    return localizations.completeFamilyLessonLabel;
  }

  String _familyThreadButtonLabel(AppLocalizations localizations) {
    if (_isSaving) {
      return localizations.familyThreadSavingLabel;
    }

    if (_isExchangeCompleted) {
      return localizations.familyThreadCompletedLabel;
    }

    return localizations.completeFamilyThreadLabel;
  }

  String _speechStatusTitle(
    AppLocalizations localizations,
    TextToSpeechController controller,
  ) {
    if (controller.status == TextToSpeechStatus.unavailable ||
        controller.status == TextToSpeechStatus.failure) {
      return localizations.ttsUnavailableTitle;
    }

    return localizations.listenToStepsTitle;
  }

  String _speechStatusBody(
    AppLocalizations localizations,
    TextToSpeechController controller,
  ) {
    switch (controller.status) {
      case TextToSpeechStatus.idle:
        return localizations.listenToStepsBody;

      case TextToSpeechStatus.preparing:
        return localizations.ttsPreparingLabel;

      case TextToSpeechStatus.speaking:
        return localizations.ttsSpeakingLabel;

      case TextToSpeechStatus.unavailable:
        return localizations.ttsLanguageUnavailableBody;

      case TextToSpeechStatus.failure:
        return localizations.ttsPlaybackErrorBody;
    }
  }

  IconData _speechStatusIcon(TextToSpeechController controller) {
    switch (controller.status) {
      case TextToSpeechStatus.idle:
        return Icons.volume_up_outlined;

      case TextToSpeechStatus.preparing:
        return Icons.hourglass_top_rounded;

      case TextToSpeechStatus.speaking:
        return Icons.graphic_eq_rounded;

      case TextToSpeechStatus.unavailable:
        return Icons.volume_off_outlined;

      case TextToSpeechStatus.failure:
        return Icons.error_outline_rounded;
    }
  }

  Color _speechStatusColor(TextToSpeechController controller) {
    if (controller.status == TextToSpeechStatus.unavailable ||
        controller.status == TextToSpeechStatus.failure) {
      return AppColors.error;
    }

    if (controller.status == TextToSpeechStatus.speaking) {
      return AppColors.success;
    }

    return AppColors.primary;
  }

  String _speechButtonLabel({
    required AppLocalizations localizations,
    required TextToSpeechController controller,
    required String itemId,
  }) {
    if (controller.isActive(itemId)) {
      if (controller.status == TextToSpeechStatus.preparing) {
        return localizations.ttsPreparingLabel;
      }

      if (controller.status == TextToSpeechStatus.speaking) {
        return localizations.stopSpeakingLabel;
      }
    }

    if (controller.lastCompletedItemId == itemId) {
      return localizations.replayLabel;
    }

    return localizations.listenLabel;
  }

  IconData _speechButtonIcon({
    required TextToSpeechController controller,
    required String itemId,
  }) {
    if (controller.isActive(itemId)) {
      if (controller.status == TextToSpeechStatus.preparing) {
        return Icons.hourglass_top_rounded;
      }

      if (controller.status == TextToSpeechStatus.speaking) {
        return Icons.stop_circle_outlined;
      }
    }

    if (controller.lastCompletedItemId == itemId) {
      return Icons.replay_rounded;
    }

    return Icons.volume_up_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final TextToSpeechController speechController = context
        .watch<TextToSpeechController>();

    final double progress = _completedCount / LearningProgress.stepCount;

    return Scaffold(
      key: const ValueKey<String>('learn_skill_screen'),
      appBar: AppBar(
        title: Text(localizations.learnSkillScreenTitle),
        actions: const <Widget>[LanguageToggleButton()],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsetsDirectional.fromSTEB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          children: <Widget>[
            _LessonHeaderCard(
              learnerTitle: localizations.learnerLessonTitle(
                widget.draft.learnerNickname,
              ),
              cardTitle: widget.card.title,
              originLabel: widget.card.origin == SkillCardOrigin.ai
                  ? localizations.skillCardAiOrigin
                  : localizations.skillCardOfflineOrigin,
              progressLabel: localizations.learningProgressCount(
                _completedCount,
                LearningProgress.stepCount,
              ),
              progress: progress,
              saveStatus: _saveStatus(localizations),
              saveStatusIcon: _saveStatusIcon(),
              saveStatusColor: _saveStatusColor(),
              localNotice: localizations.learningOfflineNotice,
            ),
            const SizedBox(height: AppSpacing.lg),
            _SpeechSupportCard(
              title: _speechStatusTitle(localizations, speechController),
              body: _speechStatusBody(localizations, speechController),
              notice: localizations.ttsDeviceNotice,
              icon: _speechStatusIcon(speechController),
              statusColor: _speechStatusColor(speechController),
            ),
            if (_isLessonCompleted) ...<Widget>[
              const SizedBox(height: AppSpacing.lg),
              _CompletionBanner(
                title: localizations.lessonCompletedTitle,
                body: localizations.lessonCompletedBody,
              ),
              const SizedBox(height: AppSpacing.lg),
              if (_isExchangeCompleted) ...<Widget>[
                _FamilyThreadCompletionBanner(
                  title: localizations.familyThreadCompletedTitle,
                  body: localizations.familyThreadCompletedBody(
                    widget.draft.teacherNickname,
                    widget.draft.learnerNickname,
                  ),
                  notice: localizations.familyThreadLocalNotice,
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
              _FamilyThreadCard(
                title: localizations.familyThreadTitle,
                body: localizations.familyThreadBody(
                  widget.draft.learnerNickname,
                  widget.draft.teacherNickname,
                ),
                connectionLabel: localizations.familyThreadConnectionLabel(
                  widget.draft.teacherNickname,
                  widget.draft.learnerNickname,
                ),
                taughtTitle: localizations.familyThreadTaughtTitle,
                taughtBody: widget.card.title,
                learnedTitle: localizations.familyThreadLearnedTitle(
                  widget.draft.learnerNickname,
                ),
                learnedBody: _teachBackController.text.trim(),
                suggestionTitle: localizations.familyThreadSuggestionTitle,
                suggestionBody: widget.card.reciprocalSkillSuggestion,
                returnSkillLabel: localizations.familyThreadReturnSkillLabel(
                  widget.draft.learnerNickname,
                ),
                returnSkillHint: localizations.familyThreadReturnSkillHint,
                returnSkillHelper: localizations.familyThreadReturnSkillHelper(
                  LearningProgress.minimumReturnSkillLength,
                ),
                localNotice: localizations.familyThreadLocalNotice,
                useSuggestionLabel: localizations.useNaseejSuggestionLabel,
                completeLabel: _familyThreadButtonLabel(localizations),
                controller: _returnSkillController,
                isSaving: _isSaving,
                isCompleted: _isExchangeCompleted,
                canComplete: _readyToCompleteExchange,
                onUseSuggestion: _useReciprocalSuggestion,
                onComplete: _completeFamilyThread,
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            _InformationCard(
              icon: Icons.health_and_safety_outlined,
              title: localizations.safetyNoteTitle,
              body: widget.card.safetyNote,
              keyValue: 'learning_safety_card',
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              localizations.practiceStepsTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            for (
              int index = 0;
              index < widget.card.steps.length;
              index += 1
            ) ...<Widget>[
              Builder(
                builder: (BuildContext context) {
                  final String speechItemId = 'learning_step_$index';

                  final bool isSpeechActive = speechController.isActive(
                    speechItemId,
                  );

                  final bool speechButtonEnabled =
                      !speechController.isBusy || isSpeechActive;

                  return _LearningStepCard(
                    index: index,
                    label: localizations.skillCardStepLabel(index + 1),
                    text: widget.card.steps[index],
                    isCompleted: _completedSteps[index],
                    isEnabled: !_isSaving,
                    onChanged: (bool value) {
                      _handleStepChanged(index, value);
                    },
                    speechButtonLabel: _speechButtonLabel(
                      localizations: localizations,
                      controller: speechController,
                      itemId: speechItemId,
                    ),
                    speechButtonIcon: _speechButtonIcon(
                      controller: speechController,
                      itemId: speechItemId,
                    ),
                    onSpeechPressed: speechButtonEnabled
                        ? () {
                            unawaited(
                              speechController.toggle(
                                itemId: speechItemId,
                                text: widget.card.steps[index],
                                languageCode: widget.card.outputLanguageCode,
                              ),
                            );
                          }
                        : null,
                  );
                },
              ),
              if (index < widget.card.steps.length - 1)
                const SizedBox(height: AppSpacing.sm),
            ],
            const SizedBox(height: AppSpacing.lg),
            _TeachBackCard(
              questionTitle: localizations.teachBackQuestionTitle,
              question: widget.card.teachBackQuestion,
              responseLabel: localizations.teachBackResponseLabel,
              responseHint: localizations.teachBackResponseHint,
              helper: localizations.teachBackResponseHelper(
                LearningProgress.minimumTeachBackLength,
              ),
              controller: _teachBackController,
            ),
            if (!_isLessonCompleted) ...<Widget>[
              const SizedBox(height: AppSpacing.lg),
              _InformationCard(
                icon: Icons.swap_horiz_rounded,
                title: localizations.reciprocalSuggestionTitle,
                body: widget.card.reciprocalSkillSuggestion,
                keyValue: 'learning_reciprocal_card',
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton.icon(
                key: const ValueKey<String>('learning_primary_button'),
                onPressed: _isSaving
                    ? null
                    : _isLessonCompleted
                    ? _returnHome
                    : _readyToCompleteLesson
                    ? _completeLesson
                    : null,
                icon: Icon(
                  _isLessonCompleted
                      ? Icons.home_outlined
                      : Icons.verified_outlined,
                ),
                label: Text(_primaryButtonLabel(localizations)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LessonHeaderCard extends StatelessWidget {
  const _LessonHeaderCard({
    required this.learnerTitle,
    required this.cardTitle,
    required this.originLabel,
    required this.progressLabel,
    required this.progress,
    required this.saveStatus,
    required this.saveStatusIcon,
    required this.saveStatusColor,
    required this.localNotice,
  });

  final String learnerTitle;
  final String cardTitle;
  final String originLabel;
  final String progressLabel;
  final double progress;
  final String saveStatus;
  final IconData saveStatusIcon;
  final Color saveStatusColor;
  final String localNotice;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey<String>('learning_header_card'),
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(learnerTitle, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(cardTitle, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.xs),
          Container(
            padding: const EdgeInsetsDirectional.fromSTEB(
              AppSpacing.sm,
              AppSpacing.xs,
              AppSpacing.sm,
              AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceSoft,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              originLabel,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(progressLabel, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.xs),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 10,
              value: progress,
              backgroundColor: AppColors.disabled,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: <Widget>[
              Icon(saveStatusIcon, color: saveStatusColor, size: 18),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  saveStatus,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: saveStatusColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: <Widget>[
              const Icon(
                Icons.offline_bolt_outlined,
                color: AppColors.textSecondary,
                size: 18,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  localNotice,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SpeechSupportCard extends StatelessWidget {
  const _SpeechSupportCard({
    required this.title,
    required this.body,
    required this.notice,
    required this.icon,
    required this.statusColor,
  });

  final String title;
  final String body;
  final String notice;
  final IconData icon;
  final Color statusColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey<String>('speech_support_card'),
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: statusColor),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(icon, color: statusColor),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(body, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Icon(
                Icons.smartphone_outlined,
                color: AppColors.textSecondary,
                size: 18,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  notice,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LearningStepCard extends StatelessWidget {
  const _LearningStepCard({
    required this.index,
    required this.label,
    required this.text,
    required this.isCompleted,
    required this.isEnabled,
    required this.onChanged,
    required this.speechButtonLabel,
    required this.speechButtonIcon,
    required this.onSpeechPressed,
  });

  final int index;
  final String label;
  final String text;
  final bool isCompleted;
  final bool isEnabled;
  final ValueChanged<bool> onChanged;
  final String speechButtonLabel;
  final IconData speechButtonIcon;
  final VoidCallback? onSpeechPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      checked: isCompleted,
      button: true,
      child: Material(
        color: isCompleted ? AppColors.surfaceSoft : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          key: ValueKey<String>('learning_step_card_$index'),
          borderRadius: BorderRadius.circular(16),
          onTap: isEnabled
              ? () {
                  onChanged(!isCompleted);
                }
              : null,
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 152),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              border: Border.all(
                color: isCompleted ? AppColors.success : AppColors.border,
                width: isCompleted ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: 48,
                  height: 48,
                  child: Checkbox(
                    key: ValueKey<String>('learning_step_checkbox_$index'),
                    value: isCompleted,
                    onChanged: isEnabled
                        ? (bool? value) {
                            onChanged(value ?? false);
                          }
                        : null,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        label,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(text, style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: AppSpacing.sm),
                      SizedBox(
                        height: 48,
                        child: OutlinedButton.icon(
                          key: ValueKey<String>('learning_step_speak_$index'),
                          onPressed: onSpeechPressed,
                          icon: Icon(speechButtonIcon),
                          label: Text(speechButtonLabel),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TeachBackCard extends StatelessWidget {
  const _TeachBackCard({
    required this.questionTitle,
    required this.question,
    required this.responseLabel,
    required this.responseHint,
    required this.helper,
    required this.controller,
  });

  final String questionTitle;
  final String question;
  final String responseLabel;
  final String responseHint;
  final String helper;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey<String>('teach_back_card'),
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Icon(
                Icons.question_answer_outlined,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      questionTitle,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      question,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(responseLabel, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          TextField(
            key: const ValueKey<String>('teach_back_response_field'),
            controller: controller,
            minLines: 3,
            maxLines: 5,
            maxLength: LearningProgress.maximumTeachBackLength,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: responseHint,
              helperText: helper,
              alignLabelWithHint: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _FamilyThreadCard extends StatelessWidget {
  const _FamilyThreadCard({
    required this.title,
    required this.body,
    required this.connectionLabel,
    required this.taughtTitle,
    required this.taughtBody,
    required this.learnedTitle,
    required this.learnedBody,
    required this.suggestionTitle,
    required this.suggestionBody,
    required this.returnSkillLabel,
    required this.returnSkillHint,
    required this.returnSkillHelper,
    required this.localNotice,
    required this.useSuggestionLabel,
    required this.completeLabel,
    required this.controller,
    required this.isSaving,
    required this.isCompleted,
    required this.canComplete,
    required this.onUseSuggestion,
    required this.onComplete,
  });

  final String title;
  final String body;
  final String connectionLabel;
  final String taughtTitle;
  final String taughtBody;
  final String learnedTitle;
  final String learnedBody;
  final String suggestionTitle;
  final String suggestionBody;
  final String returnSkillLabel;
  final String returnSkillHint;
  final String returnSkillHelper;
  final String localNotice;
  final String useSuggestionLabel;
  final String completeLabel;
  final TextEditingController controller;
  final bool isSaving;
  final bool isCompleted;
  final bool canComplete;
  final VoidCallback onUseSuggestion;
  final Future<void> Function() onComplete;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey<String>('family_thread_card'),
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(
          color: isCompleted ? AppColors.success : AppColors.primary,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Center(child: _FamilyThreadVisual()),
          const SizedBox(height: AppSpacing.md),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.xs),
          Text(
            body,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.surfaceSoft,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              connectionLabel,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _ThreadSummaryItem(
            icon: Icons.menu_book_outlined,
            title: taughtTitle,
            body: taughtBody,
          ),
          const SizedBox(height: AppSpacing.sm),
          _ThreadSummaryItem(
            icon: Icons.record_voice_over_outlined,
            title: learnedTitle,
            body: learnedBody,
          ),
          const SizedBox(height: AppSpacing.sm),
          _ThreadSummaryItem(
            icon: Icons.swap_horiz_rounded,
            title: suggestionTitle,
            body: suggestionBody,
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              key: const ValueKey<String>('use_return_suggestion_button'),
              onPressed: isSaving ? null : onUseSuggestion,
              icon: const Icon(Icons.auto_awesome_outlined),
              label: Text(useSuggestionLabel),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            returnSkillLabel,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          TextField(
            key: const ValueKey<String>('return_skill_response_field'),
            controller: controller,
            enabled: !isSaving,
            minLines: 2,
            maxLines: 4,
            maxLength: LearningProgress.maximumReturnSkillLength,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: returnSkillHint,
              helperText: returnSkillHelper,
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Icon(
                Icons.lock_outline_rounded,
                color: AppColors.textSecondary,
                size: 18,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  localNotice,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton.icon(
              key: const ValueKey<String>('complete_family_thread_button'),
              onPressed: isSaving || isCompleted || !canComplete
                  ? null
                  : () async {
                      await onComplete();
                    },
              icon: Icon(
                isCompleted ? Icons.verified_rounded : Icons.hub_outlined,
              ),
              label: Text(completeLabel),
            ),
          ),
        ],
      ),
    );
  }
}

class _FamilyThreadVisual extends StatelessWidget {
  const _FamilyThreadVisual();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 144,
      height: 76,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          PositionedDirectional(
            start: 20,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surfaceSoft,
                border: Border.all(color: AppColors.primary, width: 3),
              ),
              child: const Icon(
                Icons.person_outline_rounded,
                color: AppColors.primary,
                size: 30,
              ),
            ),
          ),
          PositionedDirectional(
            end: 20,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surface,
                border: Border.all(color: AppColors.accent, width: 3),
              ),
              child: const Icon(
                Icons.person_rounded,
                color: AppColors.accent,
                size: 30,
              ),
            ),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.background,
            ),
            child: const Icon(
              Icons.swap_horiz_rounded,
              color: AppColors.textPrimary,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}

class _ThreadSummaryItem extends StatelessWidget {
  const _ThreadSummaryItem({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 88),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSpacing.xxs),
                Text(body, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InformationCard extends StatelessWidget {
  const _InformationCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.keyValue,
  });

  final IconData icon;
  final String title;
  final String body;
  final String keyValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey<String>(keyValue),
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSpacing.xxs),
                Text(body, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CompletionBanner extends StatelessWidget {
  const _CompletionBanner({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey<String>('learning_complete_banner'),
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        border: Border.all(color: AppColors.success, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: <Widget>[
          const Icon(
            Icons.verified_rounded,
            color: AppColors.success,
            size: 48,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: AppColors.success),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            body,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _FamilyThreadCompletionBanner extends StatelessWidget {
  const _FamilyThreadCompletionBanner({
    required this.title,
    required this.body,
    required this.notice,
  });

  final String title;
  final String body;
  final String notice;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey<String>('family_thread_complete_banner'),
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.success, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: <Widget>[
          const _FamilyThreadVisual(),
          const SizedBox(height: AppSpacing.sm),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: AppColors.success),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            body,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.lock_outline_rounded,
                color: AppColors.textSecondary,
                size: 18,
              ),
              const SizedBox(width: AppSpacing.xs),
              Flexible(
                child: Text(
                  notice,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
