import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naseej/core/theme/app_colors.dart';
import 'package:naseej/core/theme/app_spacing.dart';
import 'package:naseej/features/welcome/presentation/widgets/language_segmented_control.dart';
import 'package:naseej/l10n/app_localizations.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({
    required this.selectedLanguageCode,
    required this.onLocaleChanged,
    required this.onContinue,
    super.key,
  });

  final String selectedLanguageCode;
  final Future<void> Function(Locale) onLocaleChanged;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.background,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        key: const ValueKey<String>('welcome_screen'),
        body: SafeArea(
          child: LayoutBuilder(
            builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: viewportConstraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                            AppSpacing.lg,
                            20,
                            AppSpacing.lg,
                            20,
                          ),
                          child: Column(
                            children: <Widget>[
                              Align(
                                alignment: AlignmentDirectional.centerEnd,
                                child: LanguageSegmentedControl(
                                  selectedLanguageCode: selectedLanguageCode,
                                  onLocaleChanged: onLocaleChanged,
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: _BrandSection(
                                    localizations: localizations,
                                  ),
                                ),
                              ),
                              _PrivacyNotice(
                                title: localizations.privacyTitle,
                                body: localizations.privacyBody,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: FilledButton(
                                  key: const ValueKey<String>(
                                    'continue_button',
                                  ),
                                  onPressed: onContinue,
                                  child: Text(localizations.continueLabel),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
          ),
        ),
      ),
    );
  }
}

class _BrandSection extends StatelessWidget {
  const _BrandSection({required this.localizations});

  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const _NaseejBrandMark(),
        const SizedBox(height: AppSpacing.lg),
        Text(
          localizations.appNameEnglish,
          textAlign: TextAlign.center,
          style: textTheme.displaySmall,
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          localizations.appNameArabic,
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
          style: textTheme.headlineMedium,
        ),
        const SizedBox(height: AppSpacing.sm),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Text(
            localizations.tagline,
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}

class _NaseejBrandMark extends StatelessWidget {
  const _NaseejBrandMark();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: 'Naseej',
      child: ExcludeSemantics(
        child: Container(
          width: 112,
          height: 112,
          decoration: BoxDecoration(
            color: AppColors.surfaceSoft,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary, width: 2),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Transform.translate(
                offset: const Offset(-12, 0),
                child: const _ThreadRing(color: AppColors.primary),
              ),
              Transform.translate(
                offset: const Offset(12, 0),
                child: const _ThreadRing(color: AppColors.accent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThreadRing extends StatelessWidget {
  const _ThreadRing({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 5),
      ),
    );
  }
}

class _PrivacyNotice extends StatelessWidget {
  const _PrivacyNotice({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 96),
      padding: const EdgeInsetsDirectional.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const ExcludeSemantics(
            child: Icon(
              Icons.lock_outline_rounded,
              size: 24,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: textTheme.titleMedium),
                const SizedBox(height: AppSpacing.xxs),
                Text(body, style: textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
