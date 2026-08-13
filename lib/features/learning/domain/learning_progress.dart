import 'dart:convert';

import 'package:naseej/features/skill/domain/skill_card.dart';

class LearningProgress {
  LearningProgress({
    required this.skillCardFingerprint,
    required List<int> completedStepIndexes,
    required this.teachBackResponse,
    this.completedAtIso8601,
  }) : completedStepIndexes = List<int>.unmodifiable(completedStepIndexes);

  static const int stepCount = 3;
  static const int minimumTeachBackLength = 10;
  static const int maximumTeachBackLength = 400;
  static const int maximumFingerprintLength = 100;

  final String skillCardFingerprint;
  final List<int> completedStepIndexes;
  final String teachBackResponse;
  final String? completedAtIso8601;

  int get completedCount {
    return completedStepIndexes.length;
  }

  double get progressFraction {
    return completedCount / stepCount;
  }

  bool get allStepsCompleted {
    return completedCount == stepCount;
  }

  bool get hasValidTeachBack {
    final int length = teachBackResponse.trim().length;

    return length >= minimumTeachBackLength && length <= maximumTeachBackLength;
  }

  bool get isCompleted {
    return allStepsCompleted && hasValidTeachBack && completedAtIso8601 != null;
  }

  bool isStepCompleted(int index) {
    return completedStepIndexes.contains(index);
  }

  bool matchesCard(SkillCard card) {
    return skillCardFingerprint == card.contentFingerprint;
  }

  static LearningProgress emptyFor(SkillCard card) {
    return LearningProgress(
      skillCardFingerprint: card.contentFingerprint,
      completedStepIndexes: const <int>[],
      teachBackResponse: '',
    );
  }

  String toJsonString() {
    return jsonEncode(<String, Object?>{
      'skillCardFingerprint': skillCardFingerprint,
      'completedStepIndexes': completedStepIndexes,
      'teachBackResponse': teachBackResponse,
      'completedAtIso8601': completedAtIso8601,
    });
  }

  static LearningProgress? fromJsonString(String? source) {
    if (source == null || source.trim().isEmpty) {
      return null;
    }

    try {
      final Object? decoded = jsonDecode(source);

      if (decoded is! Map<String, dynamic>) {
        return null;
      }

      final Object? fingerprintValue = decoded['skillCardFingerprint'];

      final Object? completedIndexesValue = decoded['completedStepIndexes'];

      final Object? responseValue = decoded['teachBackResponse'];

      final Object? completedAtValue = decoded['completedAtIso8601'];

      if (fingerprintValue is! String ||
          completedIndexesValue is! List<dynamic> ||
          responseValue is! String) {
        return null;
      }

      final String fingerprint = fingerprintValue.trim();
      final String response = responseValue.trim();

      if (fingerprint.isEmpty ||
          fingerprint.length > maximumFingerprintLength ||
          response.length > maximumTeachBackLength) {
        return null;
      }

      final Set<int> uniqueIndexes = <int>{};

      for (final Object? value in completedIndexesValue) {
        if (value is! int || value < 0 || value >= stepCount) {
          return null;
        }

        uniqueIndexes.add(value);
      }

      if (uniqueIndexes.length != completedIndexesValue.length) {
        return null;
      }

      final List<int> sortedIndexes = uniqueIndexes.toList()..sort();

      String? completedAtIso8601;

      if (completedAtValue != null) {
        if (completedAtValue is! String) {
          return null;
        }

        final DateTime? parsedDate = DateTime.tryParse(completedAtValue);

        if (parsedDate == null) {
          return null;
        }

        completedAtIso8601 = parsedDate.toUtc().toIso8601String();
      }

      final bool allStepsCompleted = sortedIndexes.length == stepCount;

      final bool validTeachBack = response.length >= minimumTeachBackLength;

      if (completedAtIso8601 != null &&
          (!allStepsCompleted || !validTeachBack)) {
        return null;
      }

      return LearningProgress(
        skillCardFingerprint: fingerprint,
        completedStepIndexes: sortedIndexes,
        teachBackResponse: response,
        completedAtIso8601: completedAtIso8601,
      );
    } on FormatException {
      return null;
    }
  }

  @override
  bool operator ==(Object other) {
    return other is LearningProgress &&
        other.skillCardFingerprint == skillCardFingerprint &&
        _listEquals(other.completedStepIndexes, completedStepIndexes) &&
        other.teachBackResponse == teachBackResponse &&
        other.completedAtIso8601 == completedAtIso8601;
  }

  @override
  int get hashCode {
    return Object.hash(
      skillCardFingerprint,
      Object.hashAll(completedStepIndexes),
      teachBackResponse,
      completedAtIso8601,
    );
  }

  static bool _listEquals(List<int> first, List<int> second) {
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
