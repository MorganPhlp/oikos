import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/common/domain/entities/utilisateurs.dart';
import 'package:oikos/core/theme/app_theme.dart';
import 'package:oikos/core/utils/utils.dart';
import 'package:oikos/features/admin/data/models/models.dart';
import 'package:oikos/features/admin/presentation/bloc/community_bloc.dart';
import 'package:oikos/features/admin/presentation/bloc/community_event.dart';
import 'package:oikos/features/admin/presentation/bloc/community_state.dart';
import 'form_widgets.dart';
import 'card_widgets.dart';

// ============================================================================
// MODAL SÉLECTION DU LOGO
// ============================================================================

/// Modal permettant de choisir un logo parmi ceux disponibles dans le storage
class LogoPickerModal extends StatefulWidget {
  const LogoPickerModal({super.key});

  @override
  State<LogoPickerModal> createState() => _LogoPickerModalState();
}

class _LogoPickerModalState extends State<LogoPickerModal> {
  String? _selectedLogoUrl;

  @override
  void initState() {
    super.initState();
    final state = context.read<CommunityBloc>().state;
    if (state is CommunityLoaded) {
      _selectedLogoUrl = state.selectedCommunity?.logoUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommunityBloc, CommunityState>(
      builder: (context, state) {
        if (state is! CommunityLoaded) return const SizedBox.shrink();

        final colors = AdminColors.of(context);
        final community = state.selectedCommunity;
        if (community == null) return const SizedBox.shrink();

        final logos = state.availableLogos;
        final isLoadingLogos = state.isLoadingLogos;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusXl),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500, maxHeight: 560),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                _ModalHeader(
                  title: 'Changer le logo',
                  icon: Icons.image_outlined,
                  iconColor: AppTheme.actionGreen,
                  onClose: () {
                    Navigator.pop(context);
                    context.read<CommunityBloc>().add(
                      ResetCommunityStatusEvent(),
                    );
                  },
                ),
                Divider(height: 1, color: colors.border),

                // Logo actuel + nom communauté
                Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingMd),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                          AppTheme.radiusXxl,
                        ),
                        child: Image.network(
                          community.avatarNetworkUrl,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => CircleAvatar(
                            radius: 24,
                            backgroundColor: colors.pageBackground,
                            child: Icon(
                              Icons.groups_rounded,
                              color: colors.mutedForeground,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingMd),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              community.name,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: colors.foreground,
                              ),
                            ),
                            Text(
                              'Sélectionnez un nouveau logo ci-dessous',
                              style: TextStyle(
                                fontSize: 12,
                                color: colors.mutedForeground,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: colors.border),

                // Grille de logos
                Flexible(
                  child: isLoadingLogos
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32),
                            child: CircularProgressIndicator(
                              color: AppTheme.actionGreen,
                            ),
                          ),
                        )
                      : logos == null || logos.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Text(
                              'Aucun logo disponible',
                              style: TextStyle(color: colors.mutedForeground),
                            ),
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(AppTheme.spacingMd),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                crossAxisSpacing: AppTheme.spacingMd,
                                mainAxisSpacing: AppTheme.spacingMd,
                              ),
                          itemCount: logos.length,
                          itemBuilder: (context, index) {
                            final url = logos[index];
                            final isSelected = _selectedLogoUrl == url;
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedLogoUrl = url),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    AppTheme.radiusLg,
                                  ),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppTheme.actionGreen
                                        : colors.border,
                                    width: isSelected ? 3 : 1,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    AppTheme.radiusMd,
                                  ),
                                  child: Image.network(
                                    StorageUtils.getNetworkUrl('avatars', url),
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) => Container(
                                      color: colors.pageBackground,
                                      child: Icon(
                                        Icons.broken_image_rounded,
                                        color: colors.mutedForeground,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),

                Divider(height: 1, color: colors.border),

                // Actions
                _ModalActions(
                  onCancel: () {
                    Navigator.pop(context);
                    context.read<CommunityBloc>().add(
                      ResetCommunityStatusEvent(),
                    );
                  },
                  onSubmit: () {
                    if (_selectedLogoUrl != null) {
                      context.read<CommunityBloc>().add(
                        UpdateCommunityLogoEvent(
                          communityCode: community.code,
                          logoUrl: _selectedLogoUrl!,
                        ),
                      );
                    }
                    Navigator.pop(context);
                  },
                  submitLabel: 'Enregistrer',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ============================================================================
// MODAL CRÉATION COMMUNAUTÉ
// ============================================================================

/// Modal de création d'une nouvelle communauté (desktop)
class CreateCommunityModal extends StatefulWidget {
  final Company company;
  const CreateCommunityModal({super.key, required this.company});

  @override
  State<CreateCommunityModal> createState() => _CreateCommunityModalState();
}

class _CreateCommunityModalState extends State<CreateCommunityModal> {
  final _nomController = TextEditingController();
  final _codeController = TextEditingController();
  String? _nomError;
  String? _codeError;
  String? _selectedLogoUrl;

  @override
  void initState() {
    super.initState();
    final state = context.read<CommunityBloc>().state;
    if (state is CommunityLoaded && state.availableLogos == null) {
      context.read<CommunityBloc>().add(
        FetchLogosEvent(companyName: widget.company.name),
      );
    }
  }

  @override
  void dispose() {
    _nomController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() {
      _nomError = _validateName(_nomController.text.trim());
      _codeError = _validateCode(_codeController.text.trim());

      if (_nomError == null && _codeError == null) {
        context.read<CommunityBloc>().add(
          CreateNewCommunityEvent(
            name: _nomController.text,
            code: _codeController.text,
            companyId: widget.company.id,
            logoUrl: _selectedLogoUrl,
          ),
        );
      }
    });
  }

  String? _validateCode(String code) {
    if (code.isEmpty) return 'Le code est requis';
    if (code.length != 6)
      return 'Le code doit contenir exactement 6 caractères';
    return null;
  }

  String? _validateName(String name) {
    if (name.isEmpty) return 'Le nom est requis';
    if (name.length < 6) return 'Le nom doit contenir au moins 6 lettres';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: BlocConsumer<CommunityBloc, CommunityState>(
          listenWhen: (prev, curr) {
            if (prev is! CommunityLoaded || curr is! CommunityLoaded) {
              return false;
            }
            return prev.operationStatus != curr.operationStatus;
          },
          listener: (context, state) {
            if (state is! CommunityLoaded) return;
            if (state.operationStatus == SectionStatus.success) {
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            final colors = AdminColors.of(context);
            bool isSubmitting = false;
            String? errorMessage;
            List<String>? logos;
            bool isLoadingLogos = false;

            if (state is CommunityLoaded) {
              isSubmitting = state.operationStatus == SectionStatus.loading;
              errorMessage = state.operationStatus == SectionStatus.failure
                  ? state.operationError
                  : null;
              logos = state.availableLogos;
              isLoadingLogos = state.isLoadingLogos;
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ModalHeader(
                  title: 'Créer une communauté',
                  onClose: () {
                    Navigator.pop(context);
                    context.read<CommunityBloc>().add(
                      ResetCommunityStatusEvent(),
                    );
                  },
                ),
                Divider(height: 1, color: colors.border),

                Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingLg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FormTextField(
                        label: 'Nom de la communauté *',
                        controller: _nomController,
                        error: _nomError,
                        inputFormatter: FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z0-9 \-]'),
                        ),
                        hint: 'Ex: Éco-Warriors Paris',
                        onChanged: (_) => setState(() => _nomError = null),
                      ),
                      const SizedBox(height: AppTheme.spacingMd),
                      FormTextField(
                        label: "Code d'accès *",
                        controller: _codeController,
                        error: _codeError,
                        hint: 'Ex: ECO2023',
                        maxLength: 6,
                        onChanged: (_) => setState(() => _codeError = null),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Le code sera automatiquement converti en majuscules',
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.mutedForeground,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingMd),
                      LogoPickerSection(
                        selectedLogoUrl: _selectedLogoUrl,
                        logos: logos,
                        isLoading: isLoadingLogos,
                        onSelect: (url) =>
                            setState(() => _selectedLogoUrl = url),
                      ),
                      if (errorMessage != null) ...[
                        const SizedBox(height: AppTheme.spacingMd),
                        Text(
                          errorMessage,
                          style: const TextStyle(
                            color: AppTheme.errorForeground,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                _ModalActions(
                  onCancel: () {
                    Navigator.pop(context);
                    context.read<CommunityBloc>().add(
                      ResetCommunityStatusEvent(),
                    );
                  },
                  onSubmit: _submit,
                  submitLabel: 'Créer',
                  isSubmitting: isSubmitting,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ============================================================================
// MODAL MODIFICATION CODE
// ============================================================================

/// Modal de modification du code d'accès (desktop)
class EditCodeModal extends StatefulWidget {
  const EditCodeModal({super.key});

  @override
  State<EditCodeModal> createState() => _EditCodeModalState();
}

class _EditCodeModalState extends State<EditCodeModal> {
  late final TextEditingController _codeController;
  late final String _communityId;
  late final String _communityName;

  @override
  void initState() {
    super.initState();
    final state = context.read<CommunityBloc>().state as CommunityLoaded;
    final community = state.selectedCommunity!;
    _codeController = TextEditingController(text: community.code);
    _communityId = community.code;
    _communityName = community.name;
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: BlocConsumer<CommunityBloc, CommunityState>(
          listenWhen: (prev, curr) {
            if (prev is! CommunityLoaded || curr is! CommunityLoaded) {
              return false;
            }
            return prev.operationStatus != curr.operationStatus;
          },
          listener: (context, state) {
            if (state is! CommunityLoaded) return;
            if (state.operationStatus == SectionStatus.success) {
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            final colors = AdminColors.of(context);
            bool isSubmitting = false;
            String? errorMessage;

            if (state is CommunityLoaded) {
              isSubmitting = state.operationStatus == SectionStatus.loading;
              errorMessage = state.operationStatus == SectionStatus.failure
                  ? state.operationError
                  : null;
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ModalHeader(
                  title: 'Modifier le code',
                  icon: Icons.vpn_key_rounded,
                  iconColor: AppTheme.actionGreen,
                  onClose: () {
                    Navigator.pop(context);
                    context.read<CommunityBloc>().add(
                      ResetCommunityStatusEvent(),
                    );
                  },
                ),
                Divider(height: 1, color: colors.border),
                Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingLg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReadOnlyField(label: 'Communauté', value: _communityName),
                      const SizedBox(height: AppTheme.spacingMd),
                      FormTextField(
                        label: "Nouveau code d'accès *",
                        controller: _codeController,
                        error: errorMessage,
                        hint: 'Ex: ECO2023',
                        maxLength: 6,
                        textCapitalization: TextCapitalization.characters,
                      ),
                    ],
                  ),
                ),
                _ModalActions(
                  onCancel: () {
                    Navigator.pop(context);
                    context.read<CommunityBloc>().add(
                      ResetCommunityStatusEvent(),
                    );
                  },
                  onSubmit: () {
                    context.read<CommunityBloc>().add(
                      UpdateCommunityCodeEvent(
                        newCode: _codeController.text,
                        communityId: _communityId,
                      ),
                    );
                  },
                  submitLabel: 'Enregistrer',
                  isSubmitting: isSubmitting,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ============================================================================
// MODAL LISTE DES MEMBRES
// ============================================================================

/// Modal affichant la liste des membres d'une communauté (desktop)
class MembersListModal extends StatelessWidget {
  const MembersListModal({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommunityBloc, CommunityState>(
      builder: (context, state) {
        if (state is! CommunityLoaded) return const SizedBox.shrink();

        final colors = AdminColors.of(context);
        final users = state.selectedUsers ?? [];
        final community = state.selectedCommunity;
        if (community == null) return const SizedBox.shrink();

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusXl),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600, maxHeight: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingLg),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Membres de ${community.name}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: colors.foreground,
                              ),
                            ),
                            Text(
                              '${users.length} membre${users.length > 1 ? 's' : ''}',
                              style: TextStyle(
                                fontSize: 13,
                                color: colors.mutedForeground,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          context.read<CommunityBloc>().add(
                            ResetCommunityStatusEvent(),
                          );
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close),
                        color: colors.mutedForeground,
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: colors.border),

                // Liste des membres
                Flexible(
                  child: users.isEmpty
                      ? _buildEmptyState(colors.mutedForeground)
                      : _buildMembersList(context, users, community),
                ),

                Divider(height: 1, color: colors.border),

                // Footer
                Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingLg),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        context.read<CommunityBloc>().add(
                          ResetCommunityStatusEvent(),
                        );
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppTheme.spacingMd,
                        ),
                        side: BorderSide(color: colors.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppTheme.radiusLg,
                          ),
                        ),
                      ),
                      child: const Text('Fermer'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(Color mutedColor) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Text('Aucun membre', style: TextStyle(color: mutedColor)),
      ),
    );
  }

  Widget _buildMembersList(
    BuildContext context,
    List<Utilisateurs> users,
    Community community,
  ) {
    return ListView.separated(
      key: ValueKey('members_${users.length}_${community.code}'),
      shrinkWrap: true,
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      itemCount: users.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppTheme.spacingMd),
      itemBuilder: (context, index) {
        final user = users[index];
        return MemberCard(
          key: ValueKey(user.id),
          user: user,
          onChangeCommunity: () => _showChangeModal(context, user),
          onRemoveFromCommunity: () {
            context.read<CommunityBloc>().add(
              RemoveUserFromCommunityEvent(userId: user.id),
            );
          },
        );
      },
    );
  }

  void _showChangeModal(BuildContext context, Utilisateurs user) {
    final bloc = context.read<CommunityBloc>();
    bloc.add(SelectUserEvent(user: user));
    showDialog(
      context: context,
      builder: (ctx) => BlocProvider.value(
        value: bloc,
        child: const ChangeUserCommunityModal(),
      ),
    );
  }
}

// ============================================================================
// MODAL CHANGEMENT COMMUNAUTÉ UTILISATEUR
// ============================================================================

/// Modal pour changer un utilisateur de communauté (desktop)
class ChangeUserCommunityModal extends StatelessWidget {
  const ChangeUserCommunityModal({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommunityBloc, CommunityState>(
      builder: (context, state) {
        if (state is! CommunityLoaded) return const SizedBox.shrink();

        final colors = AdminColors.of(context);
        final user = state.selectedUser;
        if (user == null) return const SizedBox.shrink();

        final communities = state.data.communities;
        final selectedNewCommunityId =
            state.selectedNewCommunityId ?? user.codeCommunaute;
        final isSubmitting = state.operationStatus == SectionStatus.loading;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusXl),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400, maxHeight: 560),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ModalHeader(
                  title: 'Changer de communauté',
                  onClose: () {
                    Navigator.pop(context);
                    context.read<CommunityBloc>().add(
                      ResetCommunityStatusEvent(),
                    );
                  },
                ),
                Divider(height: 1, color: colors.border),

                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppTheme.spacingLg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ReadOnlyField(
                          label: 'Membre',
                          value: user.pseudo,
                          subtitle: user.email,
                        ),
                        const SizedBox(height: AppTheme.spacingLg),
                        Text(
                          'Nouvelle communauté',
                          style: TextStyle(
                            fontSize: 14,
                            color: colors.mutedForeground,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingMd),
                        ...communities.map(
                          (c) => CommunityRadioTile(
                            community: c,
                            isSelected: selectedNewCommunityId == c.code,
                            onTap: () => context.read<CommunityBloc>().add(
                              SelectNewCommunityEvent(communityId: c.code),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                _ModalActions(
                  onCancel: () {
                    Navigator.pop(context);
                    context.read<CommunityBloc>().add(
                      ResetCommunityStatusEvent(),
                    );
                  },
                  onSubmit: () {
                    context.read<CommunityBloc>().add(
                      ConfirmChangeUserCommunityEvent(),
                    );
                    Navigator.pop(context);
                  },
                  submitLabel: 'Confirmer',
                  isSubmitting: isSubmitting,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ============================================================================
// WIDGETS INTERNES RÉUTILISABLES POUR LES MODALS
// ============================================================================

/// Header de modal avec titre et bouton fermer
class _ModalHeader extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback onClose;

  const _ModalHeader({
    required this.title,
    this.icon,
    this.iconColor,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AdminColors.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: iconColor ?? colors.mutedForeground),
            const SizedBox(width: AppTheme.spacingMd),
          ],
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: colors.foreground,
              ),
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close),
            color: colors.mutedForeground,
          ),
        ],
      ),
    );
  }
}

/// Actions de modal (Annuler / Action principale)
class _ModalActions extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onSubmit;
  final String submitLabel;
  final bool? isSubmitting;

  const _ModalActions({
    required this.onCancel,
    required this.onSubmit,
    required this.submitLabel,
    this.isSubmitting,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AdminColors.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacingLg,
        0,
        AppTheme.spacingLg,
        AppTheme.spacingLg,
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onCancel,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: AppTheme.spacingMd,
                ),
                side: BorderSide(color: colors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                ),
              ),
              child: const Text('Annuler'),
            ),
          ),
          const SizedBox(width: AppTheme.spacingMd),
          Expanded(
            child: ElevatedButton(
              onPressed: onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.actionGreen,
                foregroundColor: AppTheme.actionGreenForeground,
                padding: const EdgeInsets.symmetric(
                  vertical: AppTheme.spacingMd,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                ),
              ),
              child: isSubmitting == true
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 5.0,
                      children: [
                        const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                        Text(submitLabel),
                      ],
                    )
                  : Text(submitLabel),
            ),
          ),
        ],
      ),
    );
  }
}
