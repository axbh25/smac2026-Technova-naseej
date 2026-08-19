import 'package:flutter/material.dart';
import 'package:naseej/core/photo/context_photo_service.dart';
import 'package:naseej/core/photo/device_context_photo_service.dart';
import 'package:naseej/core/state/app_controller.dart';
import 'package:naseej/core/theme/app_colors.dart';
import 'package:naseej/core/theme/app_spacing.dart';
import 'package:naseej/features/demo/domain/demo_journey.dart';
import 'package:naseej/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class DemoDataScreen extends StatefulWidget {
  const DemoDataScreen({this.contextPhotoService, super.key});

  final ContextPhotoService? contextPhotoService;

  @override
  State<DemoDataScreen> createState() {
    return _DemoDataScreenState();
  }
}

class _DemoDataScreenState extends State<DemoDataScreen> {
  late final ContextPhotoService _contextPhotoService;

  bool _isWorking = false;

  @override
  void initState() {
    super.initState();

    _contextPhotoService =
        widget.contextPhotoService ?? DeviceContextPhotoService();
  }

  bool _requiresReplacementConfirmation(AppController controller) {
    return controller.hasAnyFamilyData ||
        controller.recoveryNotice == AppRecoveryNotice.storageUnavailable;
  }

  Future<bool> _confirm({
    required String title,
    required String body,
    required String confirmLabel,
    required bool destructive,
    required String confirmKey,
  }) async {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: Text(localizations.cancelLabel),
            ),
            FilledButton(
              key: ValueKey<String>(confirmKey),
              style: destructive
                  ? FilledButton.styleFrom(backgroundColor: AppColors.error)
                  : null,
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: Text(confirmLabel),
            ),
          ],
        );
      },
    );

    return confirmed ?? false;
  }

  Future<bool> _deleteReplacedPhoto({
    required String? previousPhotoPath,
    required AppController controller,
  }) async {
    if (previousPhotoPath == null) {
      return true;
    }

    final String? currentPhotoPath = controller.skillDraft?.contextPhotoPath;

    if (currentPhotoPath == previousPhotoPath) {
      return true;
    }

    try {
      await _contextPhotoService.deleteStoredPhoto(previousPhotoPath);

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _loadAiReady() async {
    await _loadJourney(journeyBuilder: DemoJourneyFactory.aiReady);
  }

  Future<void> _loadCompletedOffline() async {
    await _loadJourney(journeyBuilder: DemoJourneyFactory.completedOffline);
  }

  Future<void> _loadJourney({
    required DemoJourney Function(String languageCode) journeyBuilder,
  }) async {
    if (_isWorking) {
      return;
    }

    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final AppController controller = context.read<AppController>();

    if (_requiresReplacementConfirmation(controller)) {
      final bool confirmed = await _confirm(
        title: localizations.confirmDemoReplaceTitle,
        body: localizations.confirmDemoReplaceBody,
        confirmLabel: localizations.replaceDataLabel,
        destructive: false,
        confirmKey: 'confirm_replace_demo_button',
      );

      if (!mounted || !confirmed) {
        return;
      }
    }

    final String? previousPhotoPath = controller.skillDraft?.contextPhotoPath;

    setState(() {
      _isWorking = true;
    });

    try {
      final DemoJourney journey = journeyBuilder(
        controller.locale.languageCode,
      );

      await controller.loadDemoJourney(journey);

      final bool photoDeleted = await _deleteReplacedPhoto(
        previousPhotoPath: previousPhotoPath,
        controller: controller,
      );

      if (!mounted) {
        return;
      }

      _showMessage(
        photoDeleted
            ? localizations.demoLoadedSuccess
            : '${localizations.demoLoadedSuccess} '
                  '${localizations.photoCleanupWarning}',
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      _showMessage(localizations.dataOperationError);
    } finally {
      if (mounted) {
        setState(() {
          _isWorking = false;
        });
      }
    }
  }

  Future<void> _resetData() async {
    if (_isWorking) {
      return;
    }

    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final bool confirmed = await _confirm(
      title: localizations.confirmResetDataTitle,
      body: localizations.confirmResetDataBody,
      confirmLabel: localizations.resetDataConfirmLabel,
      destructive: true,
      confirmKey: 'confirm_reset_data_button',
    );

    if (!mounted || !confirmed) {
      return;
    }

    final AppController controller = context.read<AppController>();

    final String? previousPhotoPath = controller.skillDraft?.contextPhotoPath;

    setState(() {
      _isWorking = true;
    });

    try {
      await controller.resetFamilyData();

      final bool photoDeleted = await _deleteReplacedPhoto(
        previousPhotoPath: previousPhotoPath,
        controller: controller,
      );

      if (!mounted) {
        return;
      }

      _showMessage(
        photoDeleted
            ? localizations.dataResetSuccess
            : '${localizations.dataResetSuccess} '
                  '${localizations.photoCleanupWarning}',
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      _showMessage(localizations.dataOperationError);
    } finally {
      if (mounted) {
        setState(() {
          _isWorking = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final AppController controller = context.watch<AppController>();

    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final Widget? recoveryCard = _buildRecoveryCard(controller, localizations);

    return Scaffold(
      key: const ValueKey<String>('demo_data_screen'),
      appBar: AppBar(title: Text(localizations.demoDataScreenTitle)),
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
            if (recoveryCard != null) ...<Widget>[
              recoveryCard,
              const SizedBox(height: AppSpacing.lg),
            ],
            _LocalStatusCard(
              title: localizations.localDataStatusTitle,
              body: localizations.localDataStatusBody,
              rows: <_StatusData>[
                _StatusData(
                  label: localizations.profileDataLabel,
                  present: controller.profile != null,
                ),
                _StatusData(
                  label: localizations.draftDataLabel,
                  present: controller.skillDraft != null,
                ),
                _StatusData(
                  label: localizations.cardDataLabel,
                  present: controller.skillCard != null,
                ),
                _StatusData(
                  label: localizations.progressDataLabel,
                  present: controller.learningProgress != null,
                  completed: controller.learningProgress?.isCompleted ?? false,
                ),
                _StatusData(
                  label: localizations.familyThreadDataLabel,
                  present: controller.learningProgress != null,
                  completed:
                      controller.learningProgress?.isExchangeCompleted ?? false,
                ),
              ],
              presentLabel: localizations.statusPresentLabel,
              missingLabel: localizations.statusMissingLabel,
              completedLabel: localizations.statusCompletedLabel,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              localizations.demoPreparationTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              localizations.demoPreparationBody,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            _DemoOptionCard(
              title: localizations.aiReadyDemoTitle,
              body: localizations.aiReadyDemoBody,
              notice: localizations.demoSampleNotice,
              icon: Icons.auto_awesome_outlined,
              actionLabel: localizations.loadAiReadyDemoLabel,
              actionKey: 'load_ai_ready_demo_button',
              enabled: !_isWorking,
              onPressed: _loadAiReady,
            ),
            const SizedBox(height: AppSpacing.md),
            _DemoOptionCard(
              title: localizations.completedDemoTitle,
              body: localizations.completedDemoBody,
              notice: localizations.completedSampleNotice,
              icon: Icons.hub_outlined,
              actionLabel: localizations.loadCompletedDemoLabel,
              actionKey: 'load_completed_demo_button',
              enabled: !_isWorking,
              onPressed: _loadCompletedOffline,
            ),
            const SizedBox(height: AppSpacing.lg),
            _ResetDataCard(
              title: localizations.resetDataTitle,
              body: localizations.resetDataBody,
              actionLabel: localizations.resetLocalDataLabel,
              enabled: !_isWorking,
              onPressed: _resetData,
            ),
            if (_isWorking) ...<Widget>[
              const SizedBox(height: AppSpacing.lg),
              const Center(child: CircularProgressIndicator()),
            ],
          ],
        ),
      ),
    );
  }

  Widget? _buildRecoveryCard(
    AppController controller,
    AppLocalizations localizations,
  ) {
    switch (controller.recoveryNotice) {
      case AppRecoveryNotice.none:
        return null;

      case AppRecoveryNotice.repairedInvalidData:
        return _RecoveryNoticeCard(
          title: localizations.recoveryRepairedTitle,
          body: localizations.recoveryRepairedBody,
          color: AppColors.success,
          icon: Icons.health_and_safety_outlined,
          dismissLabel: localizations.dismissLabel,
          onDismiss: controller.dismissRecoveryNotice,
        );

      case AppRecoveryNotice.storageUnavailable:
        return _RecoveryNoticeCard(
          title: localizations.recoveryStorageTitle,
          body: localizations.recoveryStorageBody,
          color: AppColors.error,
          icon: Icons.error_outline_rounded,
          dismissLabel: localizations.dismissLabel,
          onDismiss: controller.dismissRecoveryNotice,
        );
    }
  }
}

class _RecoveryNoticeCard extends StatelessWidget {
  const _RecoveryNoticeCard({
    required this.title,
    required this.body,
    required this.color,
    required this.icon,
    required this.dismissLabel,
    required this.onDismiss,
  });

  final String title;
  final String body;
  final Color color;
  final IconData icon;
  final String dismissLabel;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey<String>('recovery_notice_card'),
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(icon, color: color),
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
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton(
              key: const ValueKey<String>('dismiss_recovery_button'),
              onPressed: onDismiss,
              child: Text(dismissLabel),
            ),
          ),
        ],
      ),
    );
  }
}

