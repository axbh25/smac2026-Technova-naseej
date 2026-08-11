import 'dart:async';

import 'package:flutter/material.dart';
import 'package:naseej/core/photo/context_photo_service.dart';
import 'package:naseej/core/photo/device_context_photo_service.dart';
import 'package:naseej/core/speech/speech_controller.dart';
import 'package:naseej/core/state/app_controller.dart';
import 'package:naseej/core/theme/app_colors.dart';
import 'package:naseej/core/theme/app_spacing.dart';
import 'package:naseej/core/widgets/language_toggle_button.dart';
import 'package:naseej/features/profile/domain/family_profile.dart';
import 'package:naseej/features/profile/presentation/family_role_ui.dart';
import 'package:naseej/features/profile/presentation/widgets/role_choice_card.dart';
import 'package:naseej/features/skill/domain/skill_draft.dart';
import 'package:naseej/features/skill/presentation/skill_category_ui.dart';
import 'package:naseej/features/skill/presentation/widgets/context_photo_card.dart';
import 'package:naseej/features/skill/presentation/widgets/skill_category_choice_card.dart';
import 'package:naseej/features/skill/presentation/widgets/speech_input_card.dart';
import 'package:naseej/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class TeachSkillScreen extends StatefulWidget {
  const TeachSkillScreen({
    required this.teacher,
    this.initialDraft,
    this.contextPhotoService,
    super.key,
  });

  final FamilyProfile teacher;
  final SkillDraft? initialDraft;
  final ContextPhotoService? contextPhotoService;

  @override
  State<TeachSkillScreen> createState() => _TeachSkillScreenState();
}

class _TeachSkillScreenState extends State<TeachSkillScreen> {
  late final TextEditingController _learnerNicknameController;
  late final TextEditingController _explanationController;
  late final ContextPhotoService _contextPhotoService;

  SpeechController? _speechController;

  String _speechBaseText = '';
  String? _initialContextPhotoPath;
  String? _contextPhotoPath;

  FamilyRole? _selectedLearnerRole;
  SkillCategory? _selectedCategory;
  ContextPhotoFailure? _photoFailure;

  bool _isSaving = false;
  bool _isPickingPhoto = false;
  bool _draftWasSaved = false;

  bool get _canSave {
    final String learnerNickname = _learnerNicknameController.text.trim();

    final String explanation = _explanationController.text.trim();

    return learnerNickname.isNotEmpty &&
        _selectedLearnerRole != null &&
        _selectedCategory != null &&
        explanation.length >= SkillDraft.minimumExplanationLength &&
        explanation.length <= SkillDraft.maximumExplanationLength &&
        !_isSaving &&
        !_isPickingPhoto;
  }

  @override
  void initState() {
    super.initState();

    final SkillDraft? initialDraft = widget.initialDraft;

    _contextPhotoService =
        widget.contextPhotoService ?? DeviceContextPhotoService();

    _learnerNicknameController = TextEditingController(
      text: initialDraft?.learnerNickname ?? '',
    );

    _explanationController = TextEditingController(
      text: initialDraft?.explanation ?? '',
    );

    _selectedLearnerRole = initialDraft?.learnerRole;
    _selectedCategory = initialDraft?.category;

    _initialContextPhotoPath = initialDraft?.contextPhotoPath;

    _contextPhotoPath = initialDraft?.contextPhotoPath;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        unawaited(_recoverLostContextPhoto());
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _speechController ??= context.read<SpeechController>();
  }

  @override
  void dispose() {
    final SpeechController? speechController = _speechController;

    if (speechController != null) {
      unawaited(speechController.cancelListening());
    }

    final String? selectedPhotoPath = _contextPhotoPath;

    if (!_draftWasSaved &&
        selectedPhotoPath != null &&
        selectedPhotoPath != _initialContextPhotoPath) {
      unawaited(_deletePhotoSilently(selectedPhotoPath));
    }

    _learnerNicknameController.dispose();
    _explanationController.dispose();

    super.dispose();
  }

