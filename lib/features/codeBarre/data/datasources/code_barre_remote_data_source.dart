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

  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'User-Agent': 'OikosApp/1.0 (Android; contact@oikos.app)',
  };

  @override
  Future<AlimentModel> getAliment(String codeBarre) async {
    final url = Uri.parse('https://world.openfoodfacts.org/api/v0/product/$codeBarre.json');
    final response = await client.get(url, headers: _headers);

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
    const targetGrades = ['a', 'b', 'c', 'd'];
    String currentGradeLower = currentEcoScore.toLowerCase();

    // Est-ce que le produit actuel a un score valide (a,b,c,d,e) ?
    bool isCurrentScoreKnown = ['a', 'b', 'c', 'd', 'e'].contains(currentGradeLower);

    print("🚀 DÉBUT RECHERCHE V2 pour '$categoryTag' (Actuel: $currentGradeLower)");

    Future<AlimentModel?> searchBestProduct(String targetGrade) async {
      // On demande l'API V2 avec un page_size plus grand pour filtrer nous-mêmes les erreurs
      final uri = Uri.https('fr.openfoodfacts.org', '/api/v2/search', {
        'categories_tags': categoryTag,
        'ecoscore_grade': targetGrade,
        'countries_tags_en': 'france',
        'sort_by': 'unique_scans_n',
        'page_size': '10', // On en prend 10 pour être sûr de trouver le bon grade
        'fields': 'product_name,brands,image_url,ecoscore_grade,nutriscore_grade,code,categories_tags'
      });

      try {
        final response = await client.get(uri, headers: _headers).timeout(const Duration(seconds: 15));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final List<dynamic> products = data['products'] ?? [];

          // FILTRAGE STRICT CÔTÉ CLIENT
          // On parcourt les résultats pour trouver le premier qui a VRAIMENT le bon grade
          for (var product in products) {
            final String? realGrade = product['ecoscore_grade'];

            // Si le produit a bien le grade qu'on cherche (ex: on cherche 'a', le produit est 'a')
            if (realGrade != null && realGrade.toLowerCase() == targetGrade) {
              // Petite sécurité : éviter de proposer le produit qu'on vient de scanner
              // (On ne peut pas comparer les codes ici car on ne l'a pas passé en argument,
              // mais la probabilité est faible si on cherche une "meilleure" note).

              print("   ✅ VRAI ALTERNATIVE TROUVÉE : ${product['product_name']} (Eco: $realGrade)");
              return AlimentModel.fromJson(product);
            } else {
              print("   ⚠️ Rejeté : ${product['product_name']} a un grade ${realGrade} alors qu'on veut $targetGrade");
            }
          }

          print("   ❌ Aucun des 10 produits populaires n'avait réellement le grade $targetGrade");
          return null;

        } else {
          print("   ⚠️ ERREUR HTTP V2: ${response.statusCode}");
        }
      } catch (e) {
        print("   ❌ ERREUR V2: $e");
        return null;
      }
      return null;
    }

    // --- BOUCLE DE STRATÉGIE ---
    for (final targetGrade in targetGrades) {
      // On s'arrête si on cherche un score moins bon ou égal à celui qu'on a déjà
      // (Seulement si le score actuel est connu et valide)
      if (isCurrentScoreKnown && targetGrade.compareTo(currentGradeLower) >= 0) {
        print("🛑 Arrêt : On a atteint la qualité du produit actuel ($currentGradeLower).");
        return null;
      }

      final result = await searchBestProduct(targetGrade);
      if (result != null) {
        return result;
      }
    }

    print("🏁 FIN : Aucune alternative trouvée.");
    return null;
  }
}