import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/exceptions.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/actions/data/models/action_model.dart';
import 'package:oikos/features/community/data/models/community_model.dart';
import 'package:oikos/features/community/data/models/defi_model.dart';
import 'package:oikos/features/community/data/models/participation_defi_model.dart';
import 'package:oikos/features/community/data/models/vote_defi_model.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class DefisRemoteDatasrouce {
  final SupabaseClient supabase;

  DefisRemoteDatasrouce(this.supabase);

  Future<List<DefiModel>> getDefis(String communityCode) async {
    try {
      // 1. Récupérer les données de la vue (sans essayer de joindre 'actions')
      final response = await supabase
          .from('vue_defis_complet')
          .select()
          .or(
            'communaute_demandeur_code.eq.$communityCode,communaute_cible_code.eq.$communityCode',
          );

      final List<dynamic> data = response as List;
      List<DefiModel> defis = [];

      for (var json in data) {
        ActionModel? action;

        // 2. Si le défi est actif et possède un ID d'action, on fait une requête dédiée
        if (json['action_id'] != null) {
          final actionResponse = await supabase
              .from('actions')
              .select()
              .eq('id', json['action_id'])
              .single(); // On récupère une seule ligne

          action = ActionModel.fromJson(actionResponse);
        }

        // 3. On construit le modèle avec l'action récupérée
        defis.add(DefiModel.fromJson(json, action: action));
      }

      return defis;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<Either<Failure, void>> proposeDuel({
    required String userId,
    required String targetCommunityCode,
    required String categorieNom,
    required int durationDays,
    String? titrePersonnalise,
  }) async {
    try {
      final userRes = await supabase
          .from('utilisateur')
          .select('code_communaute')
          .eq('id', userId)
          .single();

      final myCommunityCode = userRes['code_communaute'] as String;

      await supabase.from('defi').insert({
        'createur_id': userId,
        'communaute_demandeur_code': myCommunityCode,
        'communaute_cible_code': targetCommunityCode,
        'categorie_nom': categorieNom,
        'titre_personnalise': titrePersonnalise,
        'status': 'VOTE_LANCEMENT',
        'is_global': false,
        'date_fin': DateTime.now()
            .add(Duration(days: durationDays))
            .toIso8601String(),
      });

      return const Right(null);
    } on PostgrestException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure("Une erreur inattendue est survenue : $e"));
    }
  }

  /// Enregistre un vote pour lancer le défi
  /// Le trigger SQL 'trg_after_new_vote' vérifiera automatiquement le seuil de 60%
  Future<void> voteForDefiLaunch(
    String defiId,
    String userId,
    bool isFavorable,
  ) async {
    await supabase.from('votes_lancement_defi').insert({
      'defi_id': defiId,
      'user_id': userId,
      'est_favorable': isFavorable,
    });
  }

  Future<void> validateDefiParticipation(String defiId, String userId) async {
    await supabase.from('defi_participation').insert({
      'defi_id': defiId,
      'user_id': userId,
    });
  }

  Future<List<CommunityModel>> getCommunities(String communityCode) async {
    final communityData = await supabase
        .from('communaute')
        .select('entreprise_id')
        .eq('code', communityCode)
        .single();

    final String? entrepriseId = communityData['entreprise_id'];

    if (entrepriseId == null) return [];

    final response = await supabase
        .from('vue_communaute_stats')
        .select()
        .eq('entreprise_id', entrepriseId)
        .neq('code', communityCode);

    return (response as List)
        .map((json) => CommunityModel.fromJson(json))
        .toList();
  }

  Future<Either<Failure, List<VoteDefiModel>>> fetchVotesDefis(
    String userId,
  ) async {
    try {
      final response = await supabase
          .from('vue_votes_defis')
          .select()
          .eq('user_id', userId);

      return Right(
        (response as List).map((j) => VoteDefiModel.fromJson(j)).toList(),
      );
    } on PostgrestException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure("Erreur inattendue : $e"));
    }
  }

  Future<Either<Failure, List<ParticipationDefiModel>>>
  fetchParticipationsDefis(String userId) async {
    try {
      final response = await supabase
          .from('vue_participations_defis')
          .select()
          .eq('user_id', userId);

      return Right(
        (response as List)
            .map((j) => ParticipationDefiModel.fromJson(j))
            .toList(),
      );
    } on PostgrestException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure("Erreur inattendue : $e"));
    }
  }
}
