import 'package:flutter/material.dart';
import 'package:naseej/core/state/app_controller.dart';
import 'package:naseej/core/theme/app_colors.dart';
import 'package:naseej/core/theme/app_spacing.dart';
import 'package:naseej/core/widgets/language_toggle_button.dart';
import 'package:naseej/features/profile/domain/family_profile.dart';
import 'package:naseej/features/profile/presentation/family_role_ui.dart';
import 'package:naseej/features/profile/presentation/widgets/role_choice_card.dart';
import 'package:naseej/features/skill/domain/skill_draft.dart';
import 'package:naseej/features/skill/presentation/skill_category_ui.dart';
import 'package:naseej/features/skill/presentation/widgets/skill_category_choice_card.dart';
import 'package:naseej/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class TeachSkillScreen extends StatefulWidget {
  const TeachSkillScreen({required this.teacher, this.initialDraft, super.key});

  final FamilyProfile teacher;
  final SkillDraft? initialDraft;

  @override
  State<TeachSkillScreen> createState() => _TeachSkillScreenState();
}

class _TeachSkillScreenState extends State<TeachSkillScreen> {
  late final TextEditingController _learnerNicknameController;
  late final TextEditingController _explanationController;

  FamilyRole? _selectedLearnerRole;
  SkillCategory? _selectedCategory;
  bool _isSaving = false;

  bool get _canSave {
    final String learnerNickname = _learnerNicknameController.text.trim();
    final String explanation = _explanationController.text.trim();

    return learnerNickname.isNotEmpty &&
        _selectedLearnerRole != null &&
        _selectedCategory != null &&
        explanation.length >= SkillDraft.minimumExplanationLength &&
        explanation.length <= SkillDraft.maximumExplanationLength &&
        !_isSaving;
  }

  @override
  void initState() {
    super.initState();

    final SkillDraft? initialDraft = widget.initialDraft;

    _learnerNicknameController = TextEditingController(
      text: initialDraft?.learnerNickname ?? '',
    );

    _explanationController = TextEditingController(
      text: initialDraft?.explanation ?? '',
    );

    _selectedLearnerRole = initialDraft?.learnerRole;
    _selectedCategory = initialDraft?.category;
  }

  @override
  void dispose() {
    _learnerNicknameController.dispose();
    _explanationController.dispose();
    super.dispose();
  }

  Future<void> _saveDraft() async {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    final FamilyRole? learnerRole = _selectedLearnerRole;
    final SkillCategory? category = _selectedCategory;

    final String learnerNickname = _learnerNicknameController.text.trim();
    final String explanation = _explanationController.text.trim();

    if (!_canSave || learnerRole == null || category == null) {
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isSaving = true;
    });

    try {
      await context.read<AppController>().saveSkillDraft(
        SkillDraft(
          teacherNickname: widget.teacher.nickname,
          teacherRole: widget.teacher.role,
          learnerNickname: learnerNickname,
          learnerRole: learnerRole,
          category: category,
          explanation: explanation,
        ),
      );

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

    return Scaffold(
      key: const ValueKey<String>('skill_draft_screen'),
      appBar: AppBar(
        title: Text(localizations.teachSkillScreenTitle),
        actions: const <Widget>[LanguageToggleButton()],
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
