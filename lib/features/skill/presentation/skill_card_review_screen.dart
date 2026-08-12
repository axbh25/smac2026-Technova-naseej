import 'package:flutter/material.dart';
import 'package:naseej/core/ai/skill_card_generation_controller.dart';
import 'package:naseej/core/ai/skill_card_generation_service.dart';
import 'package:naseej/core/state/app_controller.dart';
import 'package:naseej/core/theme/app_colors.dart';
import 'package:naseej/core/theme/app_spacing.dart';
import 'package:naseej/core/widgets/language_toggle_button.dart';
import 'package:naseej/features/skill/domain/skill_card.dart';
import 'package:naseej/features/skill/domain/skill_draft.dart';
import 'package:naseej/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class SkillCardReviewScreen extends StatefulWidget {
  const SkillCardReviewScreen({
    required this.draft,
    this.existingCard,
    super.key,
  });

  final SkillDraft draft;
  final SkillCard? existingCard;

  @override
  State<SkillCardReviewScreen> createState() => _SkillCardReviewScreenState();
}

class _SkillCardReviewScreenState extends State<SkillCardReviewScreen> {
  bool _initialized = false;
  bool _isSaving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initialized) {
      return;
    }

    _initialized = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      context.read<SkillCardGenerationController>().loadExisting(
        widget.existingCard,
      );
    });
  }

  Future<void> _generateWithAi() async {
    await context.read<SkillCardGenerationController>().generateWithAi(
      draft: widget.draft,
      outputLanguageCode: Localizations.localeOf(context).languageCode,
    );
  }

  void _useOfflineGuide() {
    context.read<SkillCardGenerationController>().useOfflineGuide(
      draft: widget.draft,
      outputLanguageCode: Localizations.localeOf(context).languageCode,
    );
  }

  Future<void> _saveCard() async {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final SkillCardGenerationController generationController = context
        .read<SkillCardGenerationController>();

    final SkillCard? card = generationController.preview;

    if (card == null || _isSaving) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await context.read<AppController>().saveSkillCard(card);

      generationController.markSaved();

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(localizations.skillCardSaveError)),
        );
    }
  }

  String _failureMessage(
    SkillCardGenerationFailure? failure,
    AppLocalizations localizations,
  ) {
    return switch (failure) {
      SkillCardGenerationFailure.firebaseNotConfigured =>
        localizations.skillCardFirebaseError,
      SkillCardGenerationFailure.offlineOrTimeout =>
        localizations.skillCardOfflineError,
      SkillCardGenerationFailure.appCheckRejected =>
        localizations.skillCardAppCheckError,
      SkillCardGenerationFailure.quotaExceeded =>
        localizations.skillCardQuotaError,
      SkillCardGenerationFailure.serviceNotEnabled =>
        localizations.skillCardServiceError,
      SkillCardGenerationFailure.invalidResponse =>
        localizations.skillCardInvalidResponseError,
      SkillCardGenerationFailure.needsClarification =>
        localizations.skillCardClarificationError,
      SkillCardGenerationFailure.unknown ||
      null => localizations.skillCardGenericError,
    };
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final SkillCardGenerationController controller = context
        .watch<SkillCardGenerationController>();

    return Scaffold(
      key: const ValueKey<String>('skill_card_review_screen'),
      appBar: AppBar(
        title: Text(localizations.skillCardScreenTitle),
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
            _DataBoundaryCard(
              title: localizations.aiDataBoundaryTitle,
              sentTitle: localizations.aiDataSentTitle,
              sentBody: localizations.aiDataSentBody,
              notSentTitle: localizations.aiDataNotSentTitle,
              notSentBody: localizations.aiDataNotSentBody,
            ),
            const SizedBox(height: AppSpacing.lg),
            switch (controller.status) {
              SkillCardGenerationStatus.idle => _GenerationChoice(
                title: localizations.skillCardChoiceTitle,
                body: localizations.skillCardChoiceBody,
                generateLabel: localizations.generateWithAiLabel,
                offlineLabel: localizations.useOfflineGuideLabel,
                onGenerate: () async {
                  await _generateWithAi();
                },
                onOffline: _useOfflineGuide,
              ),
              SkillCardGenerationStatus.generating => _GeneratingCard(
                title: localizations.skillCardGeneratingTitle,
                body: localizations.skillCardGeneratingBody,
              ),
              SkillCardGenerationStatus.previewReady => _SkillCardPreview(
                card: controller.preview!,
                usedFallback: controller.usedOfflineFallback,
                fallbackMessage: controller.usedOfflineFallback
                    ? _failureMessage(controller.failure, localizations)
                    : null,
                aiOriginLabel: localizations.skillCardAiOrigin,
                offlineOriginLabel: localizations.skillCardOfflineOrigin,
                modelLabelBuilder: (String model) {
                  return localizations.skillCardModelLabel(model);
                },
                stepLabelBuilder: (int number) {
                  return localizations.skillCardStepLabel(number);
                },
                safetyTitle: localizations.safetyNoteTitle,
                teachBackTitle: localizations.teachBackQuestionTitle,
                reciprocalTitle: localizations.reciprocalSuggestionTitle,
                saveLabel: _isSaving
                    ? localizations.savingSkillCardLabel
                    : localizations.saveSkillCardLabel,
                backLabel: localizations.backToHomeLabel,
                regenerateLabel: localizations.regenerateWithAiLabel,
                offlineLabel: localizations.useOfflineGuideLabel,
                needsSaving: controller.previewNeedsSaving,
                isSaving: _isSaving,
                onSave: () async {
                  await _saveCard();
                },
                onBack: () {
                  Navigator.of(context).pop();
                },
                onRegenerate: () async {
                  await _generateWithAi();
                },
                onOffline: _useOfflineGuide,
              ),
            },
          ],
        ),
      ),
    );
  }
}

