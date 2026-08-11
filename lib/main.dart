import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:naseej/app.dart';
import 'package:naseej/core/ai/ai_readiness_controller.dart';
import 'package:naseej/core/ai/ai_readiness_service.dart';
import 'package:naseej/core/ai/firebase_ai_readiness_service.dart';
import 'package:naseej/core/ai/unavailable_ai_readiness_service.dart';
import 'package:naseej/core/speech/device_speech_engine.dart';
import 'package:naseej/core/speech/speech_controller.dart';
import 'package:naseej/core/state/app_controller.dart';
import 'package:naseej/core/storage/shared_preferences_app_storage.dart';
import 'package:naseej/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final AppController appController = AppController(
    SharedPreferencesAppStorage(),
  );

  await appController.initialize();

  final AiReadinessService aiReadinessService = await _initializeFirebaseAi();

  runApp(
    MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<AppController>.value(value: appController),
        ChangeNotifierProvider<SpeechController>(
          create: (_) {
            return SpeechController(DeviceSpeechEngine());
          },
        ),
        ChangeNotifierProvider<AiReadinessController>(
          create: (_) {
            return AiReadinessController(aiReadinessService);
          },
        ),
      ],
      child: const NaseejApp(),
    ),
  );
}

Future<AiReadinessService> _initializeFirebaseAi() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await FirebaseAppCheck.instance.activate(
      providerAndroid: kDebugMode
          ? const AndroidDebugProvider()
          : const AndroidPlayIntegrityProvider(),
    );

    return FirebaseAiReadinessService();
  } catch (_) {
    return const UnavailableAiReadinessService(
      AiReadinessFailure.firebaseNotConfigured,
    );
  }
}