class _LocalStatusCard extends StatelessWidget {
  const _LocalStatusCard({
    required this.title,
    required this.body,
    required this.rows,
    required this.presentLabel,
    required this.missingLabel,
    required this.completedLabel,
  });

  final String title;
  final String body;
  final List<_StatusData> rows;
  final String presentLabel;
  final String missingLabel;
  final String completedLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey<String>('local_data_status_card'),
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.xs),
          Text(body, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.md),
          for (int index = 0; index < rows.length; index += 1) ...<Widget>[
            _StatusRow(
              data: rows[index],
              presentLabel: presentLabel,
              missingLabel: missingLabel,
              completedLabel: completedLabel,
            ),
            if (index < rows.length - 1) const Divider(),
          ],
        ],
      ),
    );
  }
}

class _StatusData {
  const _StatusData({
    required this.label,
    required this.present,
    this.completed = false,
  });

  final String label;
  final bool present;
  final bool completed;
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({
    required this.data,
    required this.presentLabel,
    required this.missingLabel,
    required this.completedLabel,
  });

  final _StatusData data;
  final String presentLabel;
  final String missingLabel;
  final String completedLabel;

  @override
  Widget build(BuildContext context) {
    final String status = data.completed
        ? completedLabel
        : data.present
        ? presentLabel
        : missingLabel;

    final Color color = data.completed
        ? AppColors.success
        : data.present
        ? AppColors.primary
        : AppColors.textSecondary;

    final IconData icon = data.completed
        ? Icons.verified_rounded
        : data.present
        ? Icons.check_circle_outline_rounded
        : Icons.remove_circle_outline_rounded;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              data.label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Icon(icon, color: color, size: 20),
          const SizedBox(width: AppSpacing.xs),
          Text(
            status,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _DemoOptionCard extends StatelessWidget {
  const _DemoOptionCard({
    required this.title,
    required this.body,
    required this.notice,
    required this.icon,
    required this.actionLabel,
    required this.actionKey,
    required this.enabled,
    required this.onPressed,
  });

  final String title;
  final String body;
  final String notice;
  final IconData icon;
  final String actionLabel;
  final String actionKey;
  final bool enabled;
  final Future<void> Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: AppColors.primary, size: 40),
          const SizedBox(height: AppSpacing.sm),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.xs),
          Text(body, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Icon(
                Icons.info_outline_rounded,
                size: 18,
                color: AppColors.textSecondary,
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
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton.icon(
              key: ValueKey<String>(actionKey),
              onPressed: enabled
                  ? () async {
                      await onPressed();
                    }
                  : null,
              icon: Icon(icon),
              label: Text(actionLabel),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResetDataCard extends StatelessWidget {
  const _ResetDataCard({
    required this.title,
    required this.body,
    required this.actionLabel,
    required this.enabled,
    required this.onPressed,
  });

  final String title;
  final String body;
  final String actionLabel;
  final bool enabled;
  final Future<void> Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.error),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Icon(
            Icons.delete_sweep_outlined,
            color: AppColors.error,
            size: 40,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.xs),
          Text(body, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: OutlinedButton.icon(
              key: const ValueKey<String>('reset_local_data_button'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
              ),
              onPressed: enabled
                  ? () async {
                      await onPressed();
                    }
                  : null,
              icon: const Icon(Icons.delete_outline_rounded),
              label: Text(actionLabel),
            ),
          ),
        ],
      ),
    );
  }
}
