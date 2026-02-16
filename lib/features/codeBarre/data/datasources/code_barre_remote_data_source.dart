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
    // Liste de référence pour comparer les scores
    const grades = ['a', 'b', 'c', 'd', 'e'];
    String currentGradeLower = currentEcoScore.toLowerCase();

    // Est-ce que le produit actuel a un score valide (a,b,c,d,e) ?
    bool isCurrentScoreKnown = grades.contains(currentGradeLower);

    print("🚀 DÉBUT RECHERCHE OPTIMISÉE pour '$categoryTag' (Actuel: $currentGradeLower)");

    Future<AlimentModel?> searchBestProduct(String targetGrade) async {
      // On demande 20 produits pour avoir du choix et pouvoir trier
      final uri = Uri.https('fr.openfoodfacts.org', '/api/v2/search', {
        'categories_tags': categoryTag,
        'ecoscore_grade': targetGrade,
        'countries_tags_en': 'france',
        'sort_by': 'unique_scans_n', // Toujours les plus populaires
        'page_size': '20',           // On élargit la recherche
        'fields': 'product_name,brands,image_url,ecoscore_grade,nutriscore_grade,code,categories_tags'
      });

      try {
        final response = await client.get(uri, headers: _headers).timeout(const Duration(seconds: 15));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          // On crée une liste modifiable pour pouvoir la trier
          final List<dynamic> products = List.from(data['products'] ?? []);

          if (products.isEmpty) return null;

          // 1. TRI INTELLIGENT : On trie du meilleur score (A) au pire (E)
          // Comme ça, le premier qu'on valide sera forcément le meilleur disponible
          products.sort((a, b) {
            String gradeA = (a['ecoscore_grade'] ?? 'z').toString().toLowerCase();
            String gradeB = (b['ecoscore_grade'] ?? 'z').toString().toLowerCase();
            return gradeA.compareTo(gradeB); // 'a' vient avant 'b'
          });

          // 2. PARCOURS ET SÉLECTION
          for (var product in products) {
            final String? realGrade = product['ecoscore_grade']?.toString().toLowerCase();

            // Vérification de base : le grade existe et est valide
            if (realGrade != null && grades.contains(realGrade)) {

              // CRITÈRE DE SUCCÈS :
              // - Soit on ne connait pas notre score actuel (donc tout est bon à prendre)
              // - Soit le score trouvé est STRICTEMENT meilleur (plus petit alphabétiquement) que le nôtre
              //   Exemple: 'b' < 'd' est VRAI.
              bool isBetter = !isCurrentScoreKnown || realGrade.compareTo(currentGradeLower) < 0;

              if (isBetter) {
                print("   ✅ TROUVÉ (Mieux que $currentGradeLower) : ${product['product_name']} (Eco: $realGrade)");
                return AlimentModel.fromJson(product);
              } else {
                // Optionnel : afficher ce qu'on rejette pour comprendre
                // print("   ! Rejeté : ${product['product_name']} ($realGrade) n'est pas mieux que $currentGradeLower");
              }
            }
          }

          // Si on arrive ici, aucun des 20 produits n'était mieux
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
    // On garde la boucle car l'API priorise quand même ce qu'on demande dans 'ecoscore_grade'
    // Mais grâce au "return" rapide ci-dessus, on sortira dès la première requête fructueuse.
    for (final targetGrade in ['a', 'b', 'c', 'd']) {

      // Sécurité : inutile de demander 'd' si on a déjà 'c'
      if (isCurrentScoreKnown && targetGrade.compareTo(currentGradeLower) >= 0) {
        break;
      }

      final result = await searchBestProduct(targetGrade);
      if (result != null) {
        return result; // On a trouvé une perle rare, on l'envoie !
      }
    }

    print("🏁 FIN : Aucune alternative trouvée.");
    return null;
  }
}