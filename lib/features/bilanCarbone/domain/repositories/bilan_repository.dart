abstract class BilanSessionRepository {
  Future<int?> getBilanId(); 
  Future<void> createNewBilanSession();
  Future<void> setBilanScore(double score);
  Future<bool> hasBilanEnCours();
  Future<void> deleteBilan();
}