class _DataBoundaryCard extends StatelessWidget {
  const _DataBoundaryCard({
    required this.title,
    required this.sentTitle,
    required this.sentBody,
    required this.notSentTitle,
    required this.notSentBody,
  });

  final String title;
  final String sentTitle;
  final String sentBody;
  final String notSentTitle;
  final String notSentBody;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey<String>('skill_card_data_boundary'),
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
            children: <Widget>[
              const Icon(Icons.shield_outlined, color: AppColors.primary),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(sentTitle, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xxs),
          Text(sentBody, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: AppSpacing.md),
          Text(notSentTitle, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xxs),
          Text(notSentBody, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _GenerationChoice extends StatelessWidget {
  const _GenerationChoice({
    required this.title,
    required this.body,
    required this.generateLabel,
    required this.offlineLabel,
    required this.onGenerate,
    required this.onOffline,
  });

  final String title;
  final String body;
  final String generateLabel;
  final String offlineLabel;
  final Future<void> Function() onGenerate;
  final VoidCallback onOffline;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: <Widget>[
          const Icon(
            Icons.auto_awesome_rounded,
            color: AppColors.primary,
            size: 56,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            body,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton.icon(
              key: const ValueKey<String>('generate_skill_card_button'),
              onPressed: () async {
                await onGenerate();
              },
              icon: const Icon(Icons.auto_awesome_rounded),
              label: Text(generateLabel),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: OutlinedButton.icon(
              key: const ValueKey<String>('offline_skill_card_button'),
              onPressed: onOffline,
              icon: const Icon(Icons.offline_bolt_outlined),
              label: Text(offlineLabel),
            ),
          ),
        ],
      ),
    );
  }
}

class _GeneratingCard extends StatelessWidget {
  const _GeneratingCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey<String>('skill_card_generating'),
      constraints: const BoxConstraints(minHeight: 240),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const CircularProgressIndicator(),
          const SizedBox(height: AppSpacing.lg),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
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

class _SkillCardPreview extends StatelessWidget {
  const _SkillCardPreview({
    required this.card,
    required this.usedFallback,
    required this.fallbackMessage,
    required this.aiOriginLabel,
    required this.offlineOriginLabel,
    required this.modelLabelBuilder,
    required this.stepLabelBuilder,
    required this.safetyTitle,
    required this.teachBackTitle,
    required this.reciprocalTitle,
    required this.saveLabel,
    required this.backLabel,
    required this.regenerateLabel,
    required this.offlineLabel,
    required this.needsSaving,
    required this.isSaving,
    required this.onSave,
    required this.onBack,
    required this.onRegenerate,
    required this.onOffline,
  });

