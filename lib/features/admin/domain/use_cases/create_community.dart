import 'package:oikos/features/admin/domain/interfaces/community_rep.dart';

class DuplicateCodeException implements Exception {
  final String message;
  DuplicateCodeException([this.message = "Le code est déjà existant"]);
  
  @override
  String toString() => message;
}

class CreateCommunity {
  final CommunityRep rep;
  CreateCommunity(this.rep);

  Future<void> call({
    required String name,
    required String code,
    required companyId,
    required String id,
  }) async {
    final bool codeExist = await rep.checkExistCode(code);

    if (codeExist) throw DuplicateCodeException("Le code est déjà Existant");
    await rep.createCommunity(
      name: name,
      code: code,
      companyId: companyId,
      id: id,
    );
  }
}
