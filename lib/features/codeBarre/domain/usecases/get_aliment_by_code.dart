import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/aliment_entity.dart';
import '../repositories/aliment_repository.dart';

class GetAlimentByCode implements UseCase<AlimentEntity, String> {
  final AlimentRepository repository;

  GetAlimentByCode(this.repository);

  @override
  Future<Either<Failure, AlimentEntity>> call(String params) async {
    // 'params' est ici le String du code-barres scanné
    return await repository.getAlimentByCode(params);
  }
}