import 'package:oikos/features/admin/domain/entities/community.dart';
import 'package:oikos/features/admin/domain/interfaces/community_rep.dart';

class CommunityDataFetchedException implements Exception {
  final String message;
  CommunityDataFetchedException(this.message);
}

class GetCommunityData {
  final CommunityRep repository;

  GetCommunityData(this.repository);

  /// La méthode call permet d'appeler le use case comme une fonction : useCase()
  Future<CommunityData> call() async {

    final users = await repository.getUserData();
    final communities = await repository.getCommunityData();
    final companies = await repository.getCompanyData();

    return CommunityData(
      users: users,
      communities: communities,
      companies: companies,
    );

  }
}
