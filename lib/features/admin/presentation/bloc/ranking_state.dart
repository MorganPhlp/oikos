import 'package:oikos/core/common/domain/entities/utilisateurs.dart';
import 'package:oikos/features/admin/data/models/aggregates/ranking_data.dart';
import 'package:oikos/features/admin/data/models/core/community.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ENUMS
// ─────────────────────────────────────────────────────────────────────────────

enum RankingType { communities, users }

/// Critères de tri pour la vue Communauté
enum CommunitySortBy {
  /// CO₂ moyen par membre — du plus petit au plus grand (meilleur en premier)
  avgScore,

  /// XP plantes cumulées — du plus grand au plus petit
  plantXp,
}

/// Critères de tri pour la vue Utilisateur
enum UserSortBy {
  /// XP impact — du plus grand au plus petit
  impactScoreXp,

  /// Dernier bilan CO₂ — du plus petit au plus grand (meilleur en premier)
  carbonScore,
}

// ─────────────────────────────────────────────────────────────────────────────
// STATES
// ─────────────────────────────────────────────────────────────────────────────

abstract class RankingState {}

class RankingInitial extends RankingState {}

class RankingLoading extends RankingState {}

class RankingLoaded extends RankingState {
  final RankingData data;
  final RankingType rankingType;
  final CommunitySortBy communitySortBy;
  final UserSortBy userSortBy;

  /// `null` signifie "toutes les communautés"
  final String? selectedCommunityCode;

  /// Listes pré-triées prêtes à l'affichage
  final List<Community> sortedCommunities;
  final List<Utilisateurs> sortedUsers;

  RankingLoaded({
    required this.data,
    required this.rankingType,
    required this.communitySortBy,
    required this.userSortBy,
    required this.sortedCommunities,
    required this.sortedUsers,
    this.selectedCommunityCode,
  });

  RankingLoaded copyWith({
    RankingData? data,
    RankingType? rankingType,
    CommunitySortBy? communitySortBy,
    UserSortBy? userSortBy,
    bool clearCommunityFilter = false,
    String? selectedCommunityCode,
    List<Community>? sortedCommunities,
    List<Utilisateurs>? sortedUsers,
  }) {
    return RankingLoaded(
      data: data ?? this.data,
      rankingType: rankingType ?? this.rankingType,
      communitySortBy: communitySortBy ?? this.communitySortBy,
      userSortBy: userSortBy ?? this.userSortBy,
      selectedCommunityCode: clearCommunityFilter
          ? null
          : (selectedCommunityCode ?? this.selectedCommunityCode),
      sortedCommunities: sortedCommunities ?? this.sortedCommunities,
      sortedUsers: sortedUsers ?? this.sortedUsers,
    );
  }
}

class RankingError extends RankingState {
  final String message;
  RankingError({required this.message});
}
