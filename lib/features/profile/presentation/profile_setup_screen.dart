import 'package:flutter/material.dart';
import 'package:naseej/core/state/app_controller.dart';
import 'package:naseej/core/theme/app_colors.dart';
import 'package:naseej/core/theme/app_spacing.dart';
import 'package:naseej/core/widgets/language_toggle_button.dart';
import 'package:naseej/features/profile/domain/family_profile.dart';
import 'package:naseej/features/profile/presentation/family_role_ui.dart';
import 'package:naseej/features/profile/presentation/widgets/role_choice_card.dart';
import 'package:naseej/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController _nicknameController = TextEditingController();

  FamilyRole? _selectedRole;
  bool _isSaving = false;

  bool get _canSave {
    return _nicknameController.text.trim().isNotEmpty &&
        _selectedRole != null &&
        !_isSaving;
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final FamilyRole? selectedRole = _selectedRole;
    final String nickname = _nicknameController.text.trim();

    if (nickname.isEmpty || selectedRole == null || _isSaving) {
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isSaving = true;
    });

    try {
      await context.read<AppController>().saveProfile(
        FamilyProfile(nickname: nickname, role: selectedRole),
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
        ..showSnackBar(SnackBar(content: Text(localizations.profileSaveError)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      key: const ValueKey<String>('profile_setup_screen'),
      appBar: AppBar(
        title: Text(localizations.profileSetupTitle),
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
                localizations.profileSetupBody,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              TextField(
                key: const ValueKey<String>('nickname_field'),
                controller: _nicknameController,
                maxLength: 24,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.done,
                autofillHints: const <String>[AutofillHints.nickname],
                onChanged: (_) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  labelText: localizations.nicknameLabel,
                  hintText: localizations.nicknameHint,
                  counterText: '',
                  filled: true,
                  fillColor: AppColors.surface,
                  prefixIcon: const Icon(Icons.person_outline_rounded),
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
              const SizedBox(height: AppSpacing.lg),
              Text(
                localizations.chooseRoleLabel,
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
                    key: ValueKey<String>('role_${role.name}'),
                    role: role,
                    label: familyRoleLabel(localizations, role),
                    selected: _selectedRole == role,
                    onTap: () {
                      setState(() {
                        _selectedRole = role;
                      });
                    },
                  );
                },
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
            key: const ValueKey<String>('save_profile_button'),
            onPressed: _canSave ? _saveProfile : null,
            child: Text(
              _isSaving
                  ? localizations.savingProfileLabel
                  : localizations.saveProfileLabel,
            ),
          ),
        ),
      ),
    );
  }
}
