import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/actions_et_defis/domain/repositories/action_repository.dart';

class EcarterActionUseCase {
  final ActionRepository repository;

  EcarterActionUseCase({required this.repository});

  Future<Either<Failure, void>> call(String userId, String actionId) async {
    return await repository.ecarterAction(userId, actionId);
  }
}
