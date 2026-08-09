import 'package:flutter/material.dart';
import 'package:naseej/core/theme/app_colors.dart';
import 'package:naseej/core/theme/app_spacing.dart';
import 'package:naseej/features/profile/domain/family_profile.dart';
import 'package:naseej/features/profile/presentation/family_role_ui.dart';

class RoleChoiceCard extends StatelessWidget {
  const RoleChoiceCard({
    required this.role,
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final FamilyRole role;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = selected
        ? AppColors.surfaceSoft
        : AppColors.surface;
    final Color borderColor = selected ? AppColors.primary : AppColors.border;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      onTap: onTap,
      child: ExcludeSemantics(
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Ink(
              decoration: BoxDecoration(
                color: backgroundColor,
                border: Border.all(color: borderColor, width: selected ? 2 : 1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      familyRoleIcon(role),
                      size: 32,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
