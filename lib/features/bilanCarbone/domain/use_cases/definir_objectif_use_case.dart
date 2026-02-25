import 'package:oikos/core/common/domain/interfaces/user_rep.dart';


class DefinirObjectifUseCase {
  final UserRep utilisateurRepo;
  DefinirObjectifUseCase({required this.utilisateurRepo});
  void call(double objectifRatio) {
    utilisateurRepo.setObjetifsUtilisateur(objectifRatio);
  }
}