import 'package:oikos/core/common/domain/entities/user.dart';
import 'package:oikos/features/admin/domain/models/aggregates/community_data.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ENUMS
// ─────────────────────────────────────────────────────────────────────────────

enum UsersSortOrder {
  /// Pseudo A → Z
  pseudoAsc,

  /// Pseudo Z → A
  pseudoDesc,
}

// ─────────────────────────────────────────────────────────────────────────────
// STATES
// ─────────────────────────────────────────────────────────────────────────────

abstract class UsersState {}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersLoaded extends UsersState {
  final CommunityData data;

  /// Liste pré-filtrée/triée prête à l'affichage
  final List<UserEntity> filteredUsers;

  final String searchQuery;

  /// `null` = toutes les communautés
  final String? selectedCommunityCode;

  final UsersSortOrder sortOrder;

  /// `true` pendant l'appel d'anonymisation
  final bool isAnonymizing;

  /// Message à afficher dans le SnackBar après une anonymisation réussie.
  /// Remis à `null` dès le prochain événement de filtre/tri.
  final String? successMessage;

  UsersLoaded({
    required this.data,
    required this.filteredUsers,
    required this.searchQuery,
    this.selectedCommunityCode,
    this.sortOrder = UsersSortOrder.pseudoAsc,
    this.isAnonymizing = false,
    this.successMessage,
  });

  UsersLoaded copyWith({
    CommunityData? data,
    List<UserEntity>? filteredUsers,
    String? searchQuery,
    String? selectedCommunityCode,
    bool clearCommunityFilter = false,
    UsersSortOrder? sortOrder,
    bool? isAnonymizing,
    String? successMessage,
    bool clearSuccessMessage = false,
  }) {
    return UsersLoaded(
      data: data ?? this.data,
      filteredUsers: filteredUsers ?? this.filteredUsers,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCommunityCode: clearCommunityFilter
          ? null
          : (selectedCommunityCode ?? this.selectedCommunityCode),
      sortOrder: sortOrder ?? this.sortOrder,
      isAnonymizing: isAnonymizing ?? this.isAnonymizing,
      successMessage: clearSuccessMessage
          ? null
          : (successMessage ?? this.successMessage),
    );
  }
}

class UsersError extends UsersState {
  final String message;
  UsersError({required this.message});
}
