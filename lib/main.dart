import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:naseej/app.dart';
import 'package:naseej/core/ai/ai_readiness_controller.dart';
import 'package:naseej/core/ai/ai_readiness_service.dart';
import 'package:naseej/core/ai/firebase_ai_readiness_service.dart';
import 'package:naseej/core/ai/firebase_skill_card_generation_service.dart';
import 'package:naseej/core/ai/offline_skill_card_factory.dart';
import 'package:naseej/core/ai/skill_card_generation_controller.dart';
import 'package:naseej/core/ai/skill_card_generation_service.dart';
import 'package:naseej/core/ai/unavailable_ai_readiness_service.dart';
import 'package:naseej/core/ai/unavailable_skill_card_generation_service.dart';
import 'package:naseej/core/speech/device_speech_engine.dart';
import 'package:naseej/core/speech/speech_controller.dart';
import 'package:naseej/core/state/app_controller.dart';
import 'package:naseej/core/storage/shared_preferences_app_storage.dart';
import 'package:naseej/core/tts/device_text_to_speech_engine.dart';
import 'package:naseej/core/tts/text_to_speech_controller.dart';
import 'package:naseej/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final AppController appController = AppController(
    SharedPreferencesAppStorage(),
  );

  await appController.initialize();

  final _AiServices aiServices = await _initializeFirebaseAi();

  runApp(
    MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<AppController>.value(value: appController),
        ChangeNotifierProvider<SpeechController>(
          create: (_) {
            return SpeechController(DeviceSpeechEngine());
          },
        ),
        ChangeNotifierProvider<TextToSpeechController>(
          create: (_) {
            return TextToSpeechController(DeviceTextToSpeechEngine());
          },
        ),
        ChangeNotifierProvider<AiReadinessController>(
          create: (_) {
            return AiReadinessController(aiServices.readinessService);
          },
        ),
        ChangeNotifierProvider<SkillCardGenerationController>(
          create: (_) {
            return SkillCardGenerationController(
              aiServices.generationService,
              const OfflineSkillCardFactory(),
            );
          },
        ),
      ],
      child: const NaseejApp(),
    ),
  );
}

Future<_AiServices> _initializeFirebaseAi() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await FirebaseAppCheck.instance.activate(
      providerAndroid: kDebugMode
          ? const AndroidDebugProvider()
          : const AndroidPlayIntegrityProvider(),
    );

    final FirebaseAI firebaseAI = FirebaseAI.googleAI();

    return _AiServices(
      readinessService: FirebaseAiReadinessService(firebaseAI: firebaseAI),
      generationService: FirebaseSkillCardGenerationService(
        firebaseAI: firebaseAI,
      ),
    );
  } catch (_) {
    return const _AiServices(
      readinessService: UnavailableAiReadinessService(
        AiReadinessFailure.firebaseNotConfigured,
      ),
      generationService: UnavailableSkillCardGenerationService(
        SkillCardGenerationFailure.firebaseNotConfigured,
      ),
    );
  }
}

class _AiServices {
  const _AiServices({
    required this.readinessService,
    required this.generationService,
  });

  final AiReadinessService readinessService;
  final SkillCardGenerationService generationService;
}
