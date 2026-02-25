import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/common/domain/interfaces/utilisateurs_rep.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/admin/data/models/aggregates/ranking_data.dart';
import 'package:oikos/features/admin/domain/interfaces/carbon_foot_print_rep.dart';
import 'package:oikos/features/admin/domain/interfaces/community_rep.dart';

class GetRankings {
  final CommunityRep repository;
  final UtilisateursRep userRepository;
  final CarbonFootPrintRep carbonFootPrintRepository;

  GetRankings({
    required this.repository,
    required this.userRepository,
    required this.carbonFootPrintRepository,
  });

  Future<Either<Failure, RankingData>> call(String companyId) async {
    final usersResult = await userRepository.getUsers(companyId);
    final carbonFootPrintsResult = await carbonFootPrintRepository
        .getUsersCarbon(companyId);
    final communitiesResult = await repository.getCommunityData(companyId);

    return usersResult.fold(
      (failure) => left(failure),
      (users) => carbonFootPrintsResult.fold(
        (failure) => left(failure),
        (carbonFootPrints) => communitiesResult.fold(
          (failure) => left(failure),
          (communities) {
            final filteredCommunities = communities
                .where((c) => c.membersCount! > 0 && c.plantXp! > 0 && c.avgScore! > 0)
                .toList();

            final filteredUsers = users
                .where(
                  (u) =>
                      carbonFootPrints.any((c) => c.userId == u.id) &&
                      u.impactScoreXp > 0,
                )
                .toList();

            final fileredCarbonFootPrints = carbonFootPrints
                .where(
                  (c) =>
                      filteredUsers.any((u) => u.id == c.userId && c.score > 0),
                )
                .toList();

            return right(
              RankingData(
                users: filteredUsers,
                carbonFootPrints: fileredCarbonFootPrints,
                communities: filteredCommunities,
              ),
            );
          },
        ),
      ),
    );
  }
}
