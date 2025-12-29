abstract class BilanSessionRepository {
  Future<int?> getBilanId(); 
  Future<void> createNewBilanSession();
}