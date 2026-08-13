import 'dart:convert';

import 'package:naseej/features/skill/domain/skill_draft.dart';

enum SkillCardOrigin {
  ai,
  offlineGuide;

  static SkillCardOrigin? fromStorageValue(String? value) {
    for (final SkillCardOrigin origin in SkillCardOrigin.values) {
      if (origin.name == value) {
        return origin;
      }
    }

    return null;
  }
}

class SkillCard {
  const SkillCard({
    required this.title,
    required this.steps,
    required this.safetyNote,
    required this.teachBackQuestion,
    required this.reciprocalSkillSuggestion,
    required this.outputLanguageCode,
    required this.origin,
    required this.sourceDraftFingerprint,
    this.modelName,
  });

  static const int maximumTitleLength = 100;
  static const int maximumStepLength = 220;
  static const int maximumSafetyNoteLength = 280;
  static const int maximumQuestionLength = 220;
  static const int maximumSuggestionLength = 220;

  final String title;
  final List<String> steps;
  final String safetyNote;
  final String teachBackQuestion;
  final String reciprocalSkillSuggestion;
  final String outputLanguageCode;
  final SkillCardOrigin origin;
  final String sourceDraftFingerprint;
  final String? modelName;

  String get contentFingerprint {
    return fingerprintForCard(this);
  }

  bool matchesDraft(SkillDraft draft) {
    return sourceDraftFingerprint == fingerprintForDraft(draft);
  }

  String toJsonString() {
    return jsonEncode(<String, Object?>{
      'title': title,
      'steps': steps,
      'safetyNote': safetyNote,
      'teachBackQuestion': teachBackQuestion,
      'reciprocalSkillSuggestion': reciprocalSkillSuggestion,
      'outputLanguageCode': outputLanguageCode,
      'origin': origin.name,
      'sourceDraftFingerprint': sourceDraftFingerprint,
      'modelName': modelName,
    });
  }

  static SkillCard? fromJsonString(String? source) {
    if (source == null || source.trim().isEmpty) {
      return null;
    }

    try {
      final Object? decoded = jsonDecode(source);

      if (decoded is! Map<String, dynamic>) {
        return null;
      }

      final SkillCardOrigin? origin = SkillCardOrigin.fromStorageValue(
        decoded['origin'] is String ? decoded['origin'] as String : null,
      );

      final String? outputLanguageCode = _readLanguageCode(
        decoded['outputLanguageCode'],
      );

      final String? sourceDraftFingerprint = _readText(
        decoded['sourceDraftFingerprint'],
        maximumLength: 100,
      );

      final Object? modelNameValue = decoded['modelName'];

      if (modelNameValue != null && modelNameValue is! String) {
        return null;
      }

      final String? modelName =
          modelNameValue is String && modelNameValue.trim().isNotEmpty
          ? modelNameValue.trim()
          : null;

      if (origin == null ||
          outputLanguageCode == null ||
          sourceDraftFingerprint == null) {
        return null;
      }

      if (origin == SkillCardOrigin.ai && modelName == null) {
        return null;
      }

      return _validatedCard(
        titleValue: decoded['title'],
        stepsValue: decoded['steps'],
        safetyNoteValue: decoded['safetyNote'],
        teachBackQuestionValue: decoded['teachBackQuestion'],
        reciprocalSuggestionValue: decoded['reciprocalSkillSuggestion'],
        outputLanguageCode: outputLanguageCode,
        origin: origin,
        sourceDraftFingerprint: sourceDraftFingerprint,
        modelName: modelName,
      );
    } on FormatException {
      return null;
    }
  }

  static SkillCard? fromGeneratedMap({
    required Map<String, dynamic> map,
    required String outputLanguageCode,
    required SkillCardOrigin origin,
    required String sourceDraftFingerprint,
    required String? modelName,
  }) {
    final String? normalizedLanguage = _readLanguageCode(outputLanguageCode);

    if (normalizedLanguage == null) {
      return null;
    }

    return _validatedCard(
      titleValue: map['title'],
      stepsValue: map['steps'],
      safetyNoteValue: map['safety_note'],
      teachBackQuestionValue: map['teach_back_question'],
      reciprocalSuggestionValue: map['reciprocal_skill_suggestion'],
      outputLanguageCode: normalizedLanguage,
      origin: origin,
      sourceDraftFingerprint: sourceDraftFingerprint,
      modelName: modelName,
    );
  }

  static String fingerprintForDraft(SkillDraft draft) {
    final String canonicalSource = jsonEncode(<String, String>{
      'teacherNickname': draft.teacherNickname.trim(),
      'teacherRole': draft.teacherRole.name,
      'learnerNickname': draft.learnerNickname.trim(),
      'learnerRole': draft.learnerRole.name,
      'category': draft.category.name,
      'explanation': draft.explanation.trim(),
    });

    return _fingerprint(canonicalSource);
  }

