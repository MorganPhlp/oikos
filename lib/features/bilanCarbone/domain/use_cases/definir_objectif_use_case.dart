import 'package:oikos/core/common/domain/repositories/utilisateur_repository.dart';

class DefinirObjectifUseCase {
  final UtilisateurRepository utilisateurRepo;
  DefinirObjectifUseCase({required this.utilisateurRepo});
  void call(double objectifRatio) {
    utilisateurRepo.setObjetifsUtilisateur(objectifRatio);
  }
}