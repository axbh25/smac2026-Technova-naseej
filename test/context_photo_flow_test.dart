import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naseej/core/photo/context_photo_service.dart';
import 'package:naseej/core/speech/speech_controller.dart';
import 'package:naseej/core/state/app_controller.dart';
import 'package:naseej/core/theme/app_theme.dart';
import 'package:naseej/features/profile/domain/family_profile.dart';
import 'package:naseej/features/skill/domain/skill_draft.dart';
import 'package:naseej/features/skill/presentation/teach_skill_screen.dart';
import 'package:naseej/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'support/fake_app_storage.dart';
import 'support/fake_context_photo_service.dart';
import 'support/fake_speech_engine.dart';

class PhotoFlowHarness {
  const PhotoFlowHarness({
    required this.storage,
    required this.appController,
    required this.photoService,
  });

  final FakeAppStorage storage;
  final AppController appController;
  final FakeContextPhotoService photoService;
}

Future<PhotoFlowHarness> pumpPhotoFlow(
  WidgetTester tester, {
  SkillDraft? initialDraft,
  FakeContextPhotoService? photoService,
}) async {
  await tester.binding.setSurfaceSize(const Size(412, 892));

  addTearDown(() async {
    await tester.binding.setSurfaceSize(null);
  });

  const FamilyProfile profile = FamilyProfile(
    nickname: 'Fatima',
    role: FamilyRole.grandparent,
  );

  final FakeAppStorage storage = FakeAppStorage(
    localeCode: 'en',
    profileJson: profile.toJsonString(),
    skillDraftJson: initialDraft?.toJsonString(),
  );

  final AppController appController = AppController(storage);

  await appController.initialize();

  final SpeechController speechController = SpeechController(
    FakeSpeechEngine(),
  );

  final FakeContextPhotoService activePhotoService =
      photoService ?? FakeContextPhotoService();

  addTearDown(appController.dispose);
  addTearDown(speechController.dispose);

  await tester.pumpWidget(
    MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<AppController>.value(value: appController),
        ChangeNotifierProvider<SpeechController>.value(value: speechController),
      ],
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.light,
        home: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              body: Center(
                child: FilledButton(
                  key: const ValueKey<String>('open_photo_test_screen'),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) {
                          return TeachSkillScreen(
                            teacher: profile,
                            initialDraft: appController.skillDraft,
                            contextPhotoService: activePhotoService,
                          );
                        },
                      ),
                    );
                  },
                  child: const Text('Open'),
                ),
              ),
            );
          },
        ),
      ),
    ),
  );

  await tester.pumpAndSettle();

  await tester.tap(
    find.byKey(const ValueKey<String>('open_photo_test_screen')),
  );

  await tester.pumpAndSettle();

  return PhotoFlowHarness(
    storage: storage,
    appController: appController,
    photoService: activePhotoService,
  );
}

Future<void> completeRequiredDraftFields(WidgetTester tester) async {
  final Finder learnerField = find.byKey(
    const ValueKey<String>('learner_nickname_field'),
  );

  await tester.ensureVisible(learnerField);
  await tester.enterText(learnerField, 'Mariam');

  final Finder roleCard = find.byKey(
    const ValueKey<String>('learner_role_teen'),
  );

  await tester.ensureVisible(roleCard);
  await tester.tap(roleCard);
  await tester.pump();

  final Finder categoryCard = find.byKey(
    const ValueKey<String>('category_heritage'),
  );

  await tester.ensureVisible(categoryCard);
  await tester.tap(categoryCard);
  await tester.pump();

  final Finder explanationField = find.byKey(
    const ValueKey<String>('explanation_field'),
  );

  await tester.ensureVisible(explanationField);

  await tester.enterText(
    explanationField,
    'Explain how our family welcomes guests with patience and care.',
  );

  await tester.pump();
}

