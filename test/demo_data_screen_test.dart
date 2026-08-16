import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naseej/core/state/app_controller.dart';
import 'package:naseej/core/theme/app_theme.dart';
import 'package:naseej/features/demo/presentation/demo_data_screen.dart';
import 'package:naseej/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'support/fake_app_storage.dart';
import 'support/fake_context_photo_service.dart';

Future<AppController> pumpDemoScreen(
  WidgetTester tester, {
  Locale locale = const Locale('en'),
}) async {
  await tester.binding.setSurfaceSize(const Size(412, 892));

  addTearDown(() async {
    await tester.binding.setSurfaceSize(null);
  });

  final FakeAppStorage storage = FakeAppStorage(
    localeCode: locale.languageCode,
  );

  final AppController controller = AppController(storage);

  await controller.initialize();

  addTearDown(controller.dispose);

  await tester.pumpWidget(
    ChangeNotifierProvider<AppController>.value(
      value: controller,
      child: MaterialApp(
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.light,
        home: DemoDataScreen(contextPhotoService: FakeContextPhotoService()),
      ),
    ),
  );

  await tester.pumpAndSettle();

  return controller;
}

Future<void> scrollToWidget(
  WidgetTester tester,
  Finder target, {
  double delta = 300,
}) async {
  final Finder scrollable = find.byType(Scrollable).first;

  await tester.scrollUntilVisible(target, delta, scrollable: scrollable);

  await tester.pumpAndSettle();

  expect(target, findsOneWidget);
}

void main() {
  testWidgets('completed local sample loads a full Family Thread', (
    WidgetTester tester,
  ) async {
    final AppController controller = await pumpDemoScreen(tester);

    final Finder button = find.byKey(
      const ValueKey<String>('load_completed_demo_button'),
    );

    await scrollToWidget(tester, button);

    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(controller.profile, isNotNull);

    expect(controller.skillDraft, isNotNull);

    expect(controller.skillCard, isNotNull);

    expect(controller.learningProgress?.isExchangeCompleted, isTrue);
  });

  testWidgets('reset confirmation clears family data but keeps locale', (
    WidgetTester tester,
  ) async {
    final AppController controller = await pumpDemoScreen(tester);

    final Finder loadButton = find.byKey(
      const ValueKey<String>('load_completed_demo_button'),
    );

    await scrollToWidget(tester, loadButton);

    await tester.tap(loadButton);
    await tester.pumpAndSettle();

    final Finder resetButton = find.byKey(
      const ValueKey<String>('reset_local_data_button'),
    );

    await scrollToWidget(tester, resetButton);

    await tester.tap(resetButton);
    await tester.pumpAndSettle();

    final Finder confirmButton = find.byKey(
      const ValueKey<String>('confirm_reset_data_button'),
    );

    expect(confirmButton, findsOneWidget);

    await tester.tap(confirmButton);
    await tester.pumpAndSettle();

    expect(controller.profile, isNull);

    expect(controller.skillDraft, isNull);

    expect(controller.skillCard, isNull);

    expect(controller.learningProgress, isNull);

    expect(controller.locale.languageCode, 'en');
  });

  testWidgets('Arabic Data Tools screen uses RTL', (WidgetTester tester) async {
    await pumpDemoScreen(tester, locale: const Locale('ar'));

    final BuildContext screenContext = tester.element(
      find.byKey(const ValueKey<String>('demo_data_screen')),
    );

    expect(Directionality.of(screenContext), TextDirection.rtl);

    expect(find.text('العرض والبيانات المحلية'), findsOneWidget);
  });
}
