import 'dart:async';
import 'dart:io';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:naseej/core/ai/ai_readiness_service.dart';

class FirebaseAiReadinessService implements AiReadinessService {
  FirebaseAiReadinessService({FirebaseAI? firebaseAI})
    : _model = (firebaseAI ?? FirebaseAI.googleAI()).generativeModel(
        model: modelName,
        systemInstruction: Content.system(
          'You are a private connectivity test. '
          'Return only NASEEJ_READY and no other text.',
        ),
        generationConfig: GenerationConfig(temperature: 0, maxOutputTokens: 16),
      );

  static const String modelName = 'gemini-3.5-flash-lite';

  static const Duration _timeout = Duration(seconds: 60);

  final GenerativeModel _model;

  @override
  Future<AiReadinessResult> checkReadiness() async {
    try {
      debugPrint('AI readiness: starting request with model $modelName');

      final GenerateContentResponse response = await _model
          .generateContent(<Content>[
            Content.text('Return exactly NASEEJ_READY.'),
          ])
          .timeout(_timeout);

      final String responseText = response.text?.trim() ?? '';

      debugPrint('AI readiness: response received: $responseText');

      final String normalizedResponse = responseText.toUpperCase().replaceAll(
        RegExp(r'[^A-Z_]'),
        '',
      );

      if (normalizedResponse == 'NASEEJ_READY') {
        debugPrint('AI readiness: SUCCESS');

        return const AiReadinessResult.ready(modelName);
      }

      debugPrint('AI readiness: invalid response: $normalizedResponse');

      return const AiReadinessResult.failed(AiReadinessFailure.invalidResponse);
    } on TimeoutException catch (error, stackTrace) {
      debugPrint('AI readiness TimeoutException: $error');
      debugPrintStack(stackTrace: stackTrace);

      return const AiReadinessResult.failed(
        AiReadinessFailure.offlineOrTimeout,
      );
    } on SocketException catch (error, stackTrace) {
      debugPrint('AI readiness SocketException: $error');
      debugPrintStack(stackTrace: stackTrace);

      return const AiReadinessResult.failed(
        AiReadinessFailure.offlineOrTimeout,
      );
    } on QuotaExceeded catch (error, stackTrace) {
      debugPrint('AI readiness QuotaExceeded: $error');
      debugPrintStack(stackTrace: stackTrace);

      return const AiReadinessResult.failed(AiReadinessFailure.quotaExceeded);
    } on ServiceApiNotEnabled catch (error, stackTrace) {
      debugPrint('AI readiness ServiceApiNotEnabled: $error');
      debugPrintStack(stackTrace: stackTrace);

      return const AiReadinessResult.failed(
        AiReadinessFailure.serviceNotEnabled,
      );
    } on InvalidApiKey catch (error, stackTrace) {
      debugPrint('AI readiness InvalidApiKey: $error');
      debugPrintStack(stackTrace: stackTrace);

      return const AiReadinessResult.failed(
        AiReadinessFailure.firebaseNotConfigured,
      );
    } on ServerException catch (error, stackTrace) {
      debugPrint(
        'AI readiness ServerException: '
        '${error.runtimeType}: ${error.message}',
      );
      debugPrintStack(stackTrace: stackTrace);

      return _mapMessage(error.message);
    } on FirebaseException catch (error, stackTrace) {
      final String details = '${error.code} ${error.message ?? ''}';

      debugPrint(
        'AI readiness FirebaseException: '
        '${error.runtimeType}: $details',
      );
      debugPrintStack(stackTrace: stackTrace);

      return _mapMessage(details);
    } on FirebaseAIException catch (error, stackTrace) {
      debugPrint(
        'AI readiness FirebaseAIException: '
        '${error.runtimeType}: $error',
      );
      debugPrintStack(stackTrace: stackTrace);

      return _mapMessage(error.toString());
    } catch (error, stackTrace) {
      debugPrint(
        'AI readiness unexpected error: '
        '${error.runtimeType}: $error',
      );
      debugPrintStack(stackTrace: stackTrace);

      return const AiReadinessResult.failed(AiReadinessFailure.unknown);
    }
  }

  AiReadinessResult _mapMessage(String message) {
    final String normalized = message.toLowerCase();

    if (normalized.contains('app check') ||
        normalized.contains('appcheck') ||
        normalized.contains('attestation')) {
      return const AiReadinessResult.failed(
        AiReadinessFailure.appCheckRejected,
      );
    }

    if (normalized.contains('network') ||
        normalized.contains('offline') ||
        normalized.contains('unreachable') ||
        normalized.contains('failed host lookup') ||
        normalized.contains('timeout')) {
      return const AiReadinessResult.failed(
        AiReadinessFailure.offlineOrTimeout,
      );
    }

    if (normalized.contains('quota') ||
        normalized.contains('resource_exhausted') ||
        normalized.contains('resource exhausted')) {
      return const AiReadinessResult.failed(AiReadinessFailure.quotaExceeded);
    }

    if (normalized.contains('not enabled') ||
        normalized.contains('api_disabled') ||
        normalized.contains('genai config not found')) {
      return const AiReadinessResult.failed(
        AiReadinessFailure.serviceNotEnabled,
      );
    }

    if (normalized.contains('api key not valid') ||
        normalized.contains('invalid api key')) {
      return const AiReadinessResult.failed(
        AiReadinessFailure.firebaseNotConfigured,
      );
    }

    return const AiReadinessResult.failed(AiReadinessFailure.unknown);
  }
}
