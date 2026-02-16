import 'package:oikos/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';
import '../repository/dashboard_repository.dart';
import '../../../../core/usecase/usecase.dart';

class GetMyPseudo implements UseCase<String, NoParams> {
  final DashboardRepository repository;
  GetMyPseudo(this.repository);

  @override
  Future<Either<Failure, String>> call(NoParams params) {
    return repository.getMyPseudo();
  }
}
