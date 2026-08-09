import 'package:flutter/material.dart';
import 'package:naseej/app.dart';
import 'package:naseej/core/state/app_controller.dart';
import 'package:naseej/core/storage/shared_preferences_app_storage.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final AppController appController = AppController(
    SharedPreferencesAppStorage(),
  );

  await appController.initialize();

  runApp(
    ChangeNotifierProvider<AppController>.value(
      value: appController,
      child: const NaseejApp(),
    ),
  );
}
