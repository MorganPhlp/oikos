import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/common/domain/interfaces/utilisateurs_rep.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/admin/data/models/models.dart';
import 'package:oikos/features/admin/domain/interfaces/community_rep.dart';

class GetCommunityData {
  final CommunityRep repository;
  final UtilisateursRep userRepository;

  GetCommunityData(this.repository, this.userRepository);

  Future<Either<Failure, CommunityData>> call(String companyId) async {
    final usersResult = await userRepository.getUsers(companyId);
    final communitiesResult = await repository.getCommunityData(companyId);

    return usersResult.fold(
      (failure) => left(failure),
      (users) => communitiesResult.fold(
        (failure) => left(failure),
        (communities) =>
            right(CommunityData(users: users, communities: communities)),
      ),
    );
  }
}
