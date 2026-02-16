import 'package:oikos/features/profile/domain/repositories/bilan_repository.dart';

class GetQuestionsRestantesUseCase {
  final ProfileBilanRepository repository;

  GetQuestionsRestantesUseCase(this.repository);
  Future<int> call(String userId) async {
    return repository.getQuestionsRestantes(userId);
  }
}