// features/bilanCarbone/domain/repositories/bilan_session_repository.dart
abstract class BilanSessionRepository {
  Future<int?> getBilanId(); // Ou mieux : getOrCreateBilanId()
  Future<void> createNewBilanSession();
}