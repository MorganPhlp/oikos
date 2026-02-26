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
            

            return right(
              RankingData(
                users: users,
                carbonFootPrints: carbonFootPrints,
                communities: communities,
              ),
            );
          },
        ),
      ),
    );
  }
}
