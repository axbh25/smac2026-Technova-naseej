import 'package:flutter/material.dart';
import 'package:naseej/core/state/app_controller.dart';
import 'package:naseej/core/widgets/data_tools_button.dart';
import 'package:naseej/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class LanguageToggleButton extends StatelessWidget {
  const LanguageToggleButton({this.enabled = true, super.key});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final AppController controller = context.watch<AppController>();

    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        DataToolsButton(enabled: enabled),
        IconButton(
          key: const ValueKey<String>('language_toggle_button'),
          tooltip: localizations.changeLanguageLabel,
          icon: const Icon(Icons.language_rounded),
          onPressed: enabled
              ? () async {
                  final Locale nextLocale =
                      controller.locale.languageCode == 'en'
                      ? const Locale('ar')
                      : const Locale('en');

                  await controller.setLocale(nextLocale);
                }
              : null,
        ),
      ],
    );
  }
}
