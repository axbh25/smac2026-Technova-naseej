import 'package:flutter/material.dart';
import 'package:naseej/core/state/app_controller.dart';
import 'package:naseej/core/theme/app_theme.dart';
import 'package:naseej/features/home/presentation/home_screen.dart';
import 'package:naseej/features/profile/presentation/profile_setup_screen.dart';
import 'package:naseej/features/welcome/presentation/welcome_screen.dart';
import 'package:naseej/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class NaseejApp extends StatelessWidget {
  const NaseejApp({super.key});

  @override
  Widget build(BuildContext context) {
    final AppController controller = context.watch<AppController>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: controller.locale,
      onGenerateTitle: (BuildContext context) {
        return AppLocalizations.of(context)!.appTitle;
      },
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light,
      home: const _AppGate(),
    );
  }
}

class _AppGate extends StatelessWidget {
  const _AppGate();

  @override
  Widget build(BuildContext context) {
    final AppController controller = context.watch<AppController>();

    if (controller.hasProfile) {
      return const HomeScreen();
    }

    return WelcomeScreen(
      selectedLanguageCode: controller.locale.languageCode,
      onLocaleChanged: controller.setLocale,
      onContinue: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) {
              return const ProfileSetupScreen();
            },
          ),
        );
      },
    );
  }
}
