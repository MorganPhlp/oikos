import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/community/domain/repositories/defis_repository.dart';

class LancerDefiUseCase {
  final DefisRepository repository;
  LancerDefiUseCase(this.repository);

  Future<Either<Failure, void>> call(LancerDefiParams params) async {
    return await repository.proposeDuel(
      userId: params.userId,
      targetCommunityCode: params.targetCommunityCode,
      categorieNom: params.categorieNom,
      durationDays: params.durationDays,
      titrePersonnalise: params.titrePersonnalise,
    );
  }
}

class LancerDefiParams {
  final String userId;
  final String targetCommunityCode;
  final String categorieNom;
  final int durationDays;
  final String? titrePersonnalise;

  LancerDefiParams({
    required this.userId,
    required this.targetCommunityCode,
    required this.categorieNom,
    required this.durationDays,
    this.titrePersonnalise,
  });
}
