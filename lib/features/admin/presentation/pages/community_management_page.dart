import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/theme/admin_theme.dart';
import 'package:oikos/core/theme/breakpoints.dart';
import 'package:oikos/features/admin/domain/entities/community.dart';
import 'package:oikos/features/admin/presentation/bloc/community_bloc.dart';
import 'package:oikos/features/admin/presentation/bloc/community_event.dart';
import 'package:oikos/features/admin/presentation/bloc/community_state.dart';
import 'package:oikos/features/admin/presentation/widget/community_page/mobile_views.dart';
import 'package:oikos/features/admin/presentation/widget/community_page/desktop_modals.dart';
import 'package:oikos/features/admin/presentation/widget/community_page/card_widgets.dart';
import 'package:oikos/features/admin/domain/entities/user.dart';

class CommunityManagementPage extends StatelessWidget {
  const CommunityManagementPage({super.key});

  // ============================================================================
  // NAVIGATION MOBILE
  // ============================================================================

  /// Navigue vers une vue mobile spécifique
  void _navigateTo(
    BuildContext context,
    MobileView view, {
    Community? community,
    User? user,
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
  List<User> _getUsers(String communityId, List<User> users) {
    return users.where((u) => u.communityId == communityId).toList();
  }

  // ============================================================================
  // BUILD
  // ============================================================================

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommunityBloc, CommunityState>(
      builder: (context, state) {
        if (state is CommunityLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is CommunityFetchingError) {
          // final String message = state.message;
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
              _navigateTo(context, MobileView.createCommunity),
          onViewMembers: (c) =>
              _navigateTo(context, MobileView.members, community: c),
          onEditCode: (c) =>
              _navigateTo(context, MobileView.editCode, community: c),
          onDelete: (c) =>
              _navigateTo(context, MobileView.deleteConfirm, community: c),
        );

      case MobileView.members:
        return MobileMembersList(
          community: state.selectedCommunity!,
          users: _getUsers(state.selectedCommunity!.id, users),
          onBack: () {
            _goBack(context);
            context.read<CommunityBloc>().add(ResetCommunityStatusEvent());
          },
          onChangeUserCommunity: (u) =>
              _navigateTo(context, MobileView.changeUser, user: u),
          onRemoveUserFromCommunity: (u) {
            context.read<CommunityBloc>().add(
              RemoveUserFromCommunityEvent(userId: u.id),
            );
          },
        );

      case MobileView.createCommunity:
        return MobileCreateCommunity(
          onBack: () {
            _goBack(context);
            context.read<CommunityBloc>().add(ResetCommunityStatusEvent());
          },
        );

      case MobileView.editCode:
        return MobileEditCode(onBack: () {
            _goBack(context);
            context.read<CommunityBloc>().add(ResetCommunityStatusEvent());
          });

      case MobileView.changeUser:
        return MobileChangeUserCommunity(onBack: () {
            _goBack(context);
            context.read<CommunityBloc>().add(ResetCommunityStatusEvent());
          });

      case MobileView.deleteConfirm:
        return MobileDeleteConfirmation(onBack: () {
            _goBack(context);
            context.read<CommunityBloc>().add(ResetCommunityStatusEvent());
          });
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

              const SizedBox(height:24),

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
        );
      },
    );
  }

  /// Construit l'état vide (aucune communauté)
  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.groups, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Aucune communauté',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[900],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Commencez par créer votre première communauté',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _showCreateCommunityModal(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: CommunityColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
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
        const SizedBox(height: 40),
        ElevatedButton.icon(
          onPressed: () => _showCreateCommunityModal(context),
          icon: const Icon(Icons.add, size: 20),
          label: const Text('Créer une communauté'),
          style: ElevatedButton.styleFrom(
            backgroundColor: CommunityColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
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
      builder: (_) =>
          BlocProvider.value(value: bloc, child: CreateCommunityModal()),
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

  /// Affiche la confirmation de suppression d'une communauté
  void _showDeleteConfirmation(BuildContext context, Community community) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                DeleteCommunityEvent(communityId: community.id),
              );
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}
