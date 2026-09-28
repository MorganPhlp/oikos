import 'package:oikos/core/common/domain/repositories/utilisateur_repository.dart';

class DefinirObjectifUseCase {
  final UtilisateurRepository utilisateurRepo;
  DefinirObjectifUseCase({required this.utilisateurRepo});
  Future<void> call(double objectifRatio) async {
    await utilisateurRepo.setObjetifsUtilisateur(objectifRatio);
  }
}
