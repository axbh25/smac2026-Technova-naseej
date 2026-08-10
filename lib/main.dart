import 'package:flutter/material.dart';
import 'package:naseej/app.dart';
import 'package:naseej/core/speech/device_speech_engine.dart';
import 'package:naseej/core/speech/speech_controller.dart';
import 'package:naseej/core/state/app_controller.dart';
import 'package:naseej/core/storage/shared_preferences_app_storage.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final AppController appController = AppController(
    SharedPreferencesAppStorage(),
  );

  await appController.initialize();

  runApp(
    MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<AppController>.value(value: appController),
        ChangeNotifierProvider<SpeechController>(
          create: (_) {
            return SpeechController(DeviceSpeechEngine());
          },
        ),
      ],
      child: const NaseejApp(),
    ),
  );
}
