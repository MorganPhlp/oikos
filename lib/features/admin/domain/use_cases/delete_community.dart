import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/admin/domain/repositories/community_rep.dart';

class DeleteCommunity {
  final CommunityRep rep;

  DeleteCommunity(this.rep);

  Future<Either<Failure, void>> call(String communityId) async {
    return await rep.deleteCommunity(communityId);
  }
}
