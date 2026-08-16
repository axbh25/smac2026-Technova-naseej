import 'package:flutter/material.dart';
import 'package:naseej/core/state/app_controller.dart';
import 'package:naseej/features/demo/presentation/demo_data_screen.dart';
import 'package:naseej/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class DataToolsButton extends StatelessWidget {
  const DataToolsButton({
    this.expanded = false,
    this.enabled = true,
    super.key,
  });

  final bool expanded;
  final bool enabled;

  Future<void> _open(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return const DemoDataScreen();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppController controller = context.watch<AppController>();

    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final bool hasWarning = controller.recoveryNotice != AppRecoveryNotice.none;

    final IconData icon = hasWarning
        ? Icons.warning_amber_rounded
        : Icons.storage_rounded;

    if (expanded) {
      return SizedBox(
        width: double.infinity,
        height: 56,
        child: OutlinedButton.icon(
          key: const ValueKey<String>('data_tools_expanded_button'),
          onPressed: enabled
              ? () async {
                  await _open(context);
                }
              : null,
          icon: Icon(icon),
          label: Text(localizations.demoDataWelcomeLabel),
        ),
      );
    }

    return IconButton(
      key: const ValueKey<String>('data_tools_button'),
      tooltip: localizations.demoDataTooltip,
      onPressed: enabled
          ? () async {
              await _open(context);
            }
          : null,
      icon: Icon(icon),
    );
  }
}
