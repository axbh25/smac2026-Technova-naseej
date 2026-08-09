import 'package:flutter/material.dart';
import 'package:naseej/core/state/app_controller.dart';
import 'package:naseej/core/theme/app_colors.dart';
import 'package:naseej/core/theme/app_spacing.dart';
import 'package:naseej/core/widgets/language_toggle_button.dart';
import 'package:naseej/features/profile/domain/family_profile.dart';
import 'package:naseej/features/profile/presentation/family_role_ui.dart';
import 'package:naseej/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showComingSoon(BuildContext context, AppLocalizations localizations) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(localizations.featureComingSoon)));
  }

  @override
  Widget build(BuildContext context) {
    final AppController controller = context.watch<AppController>();
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final FamilyProfile? profile = controller.profile;

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
            _EmptyWeaveCard(
              title: localizations.emptyWeaveTitle,
              body: localizations.emptyWeaveBody,
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              height: 56,
              child: FilledButton.icon(
                key: const ValueKey<String>('teach_skill_button'),
                onPressed: () {
                  _showComingSoon(context, localizations);
                },
                icon: const Icon(Icons.record_voice_over_rounded),
                label: Text(localizations.teachSkillLabel),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              height: 56,
              child: OutlinedButton.icon(
                key: const ValueKey<String>('learn_skill_button'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  _showComingSoon(context, localizations);
                },
                icon: const Icon(Icons.school_rounded),
                label: Text(localizations.learnSkillLabel),
              ),
            ),
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
