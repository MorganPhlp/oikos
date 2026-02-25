import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/admin/domain/interfaces/community_rep.dart';

class UpdateCommunityLogo {
  final CommunityRep repository;

  UpdateCommunityLogo(this.repository);

  Future<Either<Failure, void>> call(
    String communityCode,
    String logoFileName,
  ) async {
    return await repository.updateLogo(communityCode, logoFileName);
  }
}
