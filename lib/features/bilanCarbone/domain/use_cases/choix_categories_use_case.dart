import 'package:oikos/core/common/domain/entities/categorie_empreinte_entity.dart';
import 'package:oikos/core/common/domain/repositories/categorie_empreinte_repository.dart';

class ChoixCategoriesUseCase {
  final CategorieEmpreinteRepository categorieRepo;

  ChoixCategoriesUseCase({required this.categorieRepo});

  Future<void> call(
    {required List<CategorieEmpreinteEntity> categories}
  ) async {
    await categorieRepo.setSelectedCategories(categories);
  }

}