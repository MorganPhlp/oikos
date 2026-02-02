import 'package:oikos/features/admin/domain/entities/community.dart';
import 'package:oikos/features/admin/domain/entities/user.dart';
import 'package:oikos/core/theme/breakpoints.dart';

abstract class CommunityEvent {}

// ============================================================================
// NAVIGATION MOBILE
// ============================================================================

/// Navigue vers une vue mobile spécifique
class NavigateToMobileViewEvent extends CommunityEvent {
  final MobileView view;
  final Community? community;
  final User? user;

  NavigateToMobileViewEvent({required this.view, this.community, this.user});
}

/// Retourne à la vue précédente (navigation mobile)
class GoBackMobileEvent extends CommunityEvent {}

class CommunityDataFetched extends CommunityEvent {}

class CommunityRefreshRequested extends CommunityEvent {}

class UpdateCommunityCodeEvent extends CommunityEvent {
  final String newCode;
  final String communityId;

  UpdateCommunityCodeEvent({required this.communityId, required this.newCode});
}

class UpdateUserEvent extends CommunityEvent {
  final User user;

  UpdateUserEvent({required this.user});
}

class SelectedCommunityEvent extends CommunityEvent {
  final int index;

  SelectedCommunityEvent({required this.index});
}

// ============================================================================
// GESTION UTILISATEUR DANS COMMUNAUTÉ
// ============================================================================

/// Change un utilisateur de communauté
class ChangeUserCommunityEvent extends CommunityEvent {
  final String userId;
  final String newCommunityId;

  ChangeUserCommunityEvent({
    required this.userId,
    required this.newCommunityId,
  });
}

/// Supprime un utilisateur d'une communauté (le retire sans supprimer le compte)
class RemoveUserFromCommunityEvent extends CommunityEvent {
  final String userId;

  RemoveUserFromCommunityEvent({required this.userId});
}

/// Sélectionne un utilisateur pour une action (changement de communauté, etc.)
class SelectUserEvent extends CommunityEvent {
  final User user;

  SelectUserEvent({required this.user});
}

/// Sélectionne la nouvelle communauté cible pour un changement
class SelectNewCommunityEvent extends CommunityEvent {
  final String communityId;

  SelectNewCommunityEvent({required this.communityId});
}

/// Confirme le changement de communauté de l'utilisateur sélectionné
class ConfirmChangeUserCommunityEvent extends CommunityEvent {}

/// Sélectionne une entreprise pour la création de communauté
class SelectCompanyEvent extends CommunityEvent {
  final String companyId;

  SelectCompanyEvent({required this.companyId});
}

class CreateNewCommunityEvent extends CommunityEvent {
  final String name;
  final String code;
  final String companyId;

  CreateNewCommunityEvent({
    required this.name,
    required this.code,
    required this.companyId,
  });
}

/// Supprime une communauté
class DeleteCommunityEvent extends CommunityEvent {
  final String communityId;

  DeleteCommunityEvent({required this.communityId});
}

class ResetCommunityStatusEvent extends CommunityEvent{
  
}