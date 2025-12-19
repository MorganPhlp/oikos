import 'dart:convert';

import 'package:oikos/features/bilanCarbone/domain/entities/reponse_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/reponse_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReponseRepositoryImpl implements ReponseRepository {
  SupabaseClient supabaseClient;

  ReponseRepositoryImpl({required this.supabaseClient});

@override
  Future<void> saveReponse(ReponseUtilisateurEntity reponse) async {
    try {
      final data = reponse.toJson();

      await supabaseClient
          .from('reponse_utilisateur')
          .upsert(data, onConflict: 'bilan_id, question_id');
          
    } catch (e) {
      throw Exception('Erreur lors de la sauvegarde de la réponse : $e');
    }
  }

  @override
  Future<List<ReponseUtilisateurEntity>> getReponses(int bilanId) async {
    try {
      final response = await supabaseClient
          .from('reponse_utilisateur')
          .select()
          .eq('bilan_id', bilanId);
      final data = response as List<dynamic>;
      return data
          .map((json) => ReponseUtilisateurEntity.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des réponses : $e');
    }
  }

  @override
  /// Supprime toutes les réponses associées à un bilan spécifique
  Future<void> deleteReponsesForBilan(int bilanId) async {
    try {
      await supabaseClient
          .from('reponse_utilisateur')
          .delete()
          .eq('bilan_id', bilanId);
    } catch (e) {
      throw Exception('Erreur lors de la suppression des réponses : $e');
    }
  }

  @override
  Future<ReponseUtilisateurEntity?> getReponse(int bilanId, int questionId){
    try {
      return supabaseClient
          .from('reponse_utilisateur')
          .select()
          .eq('bilan_id', bilanId)
          .eq('question_id', questionId)
          .single()
          .then((json) => ReponseUtilisateurEntity.fromJson(json))
          // ignore: invalid_return_type_for_catch_error
          .catchError((_) => null);
    } catch (e) {
      throw Exception('Erreur lors de la récupération de la réponse : $e');
    }
  }

@override
  Future<Map<String, dynamic>> chargerSituationDepuisVue() async {
    try {
      // Note : Il est recommandé de passer bilanId en paramètre plutôt que d'utiliser une constante
      const bilanId = 0;
      final String utilisateurId = supabaseClient.auth.currentUser?.id ?? '';

      final response = await supabaseClient
          .from('vue_situation_publicodes')
          .select('question_slug, reponse_valeur, type_widget')
          .eq('bilan_id', bilanId)
          .eq('utilisateur_id', utilisateurId);

      final Map<String, dynamic> situation = {};

      for (var row in response) {
        final String parentSlug = row['question_slug'];
        // 1. On récupère la valeur brute qui peut être nulle
        final dynamic rawValueData = row['reponse_valeur'];
        final String typeWidget = row['type_widget'] ?? '';

        // 2. Si la valeur est nulle, on passe à la question suivante
        if (rawValueData == null) continue;

        // 3. On convertit en String pour les traitements de texte
        final String rawValue = rawValueData.toString();

        // --- CAS 1 : CHOIX MULTIPLE (Liste JSON) ---
        if (typeWidget == 'CHOIX_MULTIPLE' || rawValue.startsWith('[')) {
          try {
            final List<dynamic> values = jsonDecode(rawValue);
            for (var value in values) {
              if (value != null) {
                situation['$parentSlug . $value'] = "'oui'";
              }
            }
            continue;
          } catch (e) {
             // En cas d'erreur de parsing, on ne bloque pas la boucle
             print("Erreur parsing Liste JSON pour $parentSlug");
          }
        }

        // --- CAS 2 : COMPTEUR (Map JSON) ---
        if (typeWidget == 'COMPTEUR' || rawValue.startsWith('{')) {
          try {
            final Map<String, dynamic> counts = jsonDecode(rawValue);
            counts.forEach((key, val) {
              if (val != null) {
                situation['$parentSlug . $key'] = val;
              }
            });
            continue;
          } catch (e) {
            print("Erreur parsing Map JSON pour $parentSlug");
          }
        }

        // --- CAS 3 : VALEURS CLASSIQUES (Nombre ou Texte) ---
        final numericValue = double.tryParse(rawValue);
        if (numericValue != null) {
          situation[parentSlug] = numericValue;
        } else if (rawValue.isNotEmpty) {
          // Pour les textes, on ajoute les simples quotes pour Publicodes
          situation[parentSlug] = "'$rawValue'";
        }
      }

      return situation;
    } catch (e) {
      print("❌ Erreur lors du chargement de la situation: $e");
      return {};
    }
  }
}