  final SkillCard card;
  final bool usedFallback;
  final String? fallbackMessage;
  final String aiOriginLabel;
  final String offlineOriginLabel;
  final String Function(String) modelLabelBuilder;
  final String Function(int) stepLabelBuilder;
  final String safetyTitle;
  final String teachBackTitle;
  final String reciprocalTitle;
  final String saveLabel;
  final String backLabel;
  final String regenerateLabel;
  final String offlineLabel;
  final bool needsSaving;
  final bool isSaving;
  final Future<void> Function() onSave;
  final VoidCallback onBack;
  final Future<void> Function() onRegenerate;
  final VoidCallback onOffline;

  @override
  Widget build(BuildContext context) {
    final bool isAi = card.origin == SkillCardOrigin.ai;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (usedFallback && fallbackMessage != null) ...<Widget>[
          Container(
            key: const ValueKey<String>('skill_card_fallback_notice'),
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surfaceSoft,
              border: Border.all(color: AppColors.accent),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              fallbackMessage!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        Container(
          key: const ValueKey<String>('skill_card_preview'),
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(
              color: isAi ? AppColors.primary : AppColors.accent,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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
                  isAi ? aiOriginLabel : offlineOriginLabel,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (isAi && card.modelName != null) ...<Widget>[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  modelLabelBuilder(card.modelName!),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              Text(
                card.title,
                key: const ValueKey<String>('skill_card_title'),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.lg),
              for (
                int index = 0;
                index < card.steps.length;
                index += 1
              ) ...<Widget>[
                _StepCard(
                  number: index + 1,
                  label: stepLabelBuilder(index + 1),
                  text: card.steps[index],
                ),
                if (index < card.steps.length - 1)
                  const SizedBox(height: AppSpacing.sm),
              ],
              const SizedBox(height: AppSpacing.lg),
              _InformationCard(
                icon: Icons.health_and_safety_outlined,
                title: safetyTitle,
                body: card.safetyNote,
              ),
              const SizedBox(height: AppSpacing.sm),
              _InformationCard(
                icon: Icons.question_answer_outlined,
                title: teachBackTitle,
                body: card.teachBackQuestion,
              ),
              const SizedBox(height: AppSpacing.sm),
              _InformationCard(
                icon: Icons.swap_horiz_rounded,
                title: reciprocalTitle,
                body: card.reciprocalSkillSuggestion,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: FilledButton(
            key: ValueKey<String>(
              needsSaving ? 'save_skill_card_button' : 'back_home_button',
            ),
            onPressed: isSaving
                ? null
                : needsSaving
                ? () async {
                    await onSave();
                  }
                : onBack,
            child: Text(needsSaving ? saveLabel : backLabel),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton.icon(
            key: const ValueKey<String>('regenerate_skill_card_button'),
            onPressed: isSaving
                ? null
                : () async {
                    await onRegenerate();
                  },
            icon: const Icon(Icons.refresh_rounded),
            label: Text(regenerateLabel),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            key: const ValueKey<String>('replace_offline_card_button'),
            onPressed: isSaving ? null : onOffline,
            icon: const Icon(Icons.offline_bolt_outlined),
            label: Text(offlineLabel),
          ),
        ),
      ],
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.number,
    required this.label,
    required this.text,
  });

  final int number;
  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey<String>('skill_card_step_$number'),
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 96),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            child: Text('$number'),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(label, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSpacing.xxs),
                Text(text, style: Theme.of(context).textTheme.bodyMedium),
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
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
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
