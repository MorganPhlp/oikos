import 'package:oikos/core/common/domain/entities/categorie_empreinte_entity.dart';
import 'package:oikos/core/common/domain/interfaces/categorie_empreinte_repository.dart';

class DemarrerApprofondissementUseCase {
  final CategorieEmpreinteRepository categorieRepo;

  DemarrerApprofondissementUseCase({required this.categorieRepo});

  Future<List<CategorieEmpreinteEntity>> call() async {
    final categories = await categorieRepo.getCategories();
    return categories;
  }

}