import 'package:oikos/core/common/domain/entities/user.dart';

abstract class UtilisateurRepository {
  Future<Map<String, dynamic>?> obtenirUtilisateur(String id);
  Future<void> setObjetifsUtilisateur(double objectifRatio);
  Stream<UserEntity> watchUser(String id);
}
