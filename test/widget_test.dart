import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naseej/app.dart';
import 'package:naseej/core/state/app_controller.dart';
import 'package:naseej/features/profile/domain/family_profile.dart';
import 'package:provider/provider.dart';

import 'support/fake_app_storage.dart';

Future<AppController> pumpReferenceApp(
  WidgetTester tester, {
  FakeAppStorage? storage,
}) async {
  await tester.binding.setSurfaceSize(const Size(412, 892));

  addTearDown(() async {
    await tester.binding.setSurfaceSize(null);
  });

  final AppController controller = AppController(storage ?? FakeAppStorage());

  await controller.initialize();

  addTearDown(controller.dispose);

  await tester.pumpWidget(
    ChangeNotifierProvider<AppController>.value(
      value: controller,
      child: const NaseejApp(),
    ),
  );

  await tester.pumpAndSettle();

  return controller;
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
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('switches to Arabic and stores the locale', (
    WidgetTester tester,
  ) async {
    final FakeAppStorage storage = FakeAppStorage();

    await pumpReferenceApp(tester, storage: storage);

    await tester.tap(find.byKey(const ValueKey<String>('language_ar_button')));

    await tester.pumpAndSettle();

    expect(find.text('كل جيل يعلّم، وكل جيل يتعلّم.'), findsOneWidget);

    expect(storage.localeCode, 'ar');

    final BuildContext welcomeContext = tester.element(
      find.byKey(const ValueKey<String>('welcome_screen')),
    );

    expect(Directionality.of(welcomeContext), TextDirection.rtl);
  });

  testWidgets('Continue opens Profile Setup', (WidgetTester tester) async {
    await pumpReferenceApp(tester);

    await tester.tap(find.byKey(const ValueKey<String>('continue_button')));

    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey<String>('profile_setup_screen')),
      findsOneWidget,
    );

    expect(find.text('Create your local profile'), findsOneWidget);
  });

  testWidgets('profile save requires both nickname and role', (
    WidgetTester tester,
  ) async {
    await pumpReferenceApp(tester);

    await tester.tap(find.byKey(const ValueKey<String>('continue_button')));

    await tester.pumpAndSettle();

    FilledButton saveButton = tester.widget<FilledButton>(
      find.byKey(const ValueKey<String>('save_profile_button')),
    );

    expect(saveButton.onPressed, isNull);

    await tester.enterText(
      find.byKey(const ValueKey<String>('nickname_field')),
      'Fatima',
    );

    await tester.pump();

    saveButton = tester.widget<FilledButton>(
      find.byKey(const ValueKey<String>('save_profile_button')),
    );

    expect(saveButton.onPressed, isNull);

    await tester.tap(find.byKey(const ValueKey<String>('role_grandparent')));

    await tester.pump();

    saveButton = tester.widget<FilledButton>(
      find.byKey(const ValueKey<String>('save_profile_button')),
    );

    expect(saveButton.onPressed, isNotNull);
  });

  testWidgets('saves a profile and opens Home', (WidgetTester tester) async {
    final FakeAppStorage storage = FakeAppStorage();

    await pumpReferenceApp(tester, storage: storage);

    await tester.tap(find.byKey(const ValueKey<String>('continue_button')));

    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey<String>('nickname_field')),
      'Fatima',
    );

    await tester.pump();

    await tester.tap(find.byKey(const ValueKey<String>('role_grandparent')));

    // Allow setState to rebuild the Save Profile button as enabled.
    await tester.pump();

    await tester.tap(find.byKey(const ValueKey<String>('save_profile_button')));

    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey<String>('home_screen')), findsOneWidget);

    expect(find.text('Hello, Fatima'), findsOneWidget);

    expect(storage.profileJson, isNotNull);
  });

  testWidgets('restores a saved Arabic profile on startup', (
    WidgetTester tester,
  ) async {
    const FamilyProfile profile = FamilyProfile(
      nickname: 'فاطمة',
      role: FamilyRole.grandparent,
    );

    final FakeAppStorage storage = FakeAppStorage(
      localeCode: 'ar',
      profileJson: profile.toJsonString(),
    );

    await pumpReferenceApp(tester, storage: storage);

    expect(find.byKey(const ValueKey<String>('home_screen')), findsOneWidget);

    expect(find.text('مرحبًا، فاطمة'), findsOneWidget);
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
