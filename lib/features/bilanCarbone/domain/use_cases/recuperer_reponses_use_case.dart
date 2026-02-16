import 'package:oikos/features/auth/domain/repository/auth_repository.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/reponse_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/bilan_repository.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/question_repository.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/reponse_repository.dart';

class RecupererReponsesUseCase {
  final ReponseRepository reponseRepository;
  final BilanSessionRepository bilanRepository;
  final QuestionRepository questionRepository;
  final AuthRepository authRepository;

  RecupererReponsesUseCase({
    required this.reponseRepository,
    required this.bilanRepository,
    required this.questionRepository,
    required this.authRepository,
  });

  Future<List<ReponseUtilisateurEntity>> call() async {
    final userId = await authRepository.getUserId();
    if (userId == null) throw Exception("Action impossible sans connexion");

    final int bilanId = await bilanRepository.getBilanId(userId);

    // Si bilanId est nul, on retourne une liste vide immédiatement
    final reponses = await reponseRepository.getReponses(bilanId);
    return reponses;
  }
}
