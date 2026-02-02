
import 'package:oikos/features/admin/domain/interfaces/community_rep.dart';
import 'package:oikos/features/admin/domain/use_cases/create_community.dart';

class UpdateCommunityCode {
  final CommunityRep rep;

  UpdateCommunityCode(this.rep);

  Future<void> call(String newCode,String communityId) async{

    final bool codeExist = await rep.checkExistCode(newCode);

    if (codeExist == true ) {throw DuplicateCodeException("Le code est déjà Existant");}
    else { await rep.updateCode(newCode, communityId); }

  }
}
