import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/admin/data/models/models.dart';
import 'package:oikos/features/admin/domain/repositories/community_rep.dart';

class GetCommunityData {
  final CommunityRep repository;

  GetCommunityData(this.repository);

  Future<Either<Failure, CommunityData>> call(String companyId) async {
    final usersResult = await repository.getUserData(companyId);
    final communitiesResult = await repository.getCommunityData(companyId);
    final companiesResult = await repository.getCompanyData(companyId);

    return usersResult.fold(
      (failure) => left(failure),
      (users) => communitiesResult.fold(
        (failure) => left(failure),
        (communities) => companiesResult.fold(
          (failure) => left(failure),
          (companies) => right(CommunityData(
            users: users,
            communities: communities,
            companies: companies,
          )),
        ),
      ),
    );
  }
}
