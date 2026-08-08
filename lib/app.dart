import 'package:flutter/material.dart';
import 'package:naseej/core/theme/app_theme.dart';
import 'package:naseej/features/welcome/presentation/welcome_screen.dart';
import 'package:naseej/l10n/app_localizations.dart';

class NaseejApp extends StatefulWidget {
  const NaseejApp({super.key});

  @override
  State<NaseejApp> createState() => _NaseejAppState();
}

class _NaseejAppState extends State<NaseejApp> {
  Locale _locale = const Locale('en');

  void _setLocale(Locale locale) {
    if (_locale == locale) {
      return;
    }

    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: _locale,
      onGenerateTitle: (BuildContext context) {
        return AppLocalizations.of(context)!.appTitle;
      },
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light,
      home: WelcomeScreen(
        selectedLanguageCode: _locale.languageCode,
        onLocaleChanged: _setLocale,
      ),
    );
  }
}
