import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../models/aliment_model.dart';

/*
*
* Effectue l’appel HTTP réel.
* Lance la requête vers l’URL d’OpenFoodFacts.
*
* */
abstract interface class CodeBarreRemoteDataSource {
  Future<AlimentModel> getAliment(String codeBarre);
  Future<AlimentModel?> getBetterAlternative(String categoryTag);
}

class CodeBarreRemoteDataSourceImpl implements CodeBarreRemoteDataSource {
  final http.Client client;

  CodeBarreRemoteDataSourceImpl({required this.client});

  @override
  Future<AlimentModel> getAliment(String codeBarre) async {
    // URL API OpenFoodFacts (v0 est stable et simple)
    final url = Uri.parse('https://world.openfoodfacts.org/api/v0/product/$codeBarre.json');

    final response = await client.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      // OpenFoodFacts renvoie status = 1 si le produit est trouvé
      if (jsonResponse['status'] == 1 && jsonResponse['product'] != null) {
        return AlimentModel.fromJson(jsonResponse);
      } else {
        // Produit non trouvé sur l'API
        throw ServerException("Produit non trouvé sur l'API");
      }
    } else {
      // Erreur réseau ou serveur
      throw ServerException("Erreur réseau ou serveur");
    }
  }

  @override
  Future<AlimentModel?> getBetterAlternative(String categoryTag) async {
    // On construit l'URL de recherche avec des filtres précis :
    // 1. tag_0 : La catégorie du produit scanné
    // 2. country : France (pour s'assurer qu'on peut l'acheter)
    // 3. sort_by : ecoscore_score (les A en premier)
    // 4. page_size : 1 (on ne veut que le meilleur)

    final uri = Uri.parse('https://fr.openfoodfacts.org/cgi/search.pl').replace(
      queryParameters: {
        'action': 'process',
        'tagtype_0': 'categories',
        'tag_contains_0': 'contains',
        'tag_0': categoryTag,      // La catégorie (ex: en:tomato-ketchups)
        'tagtype_1': 'countries',  // FILTRE PAYS
        'tag_contains_1': 'contains',
        'tag_1': 'france',         // VALEUR PAYS
        'sort_by': 'ecoscore_score', // TRI PAR ECOSCORE
        'page_size': '1',          // UN SEUL RESULTAT
        'json': 'true',            // FORMAT JSON
      },
    );

    try {
      final response = await client.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> products = data['products'] ?? [];

        if (products.isNotEmpty) {
          // On retourne le premier produit de la liste (le meilleur)
          return AlimentModel.fromJson(products.first);
        }
      }
      return null; // Pas d'alternative trouvée
    } catch (e) {
      // En cas d'erreur on renvoie null
      return null;
    }
  }
}