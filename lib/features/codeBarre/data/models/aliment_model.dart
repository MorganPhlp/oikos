import '../../domain/entities/aliment_entity.dart';

//Il étend l'Entité
//ajoute la capacité de se construire à partir du JSON brut renvoyé par l'API.
class AlimentModel extends AlimentEntity {
  const AlimentModel({
    required super.codeBarre,
    required super.nom,
    super.marque,
    super.quantite,
    super.ecoScore,
    super.nutriScore,
    super.ingredients,
    super.imageUrl,
    super.categoriesTags,
  });

  factory AlimentModel.fromJson(Map<String, dynamic> json) {
    // OpenFoodFacts renvoie les infos dans un champ "product"
    // Si on passe directement l'objet "product", on l'utilise tel quel.
    final product = json['product'] ?? json;

    return AlimentModel(
      codeBarre: product['_id'] ?? product['code'] ?? '',
      nom: product['product_name'] ?? 'Nom inconnu',
      marque: product['brands'],
      // Conversion sécurisée pour la quantité car parfois string, parfois int
      quantite: _parseQuantity(product['product_quantity']),
      ecoScore: product['ecoscore_grade']?.toString().toUpperCase(),
      nutriScore: product['nutriscore_grade']?.toString().toUpperCase(),
      ingredients: product['ingredients_text'],
      imageUrl: product['image_front_small_url'] ?? // La plus légère
          product['image_small_url'] ??       // Une autre légère
          product['image_front_url'] ??       // La normale
          product['image_url'],               // La générique

      //Parsing de la liste des catégories
      categoriesTags: (product['categories_tags'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),

    );
  }

  // fonction utilitaire pour nettoyer la quantité
  static double? _parseQuantity(dynamic quantity) {
    if (quantity == null) return null;
    if (quantity is num) return quantity.toDouble();
    if (quantity is String) return double.tryParse(quantity);
    return null;
  }
}