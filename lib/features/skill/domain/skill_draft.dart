import 'dart:convert';

import 'package:naseej/features/profile/domain/family_profile.dart';

enum SkillCategory {
  heritage,
  everyday,
  digital,
  familyCare;

  static SkillCategory? fromStorageValue(String? value) {
    for (final SkillCategory category in SkillCategory.values) {
      if (category.name == value) {
        return category;
      }
    }

    return null;
  }
}

class SkillDraft {
  const SkillDraft({
    required this.teacherNickname,
    required this.teacherRole,
    required this.learnerNickname,
    required this.learnerRole,
    required this.category,
    required this.explanation,
    this.contextPhotoPath,
  });

  static const int minimumExplanationLength = 20;
  static const int maximumExplanationLength = 600;

  final String teacherNickname;
  final FamilyRole teacherRole;
  final String learnerNickname;
  final FamilyRole learnerRole;
  final SkillCategory category;
  final String explanation;
  final String? contextPhotoPath;

  String toJsonString() {
    return jsonEncode(<String, Object?>{
      'teacherNickname': teacherNickname,
      'teacherRole': teacherRole.name,
      'learnerNickname': learnerNickname,
      'learnerRole': learnerRole.name,
      'category': category.name,
      'explanation': explanation,
      'contextPhotoPath': contextPhotoPath,
    });
  }

  static SkillDraft? fromJsonString(String? source) {
    if (source == null || source.trim().isEmpty) {
      return null;
    }

    try {
      final Object? decoded = jsonDecode(source);

      if (decoded is! Map<String, dynamic>) {
        return null;
      }

      final Object? teacherNicknameValue = decoded['teacherNickname'];
      final Object? teacherRoleValue = decoded['teacherRole'];
      final Object? learnerNicknameValue = decoded['learnerNickname'];
      final Object? learnerRoleValue = decoded['learnerRole'];
      final Object? categoryValue = decoded['category'];
      final Object? explanationValue = decoded['explanation'];
      final Object? contextPhotoPathValue = decoded['contextPhotoPath'];

      if (teacherNicknameValue is! String ||
          teacherRoleValue is! String ||
          learnerNicknameValue is! String ||
          learnerRoleValue is! String ||
          categoryValue is! String ||
          explanationValue is! String) {
        return null;
      }

      if (contextPhotoPathValue != null && contextPhotoPathValue is! String) {
        return null;
      }

      final String teacherNickname = teacherNicknameValue.trim();
      final String learnerNickname = learnerNicknameValue.trim();
      final String explanation = explanationValue.trim();

      final FamilyRole? teacherRole = FamilyRole.fromStorageValue(
        teacherRoleValue,
      );

      final FamilyRole? learnerRole = FamilyRole.fromStorageValue(
        learnerRoleValue,
      );

      final SkillCategory? category = SkillCategory.fromStorageValue(
        categoryValue,
      );

      final String? contextPhotoPath =
          contextPhotoPathValue is String &&
              contextPhotoPathValue.trim().isNotEmpty
          ? contextPhotoPathValue.trim()
          : null;

      if (teacherNickname.isEmpty ||
          learnerNickname.isEmpty ||
          teacherRole == null ||
          learnerRole == null ||
          category == null ||
          explanation.length < minimumExplanationLength ||
          explanation.length > maximumExplanationLength) {
        return null;
      }

      return SkillDraft(
        teacherNickname: teacherNickname,
        teacherRole: teacherRole,
        learnerNickname: learnerNickname,
        learnerRole: learnerRole,
        category: category,
        explanation: explanation,
        contextPhotoPath: contextPhotoPath,
      );
    } on FormatException {
      return null;
    }
  }

  @override
  bool operator ==(Object other) {
    return other is SkillDraft &&
        other.teacherNickname == teacherNickname &&
        other.teacherRole == teacherRole &&
        other.learnerNickname == learnerNickname &&
        other.learnerRole == learnerRole &&
        other.category == category &&
        other.explanation == explanation &&
        other.contextPhotoPath == contextPhotoPath;
  }

  @override
  int get hashCode {
    return Object.hash(
      teacherNickname,
      teacherRole,
      learnerNickname,
      learnerRole,
      category,
      explanation,
      contextPhotoPath,
    );
  }
}
