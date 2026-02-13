import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/aliment_entity.dart';

abstract interface class AlimentRepository {

  // Méthode pour récupérer un aliment scanné
  Future<Either<Failure, AlimentEntity>> getAlimentByCode(String codeBarre);

}