  Future<void> _toggleSpeechInput() async {
    final SpeechController speechController = context.read<SpeechController>();

    if (speechController.isListening) {
      await speechController.stopListening();
      return;
    }

    _speechBaseText = _explanationController.text.trim();

    await speechController.startListening(
      locale: Localizations.localeOf(context),
      onWords: (String words, bool isFinal) {
        if (!mounted) {
          return;
        }

        final String recognizedWords = words.trim();
        final String mergedText;

        if (recognizedWords.isEmpty) {
          mergedText = _speechBaseText;
        } else if (_speechBaseText.isEmpty) {
          mergedText = recognizedWords;
        } else {
          mergedText = '$_speechBaseText $recognizedWords';
        }

        final String limitedText =
            mergedText.length <= SkillDraft.maximumExplanationLength
            ? mergedText
            : mergedText.substring(0, SkillDraft.maximumExplanationLength);

        _explanationController.value = TextEditingValue(
          text: limitedText,
          selection: TextSelection.collapsed(offset: limitedText.length),
        );

        setState(() {});
      },
    );
  }

  Future<void> _showPhotoSourceSheet() async {
    final SpeechController speechController = context.read<SpeechController>();

    await speechController.stopListening();

    if (!mounted) {
      return;
    }

    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final ContextPhotoSource? source =
        await showModalBottomSheet<ContextPhotoSource>(
          context: context,
          showDragHandle: true,
          builder: (BuildContext sheetContext) {
            return SafeArea(
              child: Wrap(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                      AppSpacing.lg,
                      AppSpacing.sm,
                      AppSpacing.lg,
                      AppSpacing.xs,
                    ),
                    child: Text(
                      localizations.contextPhotoSectionTitle,
                      style: Theme.of(sheetContext).textTheme.titleMedium,
                    ),
                  ),
                  ListTile(
                    key: const ValueKey<String>('take_photo_option'),
                    leading: const Icon(Icons.photo_camera_outlined),
                    title: Text(localizations.takePhotoLabel),
                    onTap: () {
                      Navigator.of(sheetContext).pop(ContextPhotoSource.camera);
                    },
                  ),
                  ListTile(
                    key: const ValueKey<String>('choose_gallery_option'),
                    leading: const Icon(Icons.photo_library_outlined),
                    title: Text(localizations.chooseFromGalleryLabel),
                    onTap: () {
                      Navigator.of(
                        sheetContext,
                      ).pop(ContextPhotoSource.gallery);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.close_rounded),
                    title: Text(localizations.cancelLabel),
                    onTap: () {
                      Navigator.of(sheetContext).pop();
                    },
                  ),
                ],
              ),
            );
          },
        );

    if (source != null) {
      await _pickContextPhoto(source);
    }
  }

  Future<void> _pickContextPhoto(ContextPhotoSource source) async {
    if (_isPickingPhoto) {
      return;
    }

    setState(() {
      _isPickingPhoto = true;
      _photoFailure = null;
    });

    try {
      final ContextPhotoResult result = await _contextPhotoService
          .pickAndStorePhoto(source);

      await _applyPhotoResult(result);
    } catch (_) {
      if (mounted) {
        setState(() {
          _photoFailure = ContextPhotoFailure.unknown;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPickingPhoto = false;
        });
      }
    }
  }

  Future<void> _recoverLostContextPhoto() async {
    try {
      final ContextPhotoResult? result = await _contextPhotoService
          .recoverLostPhoto();

      if (!mounted || result == null) {
        return;
      }

      await _applyPhotoResult(result);
    } catch (_) {
      if (mounted) {
        setState(() {
          _photoFailure = ContextPhotoFailure.unknown;
        });
      }
    }
  }

  Future<void> _applyPhotoResult(ContextPhotoResult result) async {
    if (result.cancelled) {
      return;
    }

    final ContextPhotoFailure? failure = result.failure;

    if (failure != null) {
      if (mounted) {
        setState(() {
          _photoFailure = failure;
        });
      }

      return;
    }

    final String? selectedPath = result.storedPath;

    if (selectedPath == null) {
      return;
    }

    final String? previousPath = _contextPhotoPath;

    if (previousPath != null &&
        previousPath != _initialContextPhotoPath &&
        previousPath != selectedPath) {
      await _deletePhotoSilently(previousPath);
    }

    if (!mounted) {
      await _deletePhotoSilently(selectedPath);
      return;
    }

    setState(() {
      _contextPhotoPath = selectedPath;
      _photoFailure = null;
    });
  }

  Future<void> _removeContextPhoto() async {
    if (_isPickingPhoto) {
      return;
    }

    final String? currentPath = _contextPhotoPath;

    if (currentPath != null && currentPath != _initialContextPhotoPath) {
      await _deletePhotoSilently(currentPath);
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _contextPhotoPath = null;
      _photoFailure = null;
    });
  }

  Future<void> _deletePhotoSilently(String? photoPath) async {
    try {
      await _contextPhotoService.deleteStoredPhoto(photoPath);
    } catch (_) {
      // Photo cleanup must not crash or block the form.
    }
  }

  String? _speechErrorMessage(
    AppLocalizations localizations,
    SpeechController speechController,
  ) {
    final String? errorCode = speechController.lastErrorCode;

    if (errorCode == null) {
      return null;
    }

    final String normalizedCode = errorCode.toLowerCase();

    if (normalizedCode.contains('permission') ||
        normalizedCode.contains('insufficient')) {
      return localizations.speechPermissionDenied;
    }

    if (normalizedCode.contains('network')) {
      return localizations.speechNetworkError;
    }

    if (normalizedCode.contains('no_match') ||
        normalizedCode.contains('timeout')) {
      return localizations.speechNoMatch;
    }

    return localizations.speechGenericError;
  }

  String? _photoErrorMessage(AppLocalizations localizations) {
    return switch (_photoFailure) {
      ContextPhotoFailure.permissionDenied =>
        localizations.photoPermissionDenied,
      ContextPhotoFailure.sourceUnavailable =>
        localizations.photoSourceUnavailable,
      ContextPhotoFailure.invalidFile => localizations.photoInvalidFile,
      ContextPhotoFailure.storageFailure => localizations.photoStorageError,
      ContextPhotoFailure.unknown => localizations.photoGenericError,
      null => null,
    };
  }

  Future<void> _saveDraft() async {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final SpeechController speechController = context.read<SpeechController>();

    final AppController appController = context.read<AppController>();

    final FamilyRole? learnerRole = _selectedLearnerRole;

    final SkillCategory? category = _selectedCategory;

    final String learnerNickname = _learnerNicknameController.text.trim();

    final String explanation = _explanationController.text.trim();

    if (!_canSave || learnerRole == null || category == null) {
      return;
    }

    FocusScope.of(context).unfocus();

    await speechController.stopListening();

    if (!mounted) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final String? previousInitialPhotoPath = _initialContextPhotoPath;

      await appController.saveSkillDraft(
        SkillDraft(
          teacherNickname: widget.teacher.nickname,
          teacherRole: widget.teacher.role,
          learnerNickname: learnerNickname,
          learnerRole: learnerRole,
          category: category,
          explanation: explanation,
          contextPhotoPath: _contextPhotoPath,
        ),
      );

      if (previousInitialPhotoPath != _contextPhotoPath) {
        await _deletePhotoSilently(previousInitialPhotoPath);
      }

      _draftWasSaved = true;
      _initialContextPhotoPath = _contextPhotoPath;

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(localizations.draftSaveError)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final SpeechController speechController = context.watch<SpeechController>();

    final String? speechErrorMessage = _speechErrorMessage(
      localizations,
      speechController,
    );

    final String? photoErrorMessage = _photoErrorMessage(localizations);

    final bool permanentlyUnavailable =
        speechController.initializationAttempted &&
        !speechController.isAvailable;

    final String speechTitle = speechController.isListening
        ? localizations.speechListeningTitle
        : speechErrorMessage != null
        ? localizations.speechUnavailableTitle
        : localizations.voiceInputTitle;

    final String speechBody = speechController.isListening
        ? localizations.speechListeningBody
        : permanentlyUnavailable
        ? localizations.typedFallbackLabel
        : localizations.voiceInputBody;

    final String speechButtonLabel = speechController.isListening
        ? localizations.stopListeningLabel
        : localizations.startSpeakingLabel;

    return Scaffold(
      key: const ValueKey<String>('skill_draft_screen'),
      appBar: AppBar(
        title: Text(localizations.teachSkillScreenTitle),
        actions: <Widget>[
          LanguageToggleButton(enabled: !speechController.isListening),
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.fromSTEB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                localizations.teacherSectionTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              _TeacherSummaryCard(
                teacher: widget.teacher,
                roleLabel: familyRoleLabel(localizations, widget.teacher.role),
                body: localizations.teacherCardBody,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                localizations.learnerSectionTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                key: const ValueKey<String>('learner_nickname_field'),
                controller: _learnerNicknameController,
                maxLength: 24,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                onChanged: (_) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  labelText: localizations.learnerNicknameLabel,
                  hintText: localizations.learnerNicknameHint,
                  counterText: '',
                  filled: true,
                  fillColor: AppColors.surface,
                  prefixIcon: const Icon(Icons.person_add_alt_1_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.border),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                localizations.learnerRoleLabel,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: FamilyRole.values.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppSpacing.sm,
                  mainAxisSpacing: AppSpacing.sm,
                  childAspectRatio: 1.63,
                ),
                itemBuilder: (BuildContext context, int index) {
                  final FamilyRole role = FamilyRole.values[index];

                  return RoleChoiceCard(
                    key: ValueKey<String>('learner_role_${role.name}'),
                    role: role,
                    label: familyRoleLabel(localizations, role),
                    selected: _selectedLearnerRole == role,
                    onTap: () {
                      setState(() {
                        _selectedLearnerRole = role;
                      });
                    },
                  );
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                localizations.categorySectionTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: SkillCategory.values.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppSpacing.sm,
                  mainAxisSpacing: AppSpacing.sm,
                  childAspectRatio: 1.55,
                ),
                itemBuilder: (BuildContext context, int index) {
                  final SkillCategory category = SkillCategory.values[index];

                  return SkillCategoryChoiceCard(
                    key: ValueKey<String>('category_${category.name}'),
                    category: category,
                    label: skillCategoryLabel(localizations, category),
                    selected: _selectedCategory == category,
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                  );
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                localizations.contextPhotoSectionTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              ContextPhotoCard(
                photoPath: _contextPhotoPath,
                isBusy: _isPickingPhoto,
                title: localizations.contextPhotoTitle,
                body: localizations.contextPhotoBody,
                addLabel: localizations.addContextPhotoLabel,
                replaceLabel: localizations.replaceContextPhotoLabel,
                removeLabel: localizations.removeContextPhotoLabel,
                processingLabel: localizations.photoProcessingLabel,
                privacyLabel: localizations.photoPrivacyNotice,
                unavailableLabel: localizations.contextPhotoUnavailable,
                errorMessage: photoErrorMessage,
                onAddOrReplace: () {
                  unawaited(_showPhotoSourceSheet());
                },
                onRemove: () {
                  unawaited(_removeContextPhoto());
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                localizations.voiceInputSectionTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              SpeechInputCard(
                isListening: speechController.isListening,
                initializationAttempted:
                    speechController.initializationAttempted,
                isAvailable: speechController.isAvailable,
                title: speechTitle,
                body: speechBody,
                buttonLabel: speechButtonLabel,
                privacyLabel: localizations.voicePrivacyNotice,
                errorMessage: speechErrorMessage,
                onPressed: () {
                  unawaited(_toggleSpeechInput());
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                localizations.explanationSectionTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                key: const ValueKey<String>('explanation_field'),
                controller: _explanationController,
                minLines: 5,
                maxLines: 7,
                maxLength: SkillDraft.maximumExplanationLength,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                onTap: () {
                  if (speechController.isListening) {
                    unawaited(speechController.stopListening());
                  }
                },
                onChanged: (_) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: localizations.explanationHint,
                  helperText: localizations.explanationHelper,
                  helperMaxLines: 2,
                  alignLabelWithHint: true,
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.border),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          20,
        ),
        child: SizedBox(
          height: 56,
          child: FilledButton(
            key: const ValueKey<String>('save_draft_button'),
            onPressed: _canSave ? _saveDraft : null,
            child: Text(
              _isSaving
                  ? localizations.savingDraftLabel
                  : localizations.saveDraftLabel,
            ),
          ),
        ),
      ),
    );
  }
}

class _TeacherSummaryCard extends StatelessWidget {
  const _TeacherSummaryCard({
    required this.teacher,
    required this.roleLabel,
    required this.body,
  });

  final FamilyProfile teacher;
  final String roleLabel;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 80),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.surfaceSoft,
            child: Icon(familyRoleIcon(teacher.role), color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${teacher.nickname} — $roleLabel',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(body, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
