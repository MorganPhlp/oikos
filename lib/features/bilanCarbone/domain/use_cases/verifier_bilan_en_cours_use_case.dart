import 'package:oikos/features/auth/domain/repository/auth_repository.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/bilan_repository.dart';

class VerifierBilanEnCoursUseCase {
  final BilanSessionRepository bilanSessionRepo;
  final AuthRepository authRepository;

  VerifierBilanEnCoursUseCase({
    required this.bilanSessionRepo,
    required this.authRepository,
  });

  Future<bool> call() async {
    final userId = await authRepository.getUserId();
    if (userId == null) {
      throw Exception("Action impossible sans connexion");
    }
    return await bilanSessionRepo.hasBilanEnCours(userId);
  }
}
