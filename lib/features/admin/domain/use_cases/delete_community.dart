import 'package:oikos/features/admin/domain/interfaces/community_rep.dart';

class DeleteCommunity {
  final CommunityRep rep;

  DeleteCommunity(this.rep);

  Future<void> call(String communityId) async {
    await rep.deleteCommunity(communityId);
  }
}
