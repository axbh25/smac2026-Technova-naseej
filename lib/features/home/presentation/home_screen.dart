import 'dart:io';

import 'package:flutter/material.dart';
import 'package:naseej/core/state/app_controller.dart';
import 'package:naseej/core/theme/app_colors.dart';
import 'package:naseej/core/theme/app_spacing.dart';
import 'package:naseej/core/widgets/language_toggle_button.dart';
import 'package:naseej/features/home/presentation/widgets/ai_readiness_card.dart';
import 'package:naseej/features/learning/domain/learning_progress.dart';
import 'package:naseej/features/learning/presentation/learn_skill_screen.dart';
import 'package:naseej/features/profile/domain/family_profile.dart';
import 'package:naseej/features/profile/presentation/family_role_ui.dart';
import 'package:naseej/features/skill/domain/skill_card.dart';
import 'package:naseej/features/skill/domain/skill_draft.dart';
import 'package:naseej/features/skill/presentation/skill_card_review_screen.dart';
import 'package:naseej/features/skill/presentation/skill_category_ui.dart';
import 'package:naseej/features/skill/presentation/teach_skill_screen.dart';
import 'package:naseej/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _openSkillDraft(
    BuildContext context, {
    required FamilyProfile teacher,
    required SkillDraft? initialDraft,
  }) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return TeachSkillScreen(teacher: teacher, initialDraft: initialDraft);
        },
      ),
    );
  }

  Future<void> _openSkillCard(
    BuildContext context, {
    required SkillDraft draft,
    required SkillCard? existingCard,
  }) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return SkillCardReviewScreen(
            draft: draft,
            existingCard: existingCard,
          );
        },
      ),
    );
  }

  Future<void> _openLearning(
    BuildContext context, {
    required SkillDraft draft,
    required SkillCard card,
  }) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return LearnSkillScreen(draft: draft, card: card);
        },
      ),
    );
  }

  String _learningActionLabel(
    AppLocalizations localizations,
    LearningProgress? progress,
  ) {
    if (progress == null) {
      return localizations.startLearningLabel;
    }

    if (progress.isCompleted) {
      return localizations.reviewCompletedLessonLabel;
    }

    return localizations.continueLearningLabel;
  }

  String _learningProgressBody(
    AppLocalizations localizations,
    LearningProgress? progress,
  ) {
    if (progress == null) {
      return localizations.learningNotStartedBody;
    }

    if (progress.isCompleted) {
      return localizations.learningCompletedBody;
    }

    return localizations.learningInProgressBody;
  }

  @override
  Widget build(BuildContext context) {
    final AppController controller = context.watch<AppController>();

    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final FamilyProfile? profile = controller.profile;

    final SkillDraft? draft = controller.skillDraft;

    final SkillCard? skillCard = controller.skillCard;

    final LearningProgress? learningProgress = controller.learningProgress;

    if (profile == null) {
      return const SizedBox.shrink();
    }

    final String roleLabel = familyRoleLabel(localizations, profile.role);

    return Scaffold(
      key: const ValueKey<String>('home_screen'),
      appBar: AppBar(
        title: Text(localizations.appTitle),
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
            Text(
              localizations.homeGreeting(profile.nickname),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            _ProfileSummaryCard(
              role: profile.role,
              roleLabel: roleLabel,
              storedLocallyLabel: localizations.profileStoredLocally,
            ),
            const SizedBox(height: AppSpacing.lg),
            if (draft == null)
              _EmptyWeaveCard(
                title: localizations.emptyWeaveTitle,
                body: localizations.emptyWeaveBody,
              )
            else
              _SkillDraftCard(
                title: localizations.savedDraftTitle,
                learnerSummary: localizations.draftLearnerSummary(
                  draft.learnerNickname,
                  familyRoleLabel(localizations, draft.learnerRole),
                ),
                categorySummary: localizations.draftCategorySummary(
                  skillCategoryLabel(localizations, draft.category),
                ),
                explanation: draft.explanation,
                contextPhotoPath: draft.contextPhotoPath,
                photoUnavailableLabel: localizations.contextPhotoUnavailable,
                storedLocallyLabel: localizations.draftStoredLocally,
              ),
            if (draft != null) ...<Widget>[
              const SizedBox(height: AppSpacing.lg),
              const AiReadinessCard(),
            ],
            if (skillCard != null) ...<Widget>[
              const SizedBox(height: AppSpacing.lg),
              _SavedSkillCardSummary(
                card: skillCard,
                title: localizations.savedSkillCardSummaryTitle,
                body: localizations.savedSkillCardSummaryBody,
                aiOrigin: localizations.skillCardAiOrigin,
                offlineOrigin: localizations.skillCardOfflineOrigin,
              ),
              const SizedBox(height: AppSpacing.lg),
              _LearningProgressSummary(
                title: localizations.learningProgressSummaryTitle,
                body: _learningProgressBody(localizations, learningProgress),
                countLabel: localizations.learningProgressCount(
                  learningProgress?.completedCount ?? 0,
                  LearningProgress.stepCount,
                ),
                progress: learningProgress?.progressFraction ?? 0,
                isCompleted: learningProgress?.isCompleted ?? false,
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            if (draft == null)
              SizedBox(
                height: 56,
                child: FilledButton.icon(
                  key: const ValueKey<String>('teach_skill_button'),
                  onPressed: () async {
                    await _openSkillDraft(
                      context,
                      teacher: profile,
                      initialDraft: null,
                    );
                  },
                  icon: const Icon(Icons.record_voice_over_rounded),
                  label: Text(localizations.teachSkillLabel),
                ),
              )
            else if (skillCard == null) ...<Widget>[
              SizedBox(
                height: 56,
                child: FilledButton.icon(
                  key: const ValueKey<String>('skill_card_action_button'),
                  onPressed: () async {
                    await _openSkillCard(
                      context,
                      draft: draft,
                      existingCard: null,
                    );
                  },
                  icon: const Icon(Icons.auto_awesome_rounded),
                  label: Text(localizations.buildSkillCardLabel),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                height: 56,
                child: OutlinedButton.icon(
                  key: const ValueKey<String>('teach_skill_button'),
                  onPressed: () async {
                    await _openSkillDraft(
                      context,
                      teacher: profile,
                      initialDraft: draft,
                    );
                  },
                  icon: const Icon(Icons.edit_note_rounded),
                  label: Text(localizations.continueDraftLabel),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                height: 56,
                child: OutlinedButton.icon(
                  key: const ValueKey<String>('learn_skill_button'),
                  onPressed: null,
                  icon: const Icon(Icons.school_rounded),
                  label: Text(localizations.learnSkillLabel),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                localizations.learningRequiresCardBody,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ] else ...<Widget>[
              SizedBox(
                height: 56,
                child: FilledButton.icon(
                  key: const ValueKey<String>('learn_skill_button'),
                  onPressed: () async {
                    await _openLearning(context, draft: draft, card: skillCard);
                  },
                  icon: Icon(
                    learningProgress?.isCompleted == true
                        ? Icons.verified_rounded
                        : Icons.school_rounded,
                  ),
                  label: Text(
                    _learningActionLabel(localizations, learningProgress),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                height: 56,
                child: OutlinedButton.icon(
                  key: const ValueKey<String>('skill_card_action_button'),
                  onPressed: () async {
                    await _openSkillCard(
                      context,
                      draft: draft,
                      existingCard: skillCard,
                    );
                  },
                  icon: const Icon(Icons.view_agenda_outlined),
                  label: Text(localizations.reviewSkillCardLabel),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              TextButton.icon(
                key: const ValueKey<String>('teach_skill_button'),
                onPressed: () async {
                  await _openSkillDraft(
                    context,
                    teacher: profile,
                    initialDraft: draft,
                  );
                },
                icon: const Icon(Icons.edit_note_rounded),
                label: Text(localizations.continueDraftLabel),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ProfileSummaryCard extends StatelessWidget {
  const _ProfileSummaryCard({
    required this.role,
    required this.roleLabel,
    required this.storedLocallyLabel,
  });

  final FamilyRole role;
  final String roleLabel;
  final String storedLocallyLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 88),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.surfaceSoft,
            child: Icon(
              familyRoleIcon(role),
              color: AppColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(roleLabel, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSpacing.xxs),
                Row(
                  children: <Widget>[
                    const Icon(
                      Icons.lock_outline_rounded,
                      color: AppColors.textSecondary,
                      size: 16,
                    ),
                    const SizedBox(width: AppSpacing.xxs),
                    Expanded(
                      child: Text(
                        storedLocallyLabel,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyWeaveCard extends StatelessWidget {
  const _EmptyWeaveCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 270),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(Icons.hub_outlined, color: AppColors.primary, size: 64),
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
        ],
      ),
    );
  }
}

class _SkillDraftCard extends StatelessWidget {
  const _SkillDraftCard({
    required this.title,
    required this.learnerSummary,
    required this.categorySummary,
    required this.explanation,
    required this.contextPhotoPath,
    required this.photoUnavailableLabel,
    required this.storedLocallyLabel,
  });

  final String title;
  final String learnerSummary;
  final String categorySummary;
  final String explanation;
  final String? contextPhotoPath;
  final String photoUnavailableLabel;
  final String storedLocallyLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 270),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(
                Icons.edit_note_rounded,
                color: AppColors.primary,
                size: 32,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          if (contextPhotoPath != null) ...<Widget>[
            const SizedBox(height: AppSpacing.md),
            _DraftPhotoPreview(
              photoPath: contextPhotoPath!,
              unavailableLabel: photoUnavailableLabel,
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          Text(learnerSummary, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(categorySummary, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.md),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              explanation,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: <Widget>[
              const Icon(
                Icons.lock_outline_rounded,
                color: AppColors.textSecondary,
                size: 16,
              ),
              const SizedBox(width: AppSpacing.xxs),
              Expanded(
                child: Text(
                  storedLocallyLabel,
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

class _DraftPhotoPreview extends StatelessWidget {
  const _DraftPhotoPreview({
    required this.photoPath,
    required this.unavailableLabel,
  });

  final String photoPath;
  final String unavailableLabel;

  @override
  Widget build(BuildContext context) {
    final File photoFile = File(photoPath);

    final bool exists = photoFile.existsSync();

    return ClipRRect(
      key: const ValueKey<String>('home_context_photo'),
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: double.infinity,
        height: 160,
        child: exists
            ? Image.file(
                photoFile,
                fit: BoxFit.cover,
                cacheWidth: 1200,
                errorBuilder:
                    (
                      BuildContext context,
                      Object error,
                      StackTrace? stackTrace,
                    ) {
                      return _UnavailablePhoto(label: unavailableLabel);
                    },
              )
            : _UnavailablePhoto(label: unavailableLabel),
      ),
    );
  }
}

class _UnavailablePhoto extends StatelessWidget {
  const _UnavailablePhoto({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.broken_image_outlined,
            color: AppColors.textSecondary,
            size: 40,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _SavedSkillCardSummary extends StatelessWidget {
  const _SavedSkillCardSummary({
    required this.card,
    required this.title,
    required this.body,
    required this.aiOrigin,
    required this.offlineOrigin,
  });

  final SkillCard card;
  final String title;
  final String body;
  final String aiOrigin;
  final String offlineOrigin;

  @override
  Widget build(BuildContext context) {
    final bool isAi = card.origin == SkillCardOrigin.ai;

    return Container(
      key: const ValueKey<String>('saved_skill_card_summary'),
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(
          color: isAi ? AppColors.success : AppColors.accent,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                isAi ? Icons.auto_awesome_rounded : Icons.offline_bolt_outlined,
                color: isAi ? AppColors.success : AppColors.accent,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(card.title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            isAi ? aiOrigin : offlineOrigin,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isAi ? AppColors.success : AppColors.accent,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(body, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _LearningProgressSummary extends StatelessWidget {
  const _LearningProgressSummary({
    required this.title,
    required this.body,
    required this.countLabel,
    required this.progress,
    required this.isCompleted,
  });

  final String title;
  final String body;
  final String countLabel;
  final double progress;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey<String>('learning_progress_summary'),
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isCompleted ? AppColors.surfaceSoft : AppColors.surface,
        border: Border.all(
          color: isCompleted ? AppColors.success : AppColors.border,
          width: isCompleted ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                isCompleted ? Icons.verified_rounded : Icons.school_outlined,
                color: isCompleted ? AppColors.success : AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            countLabel,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.xs),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: AppColors.disabled,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(body, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
