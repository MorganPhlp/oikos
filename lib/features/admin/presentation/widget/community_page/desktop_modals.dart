import 'package:oikos/features/admin/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/features/admin/domain/entities/community.dart';
import 'package:oikos/features/admin/presentation/bloc/community_bloc.dart';
import 'package:oikos/features/admin/presentation/bloc/community_event.dart';
import 'package:oikos/features/admin/presentation/bloc/community_state.dart';
import 'package:oikos/core/theme/admin_theme.dart';
import 'form_widgets.dart';
import 'card_widgets.dart';

// ============================================================================
// MODAL CRÉATION COMMUNAUTÉ
// ============================================================================

/// Modal de création d'une nouvelle communauté (desktop)
class CreateCommunityModal extends StatefulWidget {
  const CreateCommunityModal({super.key});

  @override
  State<CreateCommunityModal> createState() => _CreateCommunityModalState();
}

class _CreateCommunityModalState extends State<CreateCommunityModal> {
  final _nomController = TextEditingController();
  final _codeController = TextEditingController();
  String? _nomError;
  String? _codeError;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nomController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _submit() {
    final state = context.read<CommunityBloc>().state;
    String? selectedCompanyId;
    if (state is CommunityLoaded) {
      selectedCompanyId = state.selectedCompanyId;
    }

    setState(() {
      _nomError = _validateName(_nomController.text.trim());
      _codeError = _validateCode(_codeController.text.trim());

      if (_nomError == null &&
          _codeError == null &&
          selectedCompanyId != null) {
        String name = _nomController.text;
        String code = _codeController.text;
        context.read<CommunityBloc>().add(
          CreateNewCommunityEvent(
            name: name,
            code: code,
            companyId: selectedCompanyId,
          ),
        );
      }
    });
  }

  // void _onTextChanged() {
  //   // Cette fonction s'exécute à CHAQUE lettre tapée ou effacée

  //   // Exemple : Tu peux envoyer un événement au Bloc ici
  //   // context.read<CommunityBloc>().add(SearchChanged(_controller.text));
  // }

