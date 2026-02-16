import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:oikos/core/error/exceptions.dart';
import '../models/aliment_model.dart';

abstract interface class CodeBarreRemoteDataSource {
  Future<AlimentModel> getAliment(String codeBarre);
  // MODIFICATION : On ajoute le paramètre currentEcoScore
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
    // Liste des grades qu'on veut tester comme alternative (on ne cherche jamais E comme alternative)
    const targetGrades = ['a', 'b', 'c', 'd'];

    // On normalise le score actuel en minuscule pour comparer
    String currentGradeLower = currentEcoScore.toLowerCase();

    // Fonction de recherche interne
    Future<AlimentModel?> searchBestProduct(String grade) async {
      final uri = Uri.parse('https://fr.openfoodfacts.org/cgi/search.pl').replace(
        queryParameters: {
          'action': 'process',
          'tagtype_0': 'categories', 'tag_contains_0': 'contains', 'tag_0': categoryTag,
          'tagtype_1': 'countries', 'tag_contains_1': 'contains', 'tag_1': 'france',
          'tagtype_2': 'ecoscore_grade', 'tag_contains_2': 'contains', 'tag_2': grade,
          'sort_by': 'unique_scans_n', // Le plus populaire
          'page_size': '1',
          'json': 'true',
        },
      );

      try {
        final response = await client.get(uri);
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final List<dynamic> products = data['products'] ?? [];
          if (products.isNotEmpty) {
            return AlimentModel.fromJson(products.first);
          }
        }
      } catch (e) {
        return null;
      }
      return null;
    }

    // BOUCLE DE STRATÉGIE
    for (final grade in targetGrades) {
      // REGLE D'OR : Si le grade qu'on cherche est pire ou égal au grade actuel, on arrête.
      // Exemple : Si j'ai un 'C', je cherche A, puis B. Quand la boucle arrive à C, on stop.
      // (On utilise compareTo : 'a' < 'b')
      if (currentGradeLower != 'unknown' && currentGradeLower != '?' && currentGradeLower!= 'not-applicable') {
        currentGradeLower = 'e';
        if (grade.compareTo(currentGradeLower) >= 0){
          // Sinon, on tente de trouver un produit de ce grade
          final result = await searchBestProduct(grade);

          // Si on trouve, on renvoie direct (c'est le meilleur possible vu l'ordre de la boucle)
          if (result != null) {
            return result;
          }
        }

      }
    }

    return null;
  }
}