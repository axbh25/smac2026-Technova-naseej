import 'package:flutter/material.dart';
import 'package:naseej/core/ai/ai_readiness_controller.dart';
import 'package:naseej/core/ai/ai_readiness_service.dart';
import 'package:naseej/core/theme/app_colors.dart';
import 'package:naseej/core/theme/app_spacing.dart';
import 'package:naseej/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class AiReadinessCard extends StatelessWidget {
  const AiReadinessCard({super.key});

  @override
  Widget build(BuildContext context) {
    final AiReadinessController controller = context
        .watch<AiReadinessController>();

    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final _AiCardPresentation presentation = _presentationFor(
      controller,
      localizations,
    );

    final bool isChecking = controller.status == AiReadinessStatus.checking;

    final bool wasChecked =
        controller.status == AiReadinessStatus.ready ||
        controller.status == AiReadinessStatus.unavailable;

    return Container(
      key: const ValueKey<String>('ai_readiness_card'),
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 180),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(
          color: presentation.color,
          width: controller.status == AiReadinessStatus.idle ? 1 : 2,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.surfaceSoft,
                  shape: BoxShape.circle,
                  border: Border.all(color: presentation.color),
                ),
                child: Icon(
                  presentation.icon,
                  color: presentation.color,
                  size: 26,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      presentation.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    KeyedSubtree(
                      key: ValueKey<String>(presentation.statusKey),
                      child: Semantics(
                        liveRegion: true,
                        child: Text(
                          presentation.body,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (controller.status == AiReadinessStatus.ready &&
              controller.modelName != null) ...<Widget>[
            const SizedBox(height: AppSpacing.sm),
            Text(
              localizations.aiModelLabel(controller.modelName!),
              key: const ValueKey<String>('ai_model_label'),
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.success),
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Icon(
                Icons.shield_outlined,
                color: AppColors.textSecondary,
                size: 18,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  localizations.aiNoFamilyDataNotice,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: OutlinedButton.icon(
              key: const ValueKey<String>('ai_check_button'),
              onPressed: isChecking
                  ? null
                  : () async {
                      await controller.checkReadiness();
                    },
              icon: isChecking
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(
                      wasChecked
                          ? Icons.refresh_rounded
                          : Icons.auto_awesome_outlined,
                    ),
              label: Text(
                isChecking
                    ? localizations.aiCheckingButtonLabel
                    : wasChecked
                    ? localizations.aiCheckAgainLabel
                    : localizations.aiCheckConnectionLabel,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _AiCardPresentation _presentationFor(
    AiReadinessController controller,
    AppLocalizations localizations,
  ) {
    return switch (controller.status) {
      AiReadinessStatus.idle => _AiCardPresentation(
        statusKey: 'ai_status_idle',
        icon: Icons.auto_awesome_outlined,
        color: AppColors.primary,
        title: localizations.aiReadinessTitle,
        body: localizations.aiReadinessIdleBody,
      ),
      AiReadinessStatus.checking => _AiCardPresentation(
        statusKey: 'ai_status_checking',
        icon: Icons.sync_rounded,
        color: AppColors.primary,
        title: localizations.aiCheckingTitle,
        body: localizations.aiCheckingBody,
      ),
      AiReadinessStatus.ready => _AiCardPresentation(
        statusKey: 'ai_status_ready',
        icon: Icons.verified_rounded,
        color: AppColors.success,
        title: localizations.aiReadyTitle,
        body: localizations.aiReadyBody,
      ),
      AiReadinessStatus.unavailable => _AiCardPresentation(
        statusKey: 'ai_status_unavailable',
        icon: Icons.cloud_off_rounded,
        color: AppColors.error,
        title: localizations.aiUnavailableTitle,
        body: _failureMessage(controller.failure, localizations),
      ),
    };
  }

  String _failureMessage(
    AiReadinessFailure? failure,
    AppLocalizations localizations,
  ) {
    return switch (failure) {
      AiReadinessFailure.firebaseNotConfigured =>
        localizations.aiFirebaseConfigError,
      AiReadinessFailure.offlineOrTimeout => localizations.aiOfflineError,
      AiReadinessFailure.appCheckRejected => localizations.aiAppCheckError,
      AiReadinessFailure.quotaExceeded => localizations.aiQuotaError,
      AiReadinessFailure.serviceNotEnabled =>
        localizations.aiServiceDisabledError,
      AiReadinessFailure.invalidResponse =>
        localizations.aiInvalidResponseError,
      AiReadinessFailure.unknown || null => localizations.aiGenericError,
    };
  }
}

class _AiCardPresentation {
  const _AiCardPresentation({
    required this.statusKey,
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
  });

  final String statusKey;
  final IconData icon;
  final Color color;
  final String title;
  final String body;
}
