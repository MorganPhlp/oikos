import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/theme/app_theme.dart';
import 'package:oikos/core/theme/breakpoints.dart';
import 'package:oikos/features/admin/presentation/bloc/profile_bloc.dart';
import 'package:oikos/features/admin/presentation/bloc/profile_event.dart';
import 'package:oikos/features/admin/presentation/bloc/profile_state.dart';
import 'package:oikos/features/admin/presentation/widget/profile_page/shared_widgets.dart';

class PasswordCard extends StatefulWidget {
  const PasswordCard({super.key});

  @override
  State<PasswordCard> createState() => _PasswordCardState();
}

class _PasswordCardState extends State<PasswordCard> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _savePassword() {
    if (!_formKey.currentState!.validate()) return;
    context.read<ProfileBloc>().add(
      ProfileChangePassword(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listenWhen: (prev, curr) {
        if (prev is! ProfileLoaded || curr is! ProfileLoaded) return false;
        return prev.passwordStatus != curr.passwordStatus;
      },
      listener: (context, state) {
        if (state is! ProfileLoaded) return;
        if (state.passwordStatus == SectionStatus.success) {
          _currentPasswordController.clear();
          _newPasswordController.clear();
          _confirmPasswordController.clear();
          showProfileSnackBar(context, 'Mot de passe modifié avec succès');
          context.read<ProfileBloc>().add(
            ProfileResetStatus(section: ProfileSection.password),
          );
        } else if (state.passwordStatus == SectionStatus.failure) {
          showProfileSnackBar(
            context,
            state.passwordError ??
                'Erreur lors du changement de mot de passe',
            isError: true,
          );
          context.read<ProfileBloc>().add(
            ProfileResetStatus(section: ProfileSection.password),
          );
        }
      },
      builder: (context, state) {
        if (state is! ProfileLoaded) return const SizedBox.shrink();
        final isLoading = state.passwordStatus == SectionStatus.loading;

        final fields = [
          PasswordField(
            label: 'Mot de passe actuel',
            controller: _currentPasswordController,
            obscure: !_showCurrent,
            hint: '••••••••',
            onToggleVisibility: () =>
                setState(() => _showCurrent = !_showCurrent),
            validator: (v) => v == null || v.isEmpty ? 'Requis' : null,
          ),
          PasswordField(
            label: 'Nouveau mot de passe',
            controller: _newPasswordController,
            obscure: !_showNew,
            hint: '••••••••',
            onToggleVisibility: () => setState(() => _showNew = !_showNew),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Requis';
              if (v.length < 8) return 'Min. 8 caractères';
              return null;
            },
          ),
          PasswordField(
            label: 'Confirmer le mot de passe',
            controller: _confirmPasswordController,
            obscure: !_showConfirm,
            hint: '••••••••',
            onToggleVisibility: () =>
                setState(() => _showConfirm = !_showConfirm),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Requis';
              if (v != _newPasswordController.text) {
                return 'Les mots de passe ne correspondent pas';
              }
              return null;
            },
          ),
        ];

        return Container(
          padding: const EdgeInsets.all(AppTheme.spacingLg),
          decoration: AdminColors.of(context).cardDecoration,
          child: Form(
            key: _formKey,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = Breakpoints.isDesktop(constraints.maxWidth);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeader(
                      icon: Icons.lock_rounded,
                      title: 'Modifier le mot de passe',
                    ),
                    const SizedBox(height: AppTheme.spacingLg),
                    if (isDesktop)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: fields[0]),
                          const SizedBox(width: AppTheme.spacingMd),
                          Expanded(child: fields[1]),
                          const SizedBox(width: AppTheme.spacingMd),
                          Expanded(child: fields[2]),
                        ],
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          fields[0],
                          const SizedBox(height: AppTheme.spacingMd),
                          fields[1],
                          const SizedBox(height: AppTheme.spacingMd),
                          fields[2],
                        ],
                      ),
                    const SizedBox(height: AppTheme.spacingXl),
                    SaveButton(
                      onPressed: _savePassword,
                      isLoading: isLoading,
                      label: 'Modifier le mot de passe',
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
