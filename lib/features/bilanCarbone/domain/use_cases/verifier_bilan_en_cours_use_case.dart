import 'package:oikos/features/bilanCarbone/domain/repositories/bilan_repository.dart';

class VerifierBilanEnCoursUseCase {
  final BilanSessionRepository bilanSessionRepo;

  VerifierBilanEnCoursUseCase({required this.bilanSessionRepo});

  Future<bool> call() async {
    return await bilanSessionRepo.hasBilanEnCours();
  }
}
