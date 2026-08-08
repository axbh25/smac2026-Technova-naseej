import 'package:flutter/material.dart';
import 'package:naseej/core/theme/app_colors.dart';
import 'package:naseej/core/theme/app_spacing.dart';
import 'package:naseej/l10n/app_localizations.dart';

class LanguageSegmentedControl extends StatelessWidget {
  const LanguageSegmentedControl({
    required this.selectedLanguageCode,
    required this.onLocaleChanged,
    super.key,
  });

  final String selectedLanguageCode;
  final ValueChanged<Locale> onLocaleChanged;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        width: 220,
        height: 56,
        padding: const EdgeInsets.all(AppSpacing.xxs),
        decoration: BoxDecoration(
          color: AppColors.surfaceSoft,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: _LanguageOption(
                key: const ValueKey<String>('language_en_button'),
                label: localizations.englishLanguage,
                selected: selectedLanguageCode == 'en',
                onTap: () => onLocaleChanged(const Locale('en')),
              ),
            ),
            const SizedBox(width: AppSpacing.xxs),
            Expanded(
              child: _LanguageOption(
                key: const ValueKey<String>('language_ar_button'),
                label: localizations.arabicLanguage,
                selected: selectedLanguageCode == 'ar',
                onTap: () => onLocaleChanged(const Locale('ar')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = selected
        ? AppColors.primary
        : Colors.transparent;
    final Color foregroundColor = selected
        ? AppColors.onPrimary
        : AppColors.primary;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      onTap: onTap,
      child: ExcludeSemantics(
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Ink(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  label,
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(color: foregroundColor),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
