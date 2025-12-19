import 'package:oikos/core/domain/repositories/utilisateur_repository.dart';

class DefinirObjectifUseCase {
  final UtilisateurRepository utilisateurRepo;
  DefinirObjectifUseCase({required this.utilisateurRepo});
  void call(double objectifRatio) {
    utilisateurRepo.setObjetifsUtilisateur(objectifRatio);
  }
}