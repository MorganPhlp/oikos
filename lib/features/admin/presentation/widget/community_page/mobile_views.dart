import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/domain/entities/user.dart';
import 'package:oikos/features/admin/data/models/models.dart';
import 'package:oikos/features/admin/presentation/bloc/community_bloc.dart';
import 'package:oikos/features/admin/presentation/bloc/community_event.dart';
import 'package:oikos/features/admin/presentation/bloc/community_state.dart';
import 'form_widgets.dart';
import 'card_widgets.dart';

// ============================================================================
// LISTE DES COMMUNAUTÉS (MOBILE)
// ============================================================================

/// Écran principal mobile affichant la liste des communautés
class MobileCommunityList extends StatelessWidget {
  final List<Community> communities;
  final List<User> users;
  final VoidCallback onCreateCommunity;
  final Function(Community) onViewMembers;
  final Function(Community) onEditCode;
  final Function(Community) onDelete;

  const MobileCommunityList({
    super.key,
    required this.communities,
    required this.users,
    required this.onCreateCommunity,
    required this.onViewMembers,
    required this.onEditCode,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header avec titre et bouton +
        _buildHeader(),

        // Liste des communautés
        Expanded(
          child: communities.isEmpty ? _buildEmptyState() : _buildList(),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Communautés',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
              ),
              Text(
                '${communities.length} communauté${communities.length > 1 ? 's' : ''}',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ],
          ),
          IconButton(
            onPressed: onCreateCommunity,
            icon: const Icon(Icons.add_circle),
            color: const Color(0xFF16A34A),
            iconSize: 32,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.groups, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Aucune communauté',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[900],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Appuyez sur + pour créer',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: communities.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final community = communities[index];
        return MobileCommunityCard(
          community: community,
          rank: index + 1,
          onViewMembers: () => onViewMembers(community),
          onEditCode: () => onEditCode(community),
          onDelete: () => onDelete(community),
        );
      },
    );
  }
}

// ============================================================================
// LISTE DES MEMBRES (MOBILE)
// ============================================================================

/// Écran mobile affichant les membres d'une communauté
class MobileMembersList extends StatelessWidget {
  final Community community;
  final List<User> users;
  final VoidCallback onBack;
  final Function(User) onChangeUserCommunity;
  final Function(User) onRemoveUserFromCommunity;

  const MobileMembersList({
    super.key,
    required this.community,
    required this.users,
    required this.onBack,
    required this.onChangeUserCommunity,
    required this.onRemoveUserFromCommunity,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header avec bouton retour
        _buildHeader(),

        // Liste des membres
        Expanded(
          child: users.isEmpty
              ? Center(
                  child: Text(
                    'Aucun membre',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                )
              : _buildList(context),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_back)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  community.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[900],
                  ),
                ),
                Text(
                  '${users.length} membre${users.length > 1 ? 's' : ''}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: users.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final user = users[index];
        return MemberCard(
          user: user,
          onChangeCommunity: () => onChangeUserCommunity(user),
          onRemoveFromCommunity: () => onRemoveUserFromCommunity(user),
        );
      },
    );
  }
}

// ============================================================================
// FORMULAIRE CRÉATION COMMUNAUTÉ (MOBILE)
// ============================================================================

/// Écran mobile de création d'une communauté
class MobileCreateCommunity extends StatefulWidget {
  final VoidCallback onBack;

  const MobileCreateCommunity({super.key, required this.onBack});

  @override
  State<MobileCreateCommunity> createState() => _MobileCreateCommunityState();
}

class _MobileCreateCommunityState extends State<MobileCreateCommunity> {
  final _nomController = TextEditingController();
  final _codeController = TextEditingController();
  String? _nomError;
  String? _codeError;

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
    return BlocBuilder<CommunityBloc, CommunityState>(
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
          children: [
            FormHeader(title: 'Créer une communauté', onBack: widget.onBack),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormTextField(
                      label: 'Nom de la communauté *',
                      controller: _nomController,
                      error: _nomError,
                      hint: 'Ex: Éco-Warriors Paris',
                      onChanged: (_) => setState(() => _nomError = null),
                    ),
                    const SizedBox(height: 20),
                    FormTextField(
                      label: "Code d'accès *",
                      controller: _codeController,
                      error: _codeError,
                      hint: 'Ex: ECO2023',
                      maxLength: 6,
                      textCapitalization: TextCapitalization.characters,
                      onChanged: (_) => setState(() => _codeError = null),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Le code sera automatiquement converti en majuscules',
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                    const SizedBox(height: 20),
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
                    const SizedBox(height: 16),
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
            ),

            FormActions(
              onCancel: widget.onBack,
              onSubmit: _submit,
              submitLabel: 'Créer',
            ),
          ],
        );
      },
    );
  }
}

