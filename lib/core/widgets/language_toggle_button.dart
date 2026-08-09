import 'package:flutter/material.dart';
import 'package:naseej/core/state/app_controller.dart';
import 'package:naseej/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class LanguageToggleButton extends StatelessWidget {
  const LanguageToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final AppController controller = context.watch<AppController>();
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return IconButton(
      key: const ValueKey<String>('language_toggle_button'),
      tooltip: localizations.changeLanguageLabel,
      icon: const Icon(Icons.language_rounded),
      onPressed: () async {
        final Locale nextLocale = controller.locale.languageCode == 'en'
            ? const Locale('ar')
            : const Locale('en');

        await controller.setLocale(nextLocale);
      },
    );
  }
}
