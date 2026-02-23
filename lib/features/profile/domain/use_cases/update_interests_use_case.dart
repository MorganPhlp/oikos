import 'package:oikos/core/common/domain/entities/categorie_empreinte_entity.dart';
import 'package:oikos/core/common/domain/repositories/categorie_empreinte_repository.dart';

class UpdateInterestsUseCase {
  final CategorieEmpreinteRepository repository;

  UpdateInterestsUseCase(this.repository);

  Future<void> call(List<CategorieEmpreinteEntity> selectedCategories) async {
    return repository.setSelectedCategories(selectedCategories);
  }
}