// ============================================================================
// FORMULAIRE MODIFICATION CODE (MOBILE)
// ============================================================================

/// Écran mobile de modification du code d'accès
class MobileEditCode extends StatefulWidget {
  final VoidCallback onBack;

  const MobileEditCode({super.key, required this.onBack});

  @override
  State<MobileEditCode> createState() => _MobileEditCodeState();
}

class _MobileEditCodeState extends State<MobileEditCode> {
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
    return BlocBuilder<CommunityBloc, CommunityState>(
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
          children: [
            FormHeader(title: 'Modifier le code', onBack: widget.onBack),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReadOnlyField(label: 'Communauté', value: _communityName),
                    const SizedBox(height: 20),
                    FormTextField(
                      label: "Nouveau code d'accès *",
                      controller: _codeController,
                      error: errorMessage,
                      success: updateSuccess ? "Mise à jour réussie !" : null,
                      hint: 'Ex: ECO2023',
                      maxLength: 6,
                      textCapitalization: TextCapitalization.characters,
                    ),
                    const SizedBox(height: 16),
                    const WarningBox(
                      message:
                          'Les membres devront utiliser le nouveau code pour rejoindre.',
                    ),
                  ],
                ),
              ),
            ),

            FormActions(
              onCancel: widget.onBack,
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
    );
  }
}

// ============================================================================
// FORMULAIRE CHANGEMENT COMMUNAUTÉ UTILISATEUR (MOBILE)
// ============================================================================

/// Écran mobile pour changer un utilisateur de communauté
class MobileChangeUserCommunity extends StatelessWidget {
  final VoidCallback onBack;

  const MobileChangeUserCommunity({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommunityBloc, CommunityState>(
      builder: (context, state) {
        if (state is! CommunityLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = state.selectedUser;
        if (user == null) return const SizedBox.shrink();

        final communities = state.data.communities;
        final selectedNewCommunityId =
            state.selectedNewCommunityId ?? user.codeCommunaute;

        return Column(
          children: [
            FormHeader(title: 'Changer de communauté', onBack: onBack),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Info utilisateur
                    ReadOnlyField(
                      label: 'Membre',
                      value: user.pseudo,
                      subtitle: user.email,
                    ),
                    const SizedBox(height: 24),

                    // Sélection communauté
                    Text(
                      'Nouvelle communauté',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 12),

                    // Liste des communautés avec radio
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

            FormActions(
              onCancel: onBack,
              onSubmit: () {
                context.read<CommunityBloc>().add(
                  ConfirmChangeUserCommunityEvent(),
                );
                onBack();
              },
              submitLabel: 'Confirmer',
            ),
          ],
        );
      },
    );
  }
}

// ============================================================================
// CONFIRMATION SUPPRESSION COMMUNAUTÉ (MOBILE)
// ============================================================================

/// Écran mobile de confirmation de suppression d'une communauté
class MobileDeleteConfirmation extends StatelessWidget {
  final VoidCallback onBack;

  const MobileDeleteConfirmation({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommunityBloc, CommunityState>(
      builder: (context, state) {
        if (state is! CommunityLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        final community = state.selectedCommunity;
        if (community == null) return const SizedBox.shrink();

        return Column(
          children: [
            FormHeader(title: 'Supprimer la communauté', onBack: onBack),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    Center(
                      child: Icon(
                        Icons.warning_amber_rounded,
                        size: 64,
                        color: Colors.red[400],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Text(
                        'Voulez-vous vraiment supprimer la communauté "${community.name}" ?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[900],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        'Cette action est irréversible.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onBack,
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
                      onPressed: () {
                        context.read<CommunityBloc>().add(
                          DeleteCommunityEvent(communityId: community.code),
                        );
                        onBack();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Supprimer'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