  String? _validateCode(String code) {
    if (code.isEmpty) return 'Le code est requis';
    if (code.length != 6) return 'Le code doit contenir exactement 6 caractères';
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: BlocBuilder<CommunityBloc, CommunityState>(
          builder: (context, state) {
            bool updateSuccess = false;
            String? errorMessage;
            List<dynamic> companies = [];
            String? selectedCompanyId;

            if (state is CommunityLoaded) {
              updateSuccess = state.updateSuccess;
              companies = state.data.companies;
              selectedCompanyId = state.selectedCompanyId;
              errorMessage = state.errorMessage;
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                _ModalHeader(
                  title: 'Créer une communauté',
                  onClose: () {
                    Navigator.pop(context);
                    context.read<CommunityBloc>().add(
                      ResetCommunityStatusEvent(),
                    );
                  },
                ),
                const Divider(height: 1),

                // Formulaire
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FormTextField(
                        label: 'Nom de la communauté *',
                        controller: _nomController,
                        error: _nomError,
                        hint: 'Ex: Éco-Warriors Paris',
                        onChanged: (_) => setState(() {
                          _nomError = null;
                        }),
                      ),
                      const SizedBox(height: 16),
                      FormTextField(
                        label: "Code d'accès *",
                        controller: _codeController,
                        error: _codeError,
                        hint: 'Ex: ECO2023',
                        maxLength: 10,
                        textCapitalization: TextCapitalization.characters,
                        onChanged: (_) => setState(() => _codeError = null),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Le code sera automatiquement converti en majuscules',
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Entreprise *',
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 8),
                      ...companies.map(
                        (c) => CompanyRadioTile(
                          company: c,
                          isSelected: selectedCompanyId == c.id,
                          onTap: () => context.read<CommunityBloc>().add(
                            SelectCompanyEvent(companyId: c.id),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (updateSuccess)
                        const Text(
                          "Communauté créée avec succès !",
                          style: TextStyle(color: Colors.green),
                        ),
                      if (errorMessage != null)
                        const Text(
                          "Une erreur est survenue lors de la création de la communauté",
                          style: TextStyle(color: Colors.red),
                        ),
                    ],
                  ),
                ),

                // Actions
                _ModalActions(
                  onCancel: () {
                    Navigator.pop(context);
                    context.read<CommunityBloc>().add(
                      ResetCommunityStatusEvent(),
                    );
                  },
                  onSubmit: _submit,
                  submitLabel: 'Créer',
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
    _communityId = community.id;
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: BlocBuilder<CommunityBloc, CommunityState>(
          builder: (context, state) {
            bool isSubmitting = false;
            bool updateSuccess = false;
            String? errorMessage;
            if (state is CommunityLoaded) {
              isSubmitting = state.isSubmitting;
              updateSuccess = state.updateSuccess;
              errorMessage = state.errorMessage;
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header avec icône
                _ModalHeader(
                  title: 'Modifier le code',
                  icon: Icons.vpn_key,
                  iconColor: CommunityColors.primary,
                  onClose: () {
                    Navigator.pop(context);
                    context.read<CommunityBloc>().add(
                      ResetCommunityStatusEvent(),
                    );
                  },
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReadOnlyField(label: 'Communauté', value: _communityName),
                      const SizedBox(height: 16),
                      FormTextField(
                        label: "Nouveau code d'accès *",
                        controller: _codeController,
                        error: errorMessage,
                        success: updateSuccess ? "Mise à jour réussie !" : null,
                        hint: 'Ex: ECO2023',
                        maxLength: 6,
                        textCapitalization: TextCapitalization.characters,
                      ),
                    ],
                  ),
                ),
                // Actions
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
        if (state is! CommunityLoaded) {
          return const SizedBox.shrink();
        }

        final users = state.selectedUsers ?? [];
        final community = state.selectedCommunity;
        if (community == null) return const SizedBox.shrink();

        final communities = state.data.communities;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600, maxHeight: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(20),
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
                                color: Colors.grey[900],
                              ),
                            ),
                            Text(
                              '${users.length} membre${users.length > 1 ? 's' : ''}',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          context.read<CommunityBloc>().add(ResetCommunityStatusEvent());
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // Liste des membres
                Flexible(
                  child: users.isEmpty
                      ? _buildEmptyState()
                      : _buildMembersList(
                          context,
                          users,
                          community,
                          communities,
                        ),
                ),

                const Divider(height: 1),

                // Footer
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        context.read<CommunityBloc>().add(ResetCommunityStatusEvent());
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
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

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Text('Aucun membre', style: TextStyle(color: Colors.grey[500])),
      ),
    );
  }

  Widget _buildMembersList(
    BuildContext context,
    List<User> users,
    Community community,
    List<Community> communities,
  ) {
    return ListView.separated(
      key: ValueKey('members_${users.length}_${community.id}'),
      shrinkWrap: true,
      padding: const EdgeInsets.all(20),
      itemCount: users.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
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

  void _showChangeModal(BuildContext context, User user) {
    final bloc = context.read<CommunityBloc>();
    // Sélectionne l'utilisateur dans le bloc avant d'ouvrir la modal
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
        if (state is! CommunityLoaded) {
          return const SizedBox.shrink();
        }

        final user = state.selectedUser;
        if (user == null) return const SizedBox.shrink();

        final communities = state.data.communities;
        final selectedNewCommunityId =
            state.selectedNewCommunityId ?? user.communityId;
        final isSubmitting = state.isSubmitting;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                _ModalHeader(
                  title: 'Changer de communauté',
                  onClose: () {
                    Navigator.pop(context);
                    context.read<CommunityBloc>().add(
                      ResetCommunityStatusEvent(),
                    );
                  },
                ),
                const Divider(height: 1),

                // Contenu
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReadOnlyField(
                        label: 'Membre',
                        value: user.pseudo,
                        subtitle: user.email,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Nouvelle communauté',
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 12),
                      ...communities.map(
                        (c) => CommunityRadioTile(
                          community: c,
                          isSelected: selectedNewCommunityId == c.id,
                          onTap: () => context.read<CommunityBloc>().add(
                            SelectNewCommunityEvent(communityId: c.id),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Actions
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
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: iconColor ?? Colors.grey[700]),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[900],
              ),
            ),
          ),
          IconButton(onPressed: onClose, icon: const Icon(Icons.close)),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onCancel,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Annuler'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: CommunityColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Builder(
                builder: (context) {
                  if (isSubmitting == true) {
                    return Row(
                      spacing: 5.0,
                      children: [
                        const SizedBox(width: 10),
                        const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                        Text(submitLabel),
                      ],
                    );
                  }

                  return Text(submitLabel);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
