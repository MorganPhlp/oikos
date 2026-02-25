import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:oikos/core/common/domain/entities/utilisateurs.dart';
import 'package:oikos/core/theme/admin_theme.dart';
import 'package:oikos/features/admin/presentation/bloc/profile_bloc.dart';
import 'package:oikos/features/admin/presentation/bloc/profile_event.dart';
import 'package:oikos/features/admin/presentation/bloc/profile_state.dart';
import 'package:oikos/features/admin/presentation/widget/profile_page/avatar_picker_modal.dart';
import 'package:oikos/features/admin/presentation/widget/profile_page/shared_widgets.dart';

class ProfileCard extends StatefulWidget {
  final Utilisateurs user;

  const ProfileCard({super.key, required this.user});

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _pseudoController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _pseudoController = TextEditingController(text: widget.user.pseudo);
    _emailController = TextEditingController(text: widget.user.email);
  }

  @override
  void dispose() {
    _pseudoController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) return;
    final current = context.read<ProfileBloc>().state;
    if (current is! ProfileLoaded) return;
    context.read<ProfileBloc>().add(
      ProfileUpdateUser(
        user: current.user.copyWith(
          pseudo: _pseudoController.text.trim(),
          email: _emailController.text.trim(),
        ),
      ),
    );
  }

  void _showAvatarPicker() {
    final bloc = context.read<ProfileBloc>();
    if ((bloc.state as ProfileLoaded).availableAvatars == null) {
      bloc.add(ProfileFetchAvatars());
    }
    showDialog(
      context: context,
      builder: (_) =>
          BlocProvider.value(value: bloc, child: const AvatarPickerModal()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listenWhen: (prev, curr) {
        if (prev is! ProfileLoaded || curr is! ProfileLoaded) return false;
        return prev.profileStatus != curr.profileStatus;
      },
      listener: (context, state) {
        if (state is! ProfileLoaded) return;
        if (state.profileStatus == SectionStatus.success) {
          showProfileSnackBar(context, 'Profil mis à jour avec succès');
          context.read<AppUserCubit>().updateUser(
            state.user,
            company: state.company,
          );
          context.read<ProfileBloc>().add(
            ProfileResetStatus(section: ProfileSection.profile),
          );
        } else if (state.profileStatus == SectionStatus.failure) {
          showProfileSnackBar(
            context,
            state.profileError ?? 'Erreur lors de la mise à jour du profil',
            isError: true,
          );
          context.read<ProfileBloc>().add(
            ProfileResetStatus(section: ProfileSection.profile),
          );
        }
      },
      builder: (context, state) {
        if (state is! ProfileLoaded) return const SizedBox.shrink();
        final isLoading = state.profileStatus == SectionStatus.loading;
        return Container(
          padding: const EdgeInsets.all(AdminTheme.spacingLg),
          decoration: AdminColors.of(context).cardDecoration,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(
                  icon: Icons.person_rounded,
                  title: 'Profil',
                ),
                const SizedBox(height: AdminTheme.spacingLg),
                Center(
                  child: AvatarEditor(
                    user: state.user,
                    onTap: _showAvatarPicker,
                  ),
                ),
                const SizedBox(height: AdminTheme.spacingMd),
                Center(child: RoleBadge(role: state.user.role)),
                const SizedBox(height: AdminTheme.spacingLg),
                const FieldLabel(label: 'Pseudo'),
                const SizedBox(height: AdminTheme.spacingXs),
                TextFormField(
                  controller: _pseudoController,
                  decoration: profileInputDecoration(
                    context,
                    hint: 'Votre pseudo',
                    prefixIcon: Icons.badge_rounded,
                  ),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Le pseudo est requis'
                      : null,
                ),
                const SizedBox(height: AdminTheme.spacingMd),
                const FieldLabel(label: 'Email'),
                const SizedBox(height: AdminTheme.spacingXs),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: profileInputDecoration(
                    context,
                    hint: 'votre@email.com',
                    prefixIcon: Icons.email_rounded,
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return "L'email est requis";
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
                      return 'Email invalide';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AdminTheme.spacingXl),
                SizedBox(
                  width: double.infinity,
                  child: SaveButton(
                    onPressed: _saveProfile,
                    isLoading: isLoading,
                    label: 'Enregistrer le profil',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
