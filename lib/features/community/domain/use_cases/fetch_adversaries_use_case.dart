import 'package:oikos/features/community/domain/entities/community_entity.dart';
import 'package:oikos/features/community/domain/repositories/defis_repository.dart';

class FetchAdversariesUseCase {
  final DefisRepository repository;

  FetchAdversariesUseCase(this.repository);

  Future<List<CommunityEntity>> call(String communityCode) async {
    return await repository.getAvailableAdversaries(communityCode);
  }
}
