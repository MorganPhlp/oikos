import 'package:oikos/features/bilanCarbone/domain/entities/reponse_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/bilan_repository.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/question_repository.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/reponse_repository.dart';

class RecupererReponsesUseCase {
  final ReponseRepository reponseRepository;
  final BilanSessionRepository bilanRepository;
  final QuestionRepository questionRepository;

  RecupererReponsesUseCase({required this.reponseRepository, required this.bilanRepository, required this.questionRepository});

  Future<List<ReponseUtilisateurEntity>> call() async {
    final int? bilanId = await bilanRepository.getBilanId();

    // Si bilanId est nul, on retourne une liste vide immédiatement
    if (bilanId == null) {
      return [];
    }
    final reponses = await reponseRepository.getReponses(bilanId);
    return reponses;
  }
}