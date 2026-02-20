import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/admin/domain/repositories/community_rep.dart';

class UpdateCommunityCode {
  final CommunityRep rep;

  UpdateCommunityCode(this.rep);

  Future<Either<Failure, void>> call(String newCode, String communityId) async {
    final codeExistResult = await rep.checkExistCode(newCode);

    return codeExistResult.fold(
      (failure) => left(failure),
      (codeExist) async {
        if (codeExist) {
          return left(Failure("Le code est déjà existant"));
        }
        return await rep.updateCode(newCode, communityId);
      },
    );
  }
}