void main() {
  testWidgets('camera photo is saved inside the skill draft', (
    WidgetTester tester,
  ) async {
    final FakeContextPhotoService photoService = FakeContextPhotoService(
      nextPickResult: const ContextPhotoResult.selected(
        '/private/context_photos/camera.jpg',
      ),
    );

    final PhotoFlowHarness harness = await pumpPhotoFlow(
      tester,
      photoService: photoService,
    );

    final Finder addButton = find.byKey(
      const ValueKey<String>('add_context_photo_button'),
    );

    await tester.ensureVisible(addButton);
    await tester.tap(addButton);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey<String>('take_photo_option')));

    await tester.pumpAndSettle();

    expect(photoService.requestedSources, <ContextPhotoSource>[
      ContextPhotoSource.camera,
    ]);

    expect(
      find.byKey(const ValueKey<String>('context_photo_selected')),
      findsOneWidget,
    );

    await completeRequiredDraftFields(tester);

    final Finder saveButton = find.byKey(
      const ValueKey<String>('save_draft_button'),
    );

    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    final SkillDraft? storedDraft = SkillDraft.fromJsonString(
      harness.storage.skillDraftJson,
    );

    expect(storedDraft?.contextPhotoPath, '/private/context_photos/camera.jpg');
  });

  testWidgets('removing an existing photo clears and deletes it after saving', (
    WidgetTester tester,
  ) async {
    const String oldPath = '/private/context_photos/old.jpg';

    const SkillDraft initialDraft = SkillDraft(
      teacherNickname: 'Fatima',
      teacherRole: FamilyRole.grandparent,
      learnerNickname: 'Mariam',
      learnerRole: FamilyRole.teen,
      category: SkillCategory.heritage,
      explanation:
          'Explain how our family welcomes guests with patience and care.',
      contextPhotoPath: oldPath,
    );

    final PhotoFlowHarness harness = await pumpPhotoFlow(
      tester,
      initialDraft: initialDraft,
    );

    final Finder removeButton = find.byKey(
      const ValueKey<String>('remove_context_photo_button'),
    );

    await tester.ensureVisible(removeButton);
    await tester.tap(removeButton);
    await tester.pump();

    final Finder saveButton = find.byKey(
      const ValueKey<String>('save_draft_button'),
    );

    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    final SkillDraft? storedDraft = SkillDraft.fromJsonString(
      harness.storage.skillDraftJson,
    );

    expect(storedDraft?.contextPhotoPath, isNull);

    expect(harness.photoService.deletedPaths, contains(oldPath));
  });

  testWidgets('lost picker result is recovered when the form opens', (
    WidgetTester tester,
  ) async {
    final FakeContextPhotoService photoService = FakeContextPhotoService(
      recoveredResult: const ContextPhotoResult.selected(
        '/private/context_photos/recovered.jpg',
      ),
    );

    await pumpPhotoFlow(tester, photoService: photoService);

    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey<String>('context_photo_selected')),
      findsOneWidget,
    );
  });

  testWidgets('cancelled picker keeps the existing photo', (
    WidgetTester tester,
  ) async {
    const SkillDraft initialDraft = SkillDraft(
      teacherNickname: 'Fatima',
      teacherRole: FamilyRole.grandparent,
      learnerNickname: 'Mariam',
      learnerRole: FamilyRole.teen,
      category: SkillCategory.heritage,
      explanation:
          'Explain how our family welcomes guests with patience and care.',
      contextPhotoPath: '/private/context_photos/existing.jpg',
    );

    final FakeContextPhotoService photoService = FakeContextPhotoService(
      nextPickResult: const ContextPhotoResult.cancelled(),
    );

    await pumpPhotoFlow(
      tester,
      initialDraft: initialDraft,
      photoService: photoService,
    );

    final Finder replaceButton = find.byKey(
      const ValueKey<String>('replace_context_photo_button'),
    );

    await tester.ensureVisible(replaceButton);
    await tester.tap(replaceButton);
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey<String>('choose_gallery_option')),
    );

    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey<String>('context_photo_selected')),
      findsOneWidget,
    );

    expect(photoService.deletedPaths, isEmpty);
  });
}