  static String fingerprintForCard(SkillCard card) {
    final String canonicalSource = jsonEncode(<String, Object?>{
      'title': card.title.trim(),
      'steps': card.steps.map((String step) => step.trim()).toList(),
      'safetyNote': card.safetyNote.trim(),
      'teachBackQuestion': card.teachBackQuestion.trim(),
      'reciprocalSkillSuggestion': card.reciprocalSkillSuggestion.trim(),
      'outputLanguageCode': card.outputLanguageCode,
      'origin': card.origin.name,
      'sourceDraftFingerprint': card.sourceDraftFingerprint,
      'modelName': card.modelName,
    });

    return _fingerprint(canonicalSource);
  }

  static String _fingerprint(String canonicalSource) {
    int hash = 0x811C9DC5;

    for (final int byte in utf8.encode(canonicalSource)) {
      hash ^= byte;
      hash = (hash * 0x01000193) & 0xFFFFFFFF;
    }

    return hash.toRadixString(16).padLeft(8, '0');
  }

  static SkillCard? _validatedCard({
    required Object? titleValue,
    required Object? stepsValue,
    required Object? safetyNoteValue,
    required Object? teachBackQuestionValue,
    required Object? reciprocalSuggestionValue,
    required String outputLanguageCode,
    required SkillCardOrigin origin,
    required String sourceDraftFingerprint,
    required String? modelName,
  }) {
    final String? title = _readText(
      titleValue,
      maximumLength: maximumTitleLength,
    );

    final List<String>? steps = _readSteps(stepsValue);

    final String? safetyNote = _readText(
      safetyNoteValue,
      maximumLength: maximumSafetyNoteLength,
    );

    final String? teachBackQuestion = _readText(
      teachBackQuestionValue,
      maximumLength: maximumQuestionLength,
    );

    final String? reciprocalSuggestion = _readText(
      reciprocalSuggestionValue,
      maximumLength: maximumSuggestionLength,
    );

    if (title == null ||
        steps == null ||
        safetyNote == null ||
        teachBackQuestion == null ||
        reciprocalSuggestion == null ||
        sourceDraftFingerprint.trim().isEmpty) {
      return null;
    }

    return SkillCard(
      title: title,
      steps: List<String>.unmodifiable(steps),
      safetyNote: safetyNote,
      teachBackQuestion: teachBackQuestion,
      reciprocalSkillSuggestion: reciprocalSuggestion,
      outputLanguageCode: outputLanguageCode,
      origin: origin,
      sourceDraftFingerprint: sourceDraftFingerprint,
      modelName: modelName,
    );
  }

  static List<String>? _readSteps(Object? value) {
    if (value is! List<dynamic> || value.length != 3) {
      return null;
    }

    final List<String> steps = <String>[];

    for (final Object? item in value) {
      final String? step = _readText(item, maximumLength: maximumStepLength);

      if (step == null) {
        return null;
      }

      steps.add(step);
    }

    return steps;
  }

  static String? _readLanguageCode(Object? value) {
    if (value is! String) {
      return null;
    }

    final String normalized = value.trim().toLowerCase();

    if (normalized == 'en' || normalized == 'ar') {
      return normalized;
    }

    return null;
  }

  static String? _readText(Object? value, {required int maximumLength}) {
    if (value is! String) {
      return null;
    }

    final String normalized = value.trim();

    if (normalized.isEmpty || normalized.length > maximumLength) {
      return null;
    }

    return normalized;
  }

  @override
  bool operator ==(Object other) {
    return other is SkillCard &&
        other.title == title &&
        _listEquals(other.steps, steps) &&
        other.safetyNote == safetyNote &&
        other.teachBackQuestion == teachBackQuestion &&
        other.reciprocalSkillSuggestion == reciprocalSkillSuggestion &&
        other.outputLanguageCode == outputLanguageCode &&
        other.origin == origin &&
        other.sourceDraftFingerprint == sourceDraftFingerprint &&
        other.modelName == modelName;
  }

  @override
  int get hashCode {
    return Object.hash(
      title,
      Object.hashAll(steps),
      safetyNote,
      teachBackQuestion,
      reciprocalSkillSuggestion,
      outputLanguageCode,
      origin,
      sourceDraftFingerprint,
      modelName,
    );
  }

  static bool _listEquals(List<String> first, List<String> second) {
    if (first.length != second.length) {
      return false;
    }

    for (int index = 0; index < first.length; index += 1) {
      if (first[index] != second[index]) {
        return false;
      }
    }

    return true;
  }
}
