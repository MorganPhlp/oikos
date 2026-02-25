import 'package:oikos/features/community/domain/repositories/defis_repository.dart';

class ValidateDefiUseCase {
  final DefisRepository repository;

  ValidateDefiUseCase(this.repository);

  Future<void> call(String defiId, String userId) async {
    print("Validation du défi $defiId pour l'utilisateur $userId"); // Debug
    await repository.validateDefiParticipation(defiId, userId);
  }
}
