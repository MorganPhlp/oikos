import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/common/domain/entities/utilisateurs.dart';
import 'package:oikos/core/theme/admin_theme.dart';
import 'package:oikos/core/utils/utils.dart';
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
  final List<Utilisateurs> users;
  final VoidCallback onCreateCommunity;
  final Function(Community) onViewMembers;
  final Function(Community) onEditCode;
  final Function(Community) onDelete;
  final Function(Community) onEditLogo;

  const MobileCommunityList({
    super.key,
    required this.communities,
    required this.users,
    required this.onCreateCommunity,
    required this.onViewMembers,
    required this.onEditCode,
    required this.onDelete,
    required this.onEditLogo,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AdminColors.of(context);
    return Column(
      children: [
        _buildHeader(colors),
        Expanded(
          child: communities.isEmpty ? _buildEmptyState(colors) : _buildList(),
        ),
      ],
    );
  }

  Widget _buildHeader(AdminColors colors) {
    return Padding(
      padding: const EdgeInsets.all(AdminTheme.spacingMd),
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
                  color: colors.foreground,
                ),
              ),
              Text(
                '${communities.length} communauté${communities.length > 1 ? 's' : ''}',
                style: TextStyle(fontSize: 13, color: colors.mutedForeground),
              ),
            ],
          ),
          IconButton(
            onPressed: onCreateCommunity,
            icon: const Icon(Icons.add_circle_rounded),
            color: AdminTheme.actionGreen,
            iconSize: 32,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AdminColors colors) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.groups_rounded, size: 64, color: colors.mutedForeground),
          const SizedBox(height: AdminTheme.spacingMd),
          Text(
            'Aucune communauté',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colors.foreground,
            ),
          ),
          const SizedBox(height: AdminTheme.spacingSm),
          Text(
            'Appuyez sur + pour créer',
            style: TextStyle(fontSize: 14, color: colors.mutedForeground),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: AdminTheme.spacingMd,
        vertical: AdminTheme.spacingSm,
      ),
      itemCount: communities.length,
      separatorBuilder: (_, _) => const SizedBox(height: AdminTheme.spacingMd),
      itemBuilder: (context, index) {
        final community = communities[index];
        return MobileCommunityCard(
          community: community,
          rank: index + 1,
          onViewMembers: () => onViewMembers(community),
          onEditCode: () => onEditCode(community),
          onDelete: () => onDelete(community),
          onEditLogo: () => onEditLogo(community),
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
  final List<Utilisateurs> users;
  final VoidCallback onBack;
  final Function(Utilisateurs) onChangeUserCommunity;
  final Function(Utilisateurs) onRemoveUserFromCommunity;

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
    final colors = AdminColors.of(context);
    return Column(
      children: [
        _buildHeader(colors),
        Expanded(
          child: users.isEmpty
              ? Center(
                  child: Text(
                    'Aucun membre',
                    style: TextStyle(color: colors.mutedForeground),
                  ),
                )
              : _buildList(context),
        ),
      ],
    );
  }

  Widget _buildHeader(AdminColors colors) {
    return Container(
      padding: const EdgeInsets.all(AdminTheme.spacingMd),
      decoration: BoxDecoration(
        color: colors.background,
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
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_rounded),
            color: colors.mutedForeground,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  community.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colors.foreground,
                  ),
                ),
                Text(
                  '${users.length} membre${users.length > 1 ? 's' : ''}',
                  style: TextStyle(fontSize: 12, color: colors.mutedForeground),
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
      padding: const EdgeInsets.all(AdminTheme.spacingMd),
      itemCount: users.length,
      separatorBuilder: (_, _) => const SizedBox(height: AdminTheme.spacingMd),
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
  final Company company;

  const MobileCreateCommunity({
    super.key,
    required this.onBack,
    required this.company,
  });

  @override
  State<MobileCreateCommunity> createState() => _MobileCreateCommunityState();
}

class _MobileCreateCommunityState extends State<MobileCreateCommunity> {
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
    return BlocConsumer<CommunityBloc, CommunityState>(
      listenWhen: (prev, curr) {
        if (prev is! CommunityLoaded || curr is! CommunityLoaded) return false;
        return prev.operationStatus != curr.operationStatus;
      },
      listener: (context, state) {
        if (state is! CommunityLoaded) return;
        if (state.operationStatus == SectionStatus.success) {
          widget.onBack();
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
          children: [
            FormHeader(title: 'Créer une communauté', onBack: widget.onBack),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AdminTheme.spacingMd),
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
                    const SizedBox(height: AdminTheme.spacingLg),
                    FormTextField(
                      label: "Code d'accès *",
                      controller: _codeController,
                      error: _codeError,
                      hint: 'Ex: ECO2023',
                      maxLength: 6,
                      textCapitalization: TextCapitalization.characters,
                      onChanged: (_) => setState(() => _codeError = null),
                    ),
                    const SizedBox(height: AdminTheme.spacingSm),
                    Text(
                      'Le code sera automatiquement converti en majuscules',
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.mutedForeground,
                      ),
                    ),
                    const SizedBox(height: AdminTheme.spacingLg),
                    LogoPickerSection(
                      selectedLogoUrl: _selectedLogoUrl,
                      logos: logos,
                      isLoading: isLoadingLogos,
                      onSelect: (url) => setState(() => _selectedLogoUrl = url),
                    ),
                    if (errorMessage != null) ...[
                      const SizedBox(height: AdminTheme.spacingMd),
                      Text(
                        errorMessage,
                        style: const TextStyle(
                          color: AdminTheme.errorForeground,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            FormActions(
              onCancel: widget.onBack,
              onSubmit: _submit,
              submitLabel: 'Créer',
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

        final colors = AdminColors.of(context);
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
                padding: const EdgeInsets.all(AdminTheme.spacingMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReadOnlyField(
                      label: 'Membre',
                      value: user.pseudo,
                      subtitle: user.email,
                    ),
                    const SizedBox(height: AdminTheme.spacingXl),
                    Text(
                      'Nouvelle communauté',
                      style: TextStyle(
                        fontSize: 14,
                        color: colors.mutedForeground,
                      ),
                    ),
                    const SizedBox(height: AdminTheme.spacingMd),
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

        final colors = AdminColors.of(context);
        final community = state.selectedCommunity;
        if (community == null) return const SizedBox.shrink();

        return Column(
          children: [
            FormHeader(title: 'Supprimer la communauté', onBack: onBack),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AdminTheme.spacingMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AdminTheme.spacingXl),
                    const Center(
                      child: Icon(
                        Icons.warning_amber_rounded,
                        size: 64,
                        color: AdminTheme.errorForeground,
                      ),
                    ),
                    const SizedBox(height: AdminTheme.spacingXl),
                    Center(
                      child: Text(
                        'Voulez-vous vraiment supprimer la communauté "${community.name}" ?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: colors.foreground,
                        ),
                      ),
                    ),
                    const SizedBox(height: AdminTheme.spacingMd),
                    Center(
                      child: Text(
                        'Cette action est irréversible.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: colors.mutedForeground,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(AdminTheme.spacingMd),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onBack,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: AdminTheme.spacingMd,
                        ),
                        side: BorderSide(color: colors.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AdminTheme.radiusLg,
                          ),
                        ),
                      ),
                      child: const Text('Annuler'),
                    ),
                  ),
                  const SizedBox(width: AdminTheme.spacingMd),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<CommunityBloc>().add(
                          DeleteCommunityEvent(communityId: community.code),
                        );
                        onBack();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AdminTheme.errorForeground,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: AdminTheme.spacingMd,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AdminTheme.radiusLg,
                          ),
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

// ============================================================================
// SÉLECTION DU LOGO (MOBILE)
// ============================================================================

/// Écran mobile de sélection du logo d'une communauté
class MobileEditLogo extends StatefulWidget {
  final VoidCallback onBack;
  final String companyName;

  const MobileEditLogo({
    super.key,
    required this.onBack,
    required this.companyName,
  });

  @override
  State<MobileEditLogo> createState() => _MobileEditLogoState();
}

class _MobileEditLogoState extends State<MobileEditLogo> {
  String? _selectedLogoUrl;

  @override
  void initState() {
    super.initState();
    final state = context.read<CommunityBloc>().state;
    if (state is CommunityLoaded) {
      _selectedLogoUrl = state.selectedCommunity?.logoUrl;
      if (state.availableLogos == null) {
        context.read<CommunityBloc>().add(
          FetchLogosEvent(companyName: widget.companyName),
        );
      }
    }
  }

  void _submit() {
    if (_selectedLogoUrl == null) {
      widget.onBack();
      return;
    }
    final state = context.read<CommunityBloc>().state;
    if (state is CommunityLoaded && state.selectedCommunity != null) {
      context.read<CommunityBloc>().add(
        UpdateCommunityLogoEvent(
          communityCode: state.selectedCommunity!.code,
          logoUrl: _selectedLogoUrl!,
        ),
      );
    }
    widget.onBack();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommunityBloc, CommunityState>(
      builder: (context, state) {
        if (state is! CommunityLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        final colors = AdminColors.of(context);
        final community = state.selectedCommunity;
        if (community == null) return const SizedBox.shrink();

        final logos = state.availableLogos;
        final isLoadingLogos = state.isLoadingLogos;

        return Column(
          children: [
            FormHeader(title: 'Changer le logo', onBack: widget.onBack),

            // Logo actuel
            Padding(
              padding: const EdgeInsets.all(AdminTheme.spacingMd),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AdminTheme.radiusXxl),
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
                  const SizedBox(width: AdminTheme.spacingMd),
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
                          'Sélectionnez un nouveau logo',
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
            Expanded(
              child: isLoadingLogos
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AdminTheme.actionGreen,
                      ),
                    )
                  : logos == null || logos.isEmpty
                  ? Center(
                      child: Text(
                        'Aucun logo disponible',
                        style: TextStyle(color: colors.mutedForeground),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(AdminTheme.spacingMd),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: AdminTheme.spacingMd,
                            mainAxisSpacing: AdminTheme.spacingMd,
                          ),
                      itemCount: logos.length,
                      itemBuilder: (context, index) {
                        final url = logos[index];
                        final isSelected = _selectedLogoUrl == url;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedLogoUrl = url),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                AdminTheme.radiusLg,
                              ),
                              border: Border.all(
                                color: isSelected
                                    ? AdminTheme.actionGreen
                                    : colors.border,
                                width: isSelected ? 3 : 1,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                AdminTheme.radiusMd,
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

            FormActions(
              onCancel: widget.onBack,
              onSubmit: _submit,
              submitLabel: 'Enregistrer',
            ),
          ],
        );
      },
    );
  }
}

// ============================================================================
// BOTTOM SHEETS POUR L'ÉDITION (MOBILE)
// ============================================================================

/// Conteneur stylisé partagé par tous les bottom sheets d'édition
class _SheetContainer extends StatelessWidget {
  final Widget child;

  const _SheetContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = AdminColors.of(context);
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AdminTheme.radiusXxl),
        ),
      ),
      child: Column(
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: AdminTheme.spacingMd),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colors.muted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

/// Affiche un bottom sheet de création de communauté
void showMobileCreateCommunitySheet(BuildContext context, Company company) {
  final bloc = context.read<CommunityBloc>();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => BlocProvider.value(
      value: bloc,
      child: _SheetContainer(
        child: MobileCreateCommunity(
          company: company,
          onBack: () => Navigator.of(sheetContext).pop(),
        ),
      ),
    ),
  );
}

/// Affiche un bottom sheet de modification du code d'accès
void showMobileEditCodeSheet(BuildContext context, Community community) {
  final bloc = context.read<CommunityBloc>();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => BlocProvider.value(
      value: bloc,
      child: _SheetContainer(
        child: _EditCodeSheetContent(
          community: community,
          onClose: () => Navigator.of(sheetContext).pop(),
        ),
      ),
    ),
  );
}

/// Affiche un bottom sheet de confirmation de suppression
void showMobileDeleteConfirmSheet(BuildContext context, Community community) {
  final bloc = context.read<CommunityBloc>();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => BlocProvider.value(
      value: bloc,
      child: _SheetContainer(
        child: _DeleteConfirmSheetContent(
          community: community,
          onClose: () => Navigator.of(sheetContext).pop(),
        ),
      ),
    ),
  );
}

/// Affiche un bottom sheet de sélection du logo
void showMobileEditLogoSheet(
  BuildContext context,
  Community community,
  String companyName,
) {
  final bloc = context.read<CommunityBloc>();
  final currentState = bloc.state;
  if (currentState is CommunityLoaded && currentState.availableLogos == null) {
    bloc.add(FetchLogosEvent(companyName: companyName));
  }
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => BlocProvider.value(
      value: bloc,
      child: _SheetContainer(
        child: _EditLogoSheetContent(
          community: community,
          onClose: () => Navigator.of(sheetContext).pop(),
        ),
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// CONTENU DES BOTTOM SHEETS
// ─────────────────────────────────────────────────────────────────────────────

class _EditCodeSheetContent extends StatefulWidget {
  final Community community;
  final VoidCallback onClose;

  const _EditCodeSheetContent({required this.community, required this.onClose});

  @override
  State<_EditCodeSheetContent> createState() => _EditCodeSheetContentState();
}

class _EditCodeSheetContentState extends State<_EditCodeSheetContent> {
  late final TextEditingController _codeController;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(text: widget.community.code);
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CommunityBloc, CommunityState>(
      listenWhen: (prev, curr) {
        if (prev is! CommunityLoaded || curr is! CommunityLoaded) return false;
        return prev.operationStatus != curr.operationStatus;
      },
      listener: (context, state) {
        if (state is! CommunityLoaded) return;
        if (state.operationStatus == SectionStatus.success) {
          widget.onClose();
        }
      },
      builder: (context, state) {
        bool isSubmitting = false;
        String? errorMessage;
        if (state is CommunityLoaded) {
          isSubmitting = state.operationStatus == SectionStatus.loading;
          errorMessage = state.operationStatus == SectionStatus.failure
              ? state.operationError
              : null;
        }
        return Column(
          children: [
            FormHeader(title: "Modifier le code", onBack: widget.onClose),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AdminTheme.spacingMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReadOnlyField(
                      label: 'Communauté',
                      value: widget.community.name,
                    ),
                    const SizedBox(height: AdminTheme.spacingLg),
                    FormTextField(
                      label: "Nouveau code d'accès *",
                      controller: _codeController,
                      error: errorMessage,
                      hint: 'Ex: ECO2023',
                      maxLength: 6,
                      textCapitalization: TextCapitalization.characters,
                    ),
                    const SizedBox(height: AdminTheme.spacingMd),
                    const WarningBox(
                      message:
                          'Les membres devront utiliser le nouveau code pour rejoindre.',
                    ),
                  ],
                ),
              ),
            ),
            FormActions(
              onCancel: widget.onClose,
              onSubmit: () {
                context.read<CommunityBloc>().add(
                  UpdateCommunityCodeEvent(
                    newCode: _codeController.text,
                    communityId: widget.community.code,
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

class _DeleteConfirmSheetContent extends StatelessWidget {
  final Community community;
  final VoidCallback onClose;

  const _DeleteConfirmSheetContent({
    required this.community,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AdminColors.of(context);
    return Column(
      children: [
        FormHeader(title: 'Supprimer la communauté', onBack: onClose),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AdminTheme.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AdminTheme.spacingXl),
                const Center(
                  child: Icon(
                    Icons.warning_amber_rounded,
                    size: 64,
                    color: AdminTheme.errorForeground,
                  ),
                ),
                const SizedBox(height: AdminTheme.spacingXl),
                Center(
                  child: Text(
                    'Voulez-vous vraiment supprimer la communauté "${community.name}" ?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: colors.foreground,
                    ),
                  ),
                ),
                const SizedBox(height: AdminTheme.spacingMd),
                Center(
                  child: Text(
                    'Cette action est irréversible.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: colors.mutedForeground,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AdminTheme.spacingMd),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onClose,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: AdminTheme.spacingMd,
                    ),
                    side: BorderSide(color: colors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AdminTheme.radiusLg),
                    ),
                  ),
                  child: const Text('Annuler'),
                ),
              ),
              const SizedBox(width: AdminTheme.spacingMd),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<CommunityBloc>().add(
                      DeleteCommunityEvent(communityId: community.code),
                    );
                    onClose();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AdminTheme.errorForeground,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: AdminTheme.spacingMd,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AdminTheme.radiusLg),
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
  }
}

class _EditLogoSheetContent extends StatefulWidget {
  final Community community;
  final VoidCallback onClose;

  const _EditLogoSheetContent({required this.community, required this.onClose});

  @override
  State<_EditLogoSheetContent> createState() => _EditLogoSheetContentState();
}

class _EditLogoSheetContentState extends State<_EditLogoSheetContent> {
  late String? _selectedLogoUrl;

  @override
  void initState() {
    super.initState();
    _selectedLogoUrl = widget.community.logoUrl;
  }

  void _submit() {
    if (_selectedLogoUrl == null ||
        _selectedLogoUrl == widget.community.logoUrl) {
      widget.onClose();
      return;
    }
    context.read<CommunityBloc>().add(
      UpdateCommunityLogoEvent(
        communityCode: widget.community.code,
        logoUrl: _selectedLogoUrl!,
      ),
    );
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommunityBloc, CommunityState>(
      builder: (context, state) {
        if (state is! CommunityLoaded) {
          return const Center(child: CircularProgressIndicator());
        }
        final colors = AdminColors.of(context);
        final logos = state.availableLogos;
        final isLoadingLogos = state.isLoadingLogos;

        return Column(
          children: [
            FormHeader(title: 'Changer le logo', onBack: widget.onClose),
            Padding(
              padding: const EdgeInsets.all(AdminTheme.spacingMd),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AdminTheme.radiusXxl),
                    child: Image.network(
                      widget.community.avatarNetworkUrl,
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
                  const SizedBox(width: AdminTheme.spacingMd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.community.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: colors.foreground,
                          ),
                        ),
                        Text(
                          'Sélectionnez un nouveau logo',
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
            Expanded(
              child: isLoadingLogos
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AdminTheme.actionGreen,
                      ),
                    )
                  : logos == null || logos.isEmpty
                  ? Center(
                      child: Text(
                        'Aucun logo disponible',
                        style: TextStyle(color: colors.mutedForeground),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(AdminTheme.spacingMd),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: AdminTheme.spacingMd,
                            mainAxisSpacing: AdminTheme.spacingMd,
                          ),
                      itemCount: logos.length,
                      itemBuilder: (context, index) {
                        final url = logos[index];
                        final isSelected = _selectedLogoUrl == url;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedLogoUrl = url),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                AdminTheme.radiusLg,
                              ),
                              border: Border.all(
                                color: isSelected
                                    ? AdminTheme.actionGreen
                                    : colors.border,
                                width: isSelected ? 3 : 1,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                AdminTheme.radiusMd,
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
            FormActions(
              onCancel: widget.onClose,
              onSubmit: _submit,
              submitLabel: 'Enregistrer',
            ),
          ],
        );
      },
    );
  }
}
