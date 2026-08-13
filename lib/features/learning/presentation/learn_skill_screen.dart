import 'dart:async';

import 'package:flutter/material.dart';
import 'package:naseej/core/state/app_controller.dart';
import 'package:naseej/core/theme/app_colors.dart';
import 'package:naseej/core/theme/app_spacing.dart';
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

  final List<bool> _completedSteps = List<bool>.filled(
    LearningProgress.stepCount,
    false,
  );

  Timer? _saveTimer;

  bool _initialized = false;
  bool _listenerAdded = false;
  bool _isSaving = false;
  bool _saveFailed = false;
  bool _hasPersistedProgress = false;

  int _revision = 0;
  int _lastSavedRevision = 0;

  String? _completedAtIso8601;

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

  bool get _readyToComplete {
    return _allStepsCompleted && _hasValidTeachBack;
  }

  bool get _isCompleted {
    return _readyToComplete && _completedAtIso8601 != null;
  }

  @override
  void initState() {
    super.initState();

    _teachBackController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

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

      _completedAtIso8601 = existingProgress.completedAtIso8601;

      _hasPersistedProgress = true;
    }

    if (!_listenerAdded) {
      _listenerAdded = true;

      _teachBackController.addListener(_handleTeachBackChanged);
    }
  }

  @override
  void dispose() {
    _saveTimer?.cancel();

    if (_listenerAdded) {
      _teachBackController.removeListener(_handleTeachBackChanged);
    }

    _teachBackController.dispose();

    super.dispose();
  }

  void _handleTeachBackChanged() {
    if (!_initialized) {
      return;
    }

    setState(() {
      _completedAtIso8601 = null;
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

  Future<void> _persistProgress({bool markCompleted = false}) async {
    if (_isSaving) {
      _scheduleAutoSave();
      return;
    }

    if (markCompleted && !_readyToComplete) {
      return;
    }

    if (markCompleted && _completedAtIso8601 == null) {
      _completedAtIso8601 = DateTime.now().toUtc().toIso8601String();

      _revision += 1;
    }

    if (!_readyToComplete) {
      _completedAtIso8601 = null;
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

    await _persistProgress(markCompleted: true);
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
    if (_isCompleted) {
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

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

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
            if (_isCompleted) ...<Widget>[
              const SizedBox(height: AppSpacing.lg),
              _CompletionBanner(
                title: localizations.lessonCompletedTitle,
                body: localizations.lessonCompletedBody,
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
              _LearningStepCard(
                index: index,
                label: localizations.skillCardStepLabel(index + 1),
                text: widget.card.steps[index],
                isCompleted: _completedSteps[index],
                isEnabled: !_isSaving,
                onChanged: (bool value) {
                  _handleStepChanged(index, value);
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
            const SizedBox(height: AppSpacing.lg),
            _InformationCard(
              icon: Icons.swap_horiz_rounded,
              title: localizations.reciprocalSuggestionTitle,
              body: widget.card.reciprocalSkillSuggestion,
              keyValue: 'learning_reciprocal_card',
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton.icon(
                key: const ValueKey<String>('learning_primary_button'),
                onPressed: _isSaving
                    ? null
                    : _isCompleted
                    ? () {
                        Navigator.of(context).pop();
                      }
                    : _readyToComplete
                    ? () async {
                        await _completeLesson();
                      }
                    : null,
                icon: Icon(
                  _isCompleted ? Icons.home_outlined : Icons.verified_outlined,
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

class _LearningStepCard extends StatelessWidget {
  const _LearningStepCard({
    required this.index,
    required this.label,
    required this.text,
    required this.isCompleted,
    required this.isEnabled,
    required this.onChanged,
  });

  final int index;
  final String label;
  final String text;
  final bool isCompleted;
  final bool isEnabled;
  final ValueChanged<bool> onChanged;

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
            constraints: const BoxConstraints(minHeight: 104),
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
