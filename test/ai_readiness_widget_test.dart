import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naseej/core/ai/ai_readiness_controller.dart';
import 'package:naseej/core/ai/ai_readiness_service.dart';
import 'package:naseej/core/theme/app_theme.dart';
import 'package:naseej/features/home/presentation/widgets/ai_readiness_card.dart';
import 'package:naseej/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'support/fake_ai_readiness_service.dart';

Future<AiReadinessController> pumpAiCard(
  WidgetTester tester, {
  required Locale locale,
  required AiReadinessResult result,
}) async {
  await tester.binding.setSurfaceSize(const Size(412, 892));

  addTearDown(() async {
    await tester.binding.setSurfaceSize(null);
  });

  final AiReadinessController controller = AiReadinessController(
    FakeAiReadinessService(result: result),
  );

  addTearDown(controller.dispose);

  await tester.pumpWidget(
    ChangeNotifierProvider<AiReadinessController>.value(
      value: controller,
      child: MaterialApp(
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.light,
        home: const Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: AiReadinessCard(),
            ),
          ),
        ),
      ),
    ),
  );

  await tester.pumpAndSettle();

  return controller;
}

void main() {
  testWidgets('AI readiness card shows a successful connection', (
    WidgetTester tester,
  ) async {
    await pumpAiCard(
      tester,
      locale: const Locale('en'),
      result: const AiReadinessResult.ready('gemini-2.5-flash-lite'),
    );

    expect(
      find.byKey(const ValueKey<String>('ai_status_idle')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey<String>('ai_check_button')));

    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey<String>('ai_status_ready')),
      findsOneWidget,
    );

    expect(find.text('Model: gemini-2.5-flash-lite'), findsOneWidget);
  });

  testWidgets('AI readiness card shows the offline fallback', (
    WidgetTester tester,
  ) async {
    await pumpAiCard(
      tester,
      locale: const Locale('en'),
      result: const AiReadinessResult.failed(
        AiReadinessFailure.offlineOrTimeout,
      ),
    );

    await tester.tap(find.byKey(const ValueKey<String>('ai_check_button')));

    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey<String>('ai_status_unavailable')),
      findsOneWidget,
    );

    expect(find.textContaining('locally saved draft'), findsOneWidget);
  });

  testWidgets('Arabic AI readiness card uses RTL', (WidgetTester tester) async {
    await pumpAiCard(
      tester,
      locale: const Locale('ar'),
      result: const AiReadinessResult.ready('gemini-2.5-flash-lite'),
    );

    expect(find.text('التحقق من اتصال الذكاء الاصطناعي'), findsOneWidget);

    final BuildContext cardContext = tester.element(
      find.byKey(const ValueKey<String>('ai_readiness_card')),
    );

    expect(Directionality.of(cardContext), TextDirection.rtl);
  });
}
