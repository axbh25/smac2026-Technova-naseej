import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naseej/app.dart';

Future<void> pumpReferenceApp(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(412, 892));

  addTearDown(() async {
    await tester.binding.setSurfaceSize(null);
  });

  await tester.pumpWidget(const NaseejApp());
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows the English Welcome screen by default', (
    WidgetTester tester,
  ) async {
    await pumpReferenceApp(tester);

    expect(
      find.byKey(const ValueKey<String>('welcome_screen')),
      findsOneWidget,
    );
    expect(find.text('Naseej'), findsOneWidget);
    expect(
      find.text('Every generation teaches. Every generation learns.'),
      findsOneWidget,
    );
    expect(find.text('Private by design'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('switches to Arabic and uses RTL direction', (
    WidgetTester tester,
  ) async {
    await pumpReferenceApp(tester);

    await tester.tap(find.byKey(const ValueKey<String>('language_ar_button')));
    await tester.pumpAndSettle();

    expect(find.text('كل جيل يعلّم، وكل جيل يتعلّم.'), findsOneWidget);
    expect(find.text('الخصوصية أولًا'), findsOneWidget);
    expect(find.text('متابعة'), findsOneWidget);

    final BuildContext welcomeContext = tester.element(
      find.byKey(const ValueKey<String>('welcome_screen')),
    );

    expect(Directionality.of(welcomeContext), TextDirection.rtl);
  });

  testWidgets('Continue button gives honest temporary feedback', (
    WidgetTester tester,
  ) async {
    await pumpReferenceApp(tester);

    await tester.tap(find.byKey(const ValueKey<String>('continue_button')));
    await tester.pump();

    expect(
      find.text('Profile setup will be added in the next build.'),
      findsOneWidget,
    );
  });

  testWidgets('Welcome screen meets basic accessibility guidelines', (
    WidgetTester tester,
  ) async {
    final SemanticsHandle semanticsHandle = tester.ensureSemantics();

    try {
      await pumpReferenceApp(tester);

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
    } finally {
      semanticsHandle.dispose();
    }
  });
}
