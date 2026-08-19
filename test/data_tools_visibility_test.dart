import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naseej/core/state/app_controller.dart';
import 'package:naseej/core/theme/app_theme.dart';
import 'package:naseej/core/widgets/language_toggle_button.dart';
import 'package:naseej/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'support/fake_app_storage.dart';

class _RootRouteScreen extends StatelessWidget {
  const _RootRouteScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Root'),
        actions: const <Widget>[LanguageToggleButton()],
      ),
      body: Center(
        child: FilledButton(
          key: const ValueKey<String>('open_nested_route_button'),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return const _NestedRouteScreen();
                },
              ),
            );
          },
          child: const Text('Open nested route'),
        ),
      ),
    );
  }
}

class _NestedRouteScreen extends StatelessWidget {
  const _NestedRouteScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nested'),
        actions: const <Widget>[LanguageToggleButton()],
      ),
      body: const Center(child: Text('Nested screen')),
    );
  }
}

void main() {
  testWidgets('Data Tools appears on root route but not nested route', (
    WidgetTester tester,
  ) async {
    final AppController controller = AppController(
      FakeAppStorage(localeCode: 'en'),
    );

    await controller.initialize();

    addTearDown(controller.dispose);

    await tester.pumpWidget(
      ChangeNotifierProvider<AppController>.value(
        value: controller,
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.light,
          home: const _RootRouteScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey<String>('data_tools_button')),
      findsOneWidget,
    );

    expect(
      find.byKey(const ValueKey<String>('language_toggle_button')),
      findsOneWidget,
    );

    await tester.tap(
      find.byKey(const ValueKey<String>('open_nested_route_button')),
    );

    await tester.pumpAndSettle();

    expect(find.text('Nested screen'), findsOneWidget);

    expect(
      find.byKey(const ValueKey<String>('data_tools_button')),
      findsNothing,
    );

    expect(
      find.byKey(const ValueKey<String>('language_toggle_button')),
      findsOneWidget,
    );
  });
}
