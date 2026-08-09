import 'package:flutter/material.dart';
import 'package:naseej/features/profile/domain/family_profile.dart';
import 'package:naseej/l10n/app_localizations.dart';

String familyRoleLabel(AppLocalizations localizations, FamilyRole role) {
  return switch (role) {
    FamilyRole.grandparent => localizations.roleGrandparent,
    FamilyRole.parent => localizations.roleParent,
    FamilyRole.teen => localizations.roleTeen,
    FamilyRole.child => localizations.roleChild,
  };
}

IconData familyRoleIcon(FamilyRole role) {
  return switch (role) {
    FamilyRole.grandparent => Icons.elderly_rounded,
    FamilyRole.parent => Icons.family_restroom_rounded,
    FamilyRole.teen => Icons.school_rounded,
    FamilyRole.child => Icons.child_care_rounded,
  };
}
