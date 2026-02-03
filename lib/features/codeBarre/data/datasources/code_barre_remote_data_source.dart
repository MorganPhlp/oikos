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
}