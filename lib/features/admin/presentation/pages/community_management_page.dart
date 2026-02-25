import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/theme/admin_theme.dart';
import 'package:oikos/core/theme/breakpoints.dart';
import 'package:oikos/core/common/domain/entities/utilisateurs.dart';
import 'package:oikos/features/admin/data/models/models.dart';
import 'package:oikos/features/admin/presentation/bloc/community_bloc.dart';
import 'package:oikos/features/admin/presentation/bloc/community_event.dart';
import 'package:oikos/features/admin/presentation/bloc/community_state.dart';
import 'package:oikos/features/admin/presentation/widget/community_page/mobile_views.dart';
import 'package:oikos/features/admin/presentation/widget/community_page/desktop_modals.dart';
import 'package:oikos/features/admin/presentation/widget/community_page/card_widgets.dart';

enum MobileView {
  /// Liste principale des communautés
  list,

  /// Liste des membres d'une communauté sélectionnée
  members,

  /// Formulaire pour changer un utilisateur de communauté
  changeUser,
}

class CommunityManagementPage extends StatefulWidget {
  final Utilisateurs user;
  final Company company;
  const CommunityManagementPage({
    super.key,
    required this.user,
    required this.company,
  });

  @override
  State<CommunityManagementPage> createState() =>
      _CommunityManagementPageState();
}

class _CommunityManagementPageState extends State<CommunityManagementPage> {
  @override
  void initState() {
    super.initState();
    context.read<CommunityBloc>().add(
      CommunityDataFetched(companyId: widget.company.id),
    );
  }

  Utilisateurs get user => widget.user;
  Company get company => widget.company;

