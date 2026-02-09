
abstract class UtilisateurRepository{
  Future<Map<String, dynamic>?> obtenirUtilisateur(String id);
  Future<void> setObjetifsUtilisateur(double objectifRatio);
}