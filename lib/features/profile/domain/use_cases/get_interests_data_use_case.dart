import 'package:oikos/core/common/domain/entities/categorie_empreinte_entity.dart';
import 'package:oikos/core/common/domain/repositories/categorie_empreinte_repository.dart';

class GetInterestsDataUseCase {
  final CategorieEmpreinteRepository repository;

  GetInterestsDataUseCase(this.repository);

  Future<(List<CategorieEmpreinteEntity>, List<CategorieEmpreinteEntity>)>
  call() async {
    final results = await Future.wait([
      repository.getCategories(),
      repository.getSelectedCategories(),
    ]);

    return (results[0], results[1]);
  }
}