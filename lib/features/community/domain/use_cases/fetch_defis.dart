import 'package:oikos/features/community/domain/entities/defi_entity.dart';
import 'package:oikos/features/community/domain/repositories/defis_repository.dart';

class FetchDefisUseCase {
  final DefisRepository repository;

  FetchDefisUseCase(this.repository);

  Future<List<DefiEntity>> call(String communityCode) {
    return repository.getDefis(communityCode);
  }
}
