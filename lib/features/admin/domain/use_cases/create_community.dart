import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/admin/domain/repositories/community_rep.dart';
import 'package:oikos/features/admin/data/models/models.dart';

class CreateCommunity {
  final CommunityRep rep;
  CreateCommunity(this.rep);

  Future<Either<Failure, void>> call(Community community) async {
    final codeExistResult = await rep.checkExistCode(community.code);

    return codeExistResult.fold(
      (failure) => left(failure),
      (codeExist) async {
        if (codeExist) {
          return left(Failure("Le code est déjà existant"));
        }
        return await rep.createCommunity(
          community
        );
      },
    );
  }
}
