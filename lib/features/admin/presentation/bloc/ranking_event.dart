import 'package:oikos/features/admin/presentation/bloc/ranking_state.dart';

abstract class RankingEvent {}

class RankingDataFetched extends RankingEvent {
  final String companyId;
  RankingDataFetched({required this.companyId});
}

class RankingTypeChanged extends RankingEvent {
  final RankingType rankingType;
  RankingTypeChanged({required this.rankingType});
}

class CommunitySortChanged extends RankingEvent {
  final CommunitySortBy sortBy;
  CommunitySortChanged({required this.sortBy});
}

class UserSortChanged extends RankingEvent {
  final UserSortBy sortBy;
  UserSortChanged({required this.sortBy});
}

/// `communityCode == null` → afficher toutes les communautés
class CommunityFilterChanged extends RankingEvent {
  final String? communityCode;
  CommunityFilterChanged({this.communityCode});
}
