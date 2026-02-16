import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:oikos/core/error/exceptions.dart';
import '../models/aliment_model.dart';

abstract interface class CodeBarreRemoteDataSource {
  Future<AlimentModel> getAliment(String codeBarre);
  Future<AlimentModel?> getBetterAlternative(String categoryTag, String currentEcoScore);
}

class CodeBarreRemoteDataSourceImpl implements CodeBarreRemoteDataSource {
  final http.Client client;

  CodeBarreRemoteDataSourceImpl({required this.client});

  @override
  Future<AlimentModel> getAliment(String codeBarre) async {
    final url = Uri.parse('https://world.openfoodfacts.org/api/v0/product/$codeBarre.json');
    final response = await client.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 1 && jsonResponse['product'] != null) {
        return AlimentModel.fromJson(jsonResponse);
      } else {
        throw ServerException("Produit non trouvé sur l'API");
      }
    } else {
      throw ServerException("Erreur réseau ou serveur");
    }
  }

  @override
  Future<AlimentModel?> getBetterAlternative(String categoryTag, String currentEcoScore) async {
    // 1. Définition des cibles : on cherche une alternative A, B, C ou D.
    const targetGrades = ['a', 'b', 'c', 'd'];

    // 2. Nettoyage du score actuel
    String currentGradeLower = currentEcoScore.toLowerCase();

    // Est-ce que le produit actuel a un score valide ?
    bool isCurrentScoreKnown = currentGradeLower != 'unknown' &&
        currentGradeLower != '?' &&
        currentGradeLower != 'not-applicable' &&
        targetGrades.contains(currentGradeLower); // Vérifie si c'est bien a,b,c,d ou e

    // --- Fonction de recherche API optimisée ---
    Future<AlimentModel?> searchBestProduct(String targetGrade) async {
      final uri = Uri.parse('https://fr.openfoodfacts.org/cgi/search.pl').replace(
        queryParameters: {
          'action': 'process',
          // Filtre 0 : La catégorie
          'tagtype_0': 'categories',
          'tag_contains_0': 'contains',
          'tag_0': categoryTag,

          // Filtre 1 : Le pays
          //'tagtype_1': 'countries',
          //'tag_contains_1': 'contains',
          //'tag_1': 'france',

          // Filtre 2 : L'Eco-Score cible (Index remis à 2 car 1 existe)
          'tagtype_2': 'ecoscore_grade',
          'tag_contains_2': 'contains',
          'tag_2': targetGrade,

          // Tri par popularité (évite les produits bizarres)
          'sort_by': 'unique_scans_n',

          // Pagination : 1 seul résultat suffit
          'page_size': '1',
          'json': 'true',

          // OPTIMISATION CRITIQUE : On ne demande que les champs nécessaires
          // Cela rend la requête beaucoup plus rapide (moins de données à télécharger)
          'fields': 'product_name,brands,image_url,ecoscore_grade,nutriscore_grade,code,categories_tags'
        },
      );

      try {
        // Timeout de 6 secondes pour ne pas bloquer l'interface trop longtemps
        final response = await client.get(uri).timeout(const Duration(seconds: 6));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final List<dynamic> products = data['products'] ?? [];
          if (products.isNotEmpty) {
            return AlimentModel.fromJson(products.first);
          }
        }
      } catch (e) {
        // En cas d'erreur ou timeout, on passe silencieusement au suivant
        return null;
      }
      return null;
    }

    // --- BOUCLE DE STRATÉGIE CORRIGÉE ---
    for (final targetGrade in targetGrades) {

      // REGLE D'ARRET :
      // Si le score actuel est CONNU (ex: 'c')
      // ET que le grade qu'on vise (ex: 'c' ou 'd') est pire ou égal...
      // ALORS on arrête de chercher. On ne veut proposer que MIEUX.
      // (rappel: 'a' < 'b' est vrai alphabétiquement)
      if (isCurrentScoreKnown && targetGrade.compareTo(currentGradeLower) >= 0) {
        return null;
      }

      // Si le score est INCONNU, on ignore la condition ci-dessus et on cherche quand même (A, puis B...).

      // On lance la recherche pour ce grade
      final result = await searchBestProduct(targetGrade);

      // Si on trouve un produit, c'est forcément le meilleur possible dans l'ordre de la boucle.
      // On le renvoie immédiatement.
      if (result != null) {
        // Petite sécurité : on ne se suggère pas soi-même (si on a scanné le meilleur produit de la catégorie)
        // Note: cela n'arrive que rarement car on cherche "mieux", mais utile pour les cas limites.
        return result;
      }
    }

    // Si on a fait toute la boucle sans rien trouver
    return null;
  }
}