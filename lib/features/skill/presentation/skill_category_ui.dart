import 'package:flutter/material.dart';
import 'package:naseej/features/skill/domain/skill_draft.dart';
import 'package:naseej/l10n/app_localizations.dart';

String skillCategoryLabel(
  AppLocalizations localizations,
  SkillCategory category,
) {
  return switch (category) {
    SkillCategory.heritage => localizations.skillCategoryHeritage,
    SkillCategory.everyday => localizations.skillCategoryEveryday,
    SkillCategory.digital => localizations.skillCategoryDigital,
    SkillCategory.familyCare => localizations.skillCategoryFamilyCare,
  };
}

IconData skillCategoryIcon(SkillCategory category) {
  return switch (category) {
    SkillCategory.heritage => Icons.museum_rounded,
    SkillCategory.everyday => Icons.handyman_rounded,
    SkillCategory.digital => Icons.smartphone_rounded,
    SkillCategory.familyCare => Icons.favorite_outline_rounded,
  };
}
