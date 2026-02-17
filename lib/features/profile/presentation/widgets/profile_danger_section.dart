import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:oikos/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:oikos/features/profile/presentation/widgets/profile_action_button.dart';

import 'delete_account_modal.dart';

class ProfileDangerSection extends StatelessWidget {
  const ProfileDangerSection({super.key});

  void _handleLogout(BuildContext context) {
    context.read<AuthBloc>().add(AuthSignOut());
  }

  void _handleDeleteAccount(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) => DeleteAccountModal(onConfirm: () {
          context.read<AuthBloc>().add(AuthDeleteAccount());
        })
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
        border: Border.all(color: colorScheme.error.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          ProfileActionButton(
            title: 'Me déconnecter',
            icon: LucideIcons.logOut,
            iconColor: colorScheme.error,
            textColor: colorScheme.error,
            onTap: () => _handleLogout(context),
            showBorder: true,
          ),
          ProfileActionButton(
            title: 'Supprimer mon compte',
            icon: LucideIcons.trash2,
            iconColor: colorScheme.error,
            textColor: colorScheme.error,
            onTap: () => _handleDeleteAccount(context),
            showBorder: false,
          ),
        ],
      ),
    );
  }
}