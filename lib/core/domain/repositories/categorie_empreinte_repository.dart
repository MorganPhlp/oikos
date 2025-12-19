import '../entities/categorie_empreinte_entity.dart';

abstract class CategorieEmpreinteRepository {
  Future<List<CategorieEmpreinteEntity>> getCategories();
  Future<void> setSelectedCategories(List<CategorieEmpreinteEntity> categories);
  Future<List<CategorieEmpreinteEntity>> getSelectedCategories();
}