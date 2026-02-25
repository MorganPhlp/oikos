import 'package:oikos/core/common/domain/entities/utilisateurs.dart';
import 'package:oikos/features/admin/data/models/models.dart';

import 'package:oikos/features/admin/presentation/pages/community_management_page.dart';

abstract class CommunityEvent {}

// ============================================================================
// NAVIGATION MOBILE
// ============================================================================

/// Navigue vers une vue mobile spécifique
class NavigateToMobileViewEvent extends CommunityEvent {
  final MobileView view;
  final Community? community;
  final Utilisateurs? user;

  NavigateToMobileViewEvent({required this.view, this.community, this.user});
}

/// Retourne à la vue précédente (navigation mobile)
class GoBackMobileEvent extends CommunityEvent {}

class CommunityDataFetched extends CommunityEvent {
  final String companyId;

  CommunityDataFetched({required this.companyId});
}

class CommunityRefreshRequested extends CommunityEvent {}

class UpdateCommunityCodeEvent extends CommunityEvent {
  final String newCode;
  final String communityId;

  UpdateCommunityCodeEvent({required this.communityId, required this.newCode});
}

class UpdateUserEvent extends CommunityEvent {
  final Utilisateurs user;

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
  final Utilisateurs user;

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
  final String? logoUrl;
  final String? description;

  CreateNewCommunityEvent({
    required this.name,
    required this.code,
    required this.companyId,
    this.logoUrl,
    this.description,
  });
}

/// Supprime une communauté
class DeleteCommunityEvent extends CommunityEvent {
  final String communityId;

  DeleteCommunityEvent({required this.communityId});
}

class ResetCommunityStatusEvent extends CommunityEvent {}

// ============================================================================
// GESTION DU LOGO DE COMMUNAUTÉ
// ============================================================================

/// Charge la liste des logos disponibles depuis le storage
class FetchLogosEvent extends CommunityEvent {
  final String companyName;

  FetchLogosEvent({required this.companyName});
}

/// Met à jour le logo d'une communauté
class UpdateCommunityLogoEvent extends CommunityEvent {
  final String communityCode;
  final String logoUrl;

  UpdateCommunityLogoEvent({
    required this.communityCode,
    required this.logoUrl,
  });
}