  // ============================================================================
  // FEEDBACK
  // ============================================================================

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_rounded : Icons.check_circle_rounded,
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: AdminTheme.spacingSm),
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        backgroundColor: isError
            ? AdminTheme.errorForeground
            : AdminTheme.actionGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AdminTheme.radiusMd),
        ),
      ),
    );
  }

  // ============================================================================
  // NAVIGATION MOBILE
  // ============================================================================

  /// Navigue vers une vue mobile spécifique
  void _navigateTo(
    BuildContext context,
    MobileView view, {
    Community? community,
    Utilisateurs? user,
  }) {
    // Si on navigue vers changeUser, on sélectionne d'abord l'utilisateur
    if (view == MobileView.changeUser && user != null) {
      context.read<CommunityBloc>().add(SelectUserEvent(user: user));
    }
    context.read<CommunityBloc>().add(
      NavigateToMobileViewEvent(view: view, community: community, user: user),
    );
  }

  /// Retourne à la vue précédente (navigation mobile)
  void _goBack(BuildContext context) {
    context.read<CommunityBloc>().add(GoBackMobileEvent());
  }

  // ============================================================================
  // HELPERS
  // ============================================================================

  /// Récupère les utilisateurs d'une communauté spécifique
  List<Utilisateurs> _getUsers(String communityId, List<Utilisateurs> users) {
    return users.where((u) => u.codeCommunaute == communityId).toList();
  }

  // ============================================================================
  // BUILD
  // ============================================================================

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
          _showSnackBar(state.successMessage ?? 'Opération réussie');
          context.read<CommunityBloc>().add(ResetCommunityStatusEvent());
        } else if (state.operationStatus == SectionStatus.failure) {
          _showSnackBar(
            state.operationError ?? 'Une erreur est survenue',
            isError: true,
          );
          context.read<CommunityBloc>().add(ResetCommunityStatusEvent());
        }
      },
      builder: (context, state) {
        if (state is CommunityLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is CommunityFetchingError) {
          return Center(
            child: Text(
              "Erreur du chargement des données",
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        if (state is CommunityLoaded) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = Breakpoints.isMobile(constraints.maxWidth);

              if (isMobile) {
                return _buildMobileLayout(context, state);
              }
              return _buildDesktopLayout(context, constraints.maxWidth, state);
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  // ============================================================================
  // LAYOUT MOBILE
  // ============================================================================

  /// Construit le layout mobile (navigation par remplacement)
  Widget _buildMobileLayout(BuildContext context, CommunityLoaded state) {
    final communities = state.data.communities;
    final users = state.data.users;

    switch (state.currentMobileView) {
      case MobileView.list:
        return MobileCommunityList(
          communities: communities,
          users: users,
          onCreateCommunity: () =>
              showMobileCreateCommunitySheet(context, company),
          onViewMembers: (c) =>
              _navigateTo(context, MobileView.members, community: c),
          onEditCode: (c) => showMobileEditCodeSheet(context, c),
          onDelete: (c) => showMobileDeleteConfirmSheet(context, c),
          onEditLogo: (c) => showMobileEditLogoSheet(context, c, company.name),
        );

      case MobileView.members:
        return MobileMembersList(
          community: state.selectedCommunity!,
          users: _getUsers(state.selectedCommunity!.code, users),
          onBack: () => _goBack(context),
          onChangeUserCommunity: (u) =>
              _navigateTo(context, MobileView.changeUser, user: u),
          onRemoveUserFromCommunity: (u) {
            context.read<CommunityBloc>().add(
              RemoveUserFromCommunityEvent(userId: u.id),
            );
          },
        );

      case MobileView.changeUser:
        return MobileChangeUserCommunity(onBack: () => _goBack(context));
    }
  }

  // ============================================================================
  // LAYOUT DESKTOP
  // ============================================================================

  /// Construit le layout desktop (grille + modals)
  Widget _buildDesktopLayout(
    BuildContext context,
    double width,
    CommunityLoaded state,
  ) {
    final isTablet = Breakpoints.isTablet(width);
    final crossAxisCount = isTablet ? 3 : 5;
    final padding = isTablet ? 24.0 : 40.0;
    final communities = state.data.communities;

    // Largeur minimale pour éviter l'overflow horizontal
    final minWidth = isTablet ? 700.0 : 1000.0;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: minWidth,
          maxWidth: width > minWidth ? width : minWidth,
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bouton créer
              _buildCreateButton(context),

              const SizedBox(height: 24),

              // Grille ou état vide
              if (communities.isEmpty)
                _buildEmptyState(context)
              else
                _buildCommunitiesGrid(context, crossAxisCount, state),
            ],
          ),
        ),
      ),
    );
  }

  /// Construit la grille des communautés
  Widget _buildCommunitiesGrid(
    BuildContext context,
    int crossAxisCount,
    CommunityLoaded state,
  ) {
    final communities = state.data.communities;
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 400,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        childAspectRatio: 0.95,
      ),
      itemCount: communities.length,
      itemBuilder: (context, index) {
        final community = communities[index];
        return CommunityCard(
          index: index,
          onEditCode: () => _showEditCodeModal(context, index),
          onViewMembers: () => _showMembersModal(context, index),
          onDelete: () => _showDeleteConfirmation(context, community),
          onEditLogo: () => _showLogoPickerModal(context, index),
        );
      },
    );
  }

  /// Construit l'état vide (aucune communauté)
  Widget _buildEmptyState(BuildContext context) {
    final colors = AdminColors.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AdminTheme.spacingXxl),
      decoration: colors.cardDecoration,
      child: Column(
        children: [
          Icon(Icons.groups_rounded, size: 64, color: colors.mutedForeground),
          const SizedBox(height: AdminTheme.spacingMd),
          Text(
            'Aucune communauté',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: colors.foreground,
            ),
          ),
          const SizedBox(height: AdminTheme.spacingSm),
          Text(
            'Commencez par créer votre première communauté',
            style: TextStyle(fontSize: 14, color: colors.mutedForeground),
          ),
          const SizedBox(height: AdminTheme.spacingXl),
          ElevatedButton(
            onPressed: () => _showCreateCommunityModal(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AdminTheme.actionGreen,
              foregroundColor: AdminTheme.actionGreenForeground,
              padding: const EdgeInsets.symmetric(
                horizontal: AdminTheme.spacingXl,
                vertical: AdminTheme.spacingMd,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AdminTheme.radiusLg),
              ),
            ),
            child: const Text('Créer une communauté'),
          ),
        ],
      ),
    );
  }

  /// Construit le bouton "Créer une communauté"
  Widget _buildCreateButton(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AdminTheme.spacingXxl),
        ElevatedButton.icon(
          onPressed: () => _showCreateCommunityModal(context),
          icon: const Icon(Icons.add_rounded, size: 20),
          label: const Text('Créer une communauté'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AdminTheme.actionGreen,
            foregroundColor: AdminTheme.actionGreenForeground,
            padding: const EdgeInsets.symmetric(
              horizontal: AdminTheme.spacingLg,
              vertical: AdminTheme.spacingMd,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AdminTheme.radiusLg),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================================
  // MODALS DESKTOP
  // ============================================================================

  /// Affiche la modal de création de communauté
  void _showCreateCommunityModal(BuildContext context) {
    final bloc = context.read<CommunityBloc>();
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: CreateCommunityModal(company: company),
      ),
    );
  }

  /// Affiche la modal de modification du code
  void _showEditCodeModal(BuildContext context, int index) {
    final bloc = context.read<CommunityBloc>();
    bloc.add(SelectedCommunityEvent(index: index));
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(value: bloc, child: EditCodeModal()),
    );
  }

  /// Affiche la modal de la liste des membres
  void _showMembersModal(BuildContext context, int index) {
    final bloc = context.read<CommunityBloc>();
    bloc.add(SelectedCommunityEvent(index: index));
    showDialog(
      context: context,
      builder: (_) =>
          BlocProvider.value(value: bloc, child: MembersListModal()),
    );
  }

  /// Affiche le sélecteur de logo pour une communauté
  void _showLogoPickerModal(BuildContext context, int index) {
    final bloc = context.read<CommunityBloc>();
    bloc.add(SelectedCommunityEvent(index: index));
    bloc.add(FetchLogosEvent(companyName: company.name));
    showDialog(
      context: context,
      builder: (_) =>
          BlocProvider.value(value: bloc, child: const LogoPickerModal()),
    );
  }

  /// Affiche la confirmation de suppression d'une communauté
  void _showDeleteConfirmation(BuildContext context, Community community) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AdminTheme.radiusXl),
        ),
        title: const Text('Supprimer la communauté'),
        content: Text(
          'Voulez-vous vraiment supprimer la communauté "${community.name}" ?\n\nCette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<CommunityBloc>().add(
                DeleteCommunityEvent(communityId: community.code),
              );
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AdminTheme.errorForeground,
              foregroundColor: Colors.white,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}
