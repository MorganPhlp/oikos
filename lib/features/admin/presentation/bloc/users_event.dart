import 'package:oikos/core/common/domain/entities/utilisateurs.dart';
import 'package:oikos/features/admin/presentation/bloc/users_state.dart';

abstract class UsersEvent {}

/// Charge la liste des utilisateurs pour [companyId].
class UsersDataFetched extends UsersEvent {
  final String companyId;
  UsersDataFetched({required this.companyId});
}

/// Met à jour la recherche textuelle (pseudo / email).
class UsersSearchChanged extends UsersEvent {
  final String query;
  UsersSearchChanged({required this.query});
}

/// Filtre par communauté — `communityCode == null` = toutes les communautés.
class UsersCommunityFilterChanged extends UsersEvent {
  final String? communityCode;
  UsersCommunityFilterChanged({this.communityCode});
}

/// Change l'ordre de tri.
class UsersSortOrderChanged extends UsersEvent {
  final UsersSortOrder sortOrder;
  UsersSortOrderChanged({required this.sortOrder});
}

/// Demande l'anonymisation de [user].
class UsersAnonymizeRequested extends UsersEvent {
  final Utilisateurs user;
  UsersAnonymizeRequested({required this.user});
}
