import '../entities/categorie_empreinte_entity.dart';

abstract class CategorieEmpreinteRepository {
  Future<List<CategorieEmpreinteEntity>> getCategories();
}