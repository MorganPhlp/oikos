import 'package:oikos/core/error/exceptions.dart';
import 'package:oikos/features/actions_et_defis/data/models/action_ecartee_model.dart';
import 'package:oikos/features/actions_et_defis/data/models/categorie_ecartee_model.dart';
import 'package:oikos/features/actions_et_defis/data/models/habitude_model.dart';
import 'package:oikos/features/actions_et_defis/data/models/limite_actions_freq_model.dart';
import 'package:oikos/features/actions_et_defis/data/models/tag_ecarte_model.dart';
import 'package:oikos/features/actions_et_defis/data/models/user_active_action_model.dart.dart';
import 'package:oikos/features/actions_et_defis/domain/entities/limite_action_freq_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/action_model.dart';

abstract interface class ActionRemoteDataSource {
  Future<List<ActionModel>> fetchActions(String userId);
  Future<List<UserActiveActionModel>> fetchMyActiveActions(String userId);
  Future<void> addToMyActions(String userId, String actionId);
  Future<void> validateAction(String userId, String actionId);
  Future<void> removeFromMyActions(String userId, String actionId);
  Future<void> addToHabitudes(String userId, String actionId);
  Future<void> removeFromHabitudes(String userId, String actionId);
  Future<List<HabitudeModel>> fetchMyHabitudes(String userId);
  Future<List<LimiteActionFreqEntity>> getLimiteActionsFreq();
  Future<void> ecarterAction(String userId, String actionId);
  Future<void> ecarterCategorie(String userId, String categorieNom);
  Future<void> ecarterTag(String userId, String tagNom);
  Future<List<ActionEcarteeModel>> fetchActionsEcartees(String userId);
  Future<List<CategorieEcarteeModel>> fetchCategoriesEcartees(String userId);
  Future<List<TagEcarteModel>> fetchTagsEcartees(String userId);
}

class ActionRemoteDataSourceImpl implements ActionRemoteDataSource {
  final SupabaseClient supabaseClient;
  ActionRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<ActionModel>> fetchActions(String userId) async {
    try {
      final prefsResponse = await supabaseClient
          .from('utilisateur_categorie_preference')
          .select('categorie_nom')
          .eq('utilisateur_id', userId);

      final List<String> myCategories = (prefsResponse as List)
          .map((e) => e['categorie_nom'] as String)
          .toList();

      final query = supabaseClient.from('actions').select();
      final data = myCategories.isNotEmpty
          ? await query.filter('categorie_nom', 'in', myCategories)
          : await query;

      return (data as List).map((json) => ActionModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException('Erreur chargement catalogue: $e');
    }
  }

  @override
  Future<void> addToMyActions(String userId, String actionId) async {
    try {
      await supabaseClient.from('actions_en_cours').insert({
        'utilisateur_id': userId,
        'action_id': actionId,
      });
    } on PostgrestException catch (e) {
      if (e.code == '23505') throw const ServerException('Action déjà suivie.');
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Erreur ajout action: $e');
    }
  }

  @override
  Future<void> validateAction(String userId, String actionId) async {
    try {
      // On ne passe plus l'XP, le trigger SQL s'en occupe
      await supabaseClient.from('realisation_actions').insert({
        'utilisateur_id': userId,
        'action_id': actionId,
      });
    } catch (e) {
      throw ServerException('Erreur validation: $e');
    }
  }

  @override
  Future<List<UserActiveActionModel>> fetchMyActiveActions(
    String userId,
  ) async {
    try {
      final response = await supabaseClient
          .from('vue_actions_en_cours')
          .select('*, actions(*)')
          .eq('utilisateur_id', userId);

      final data = response as List<dynamic>;

      return data.map((json) {
        return UserActiveActionModel.fromJson(json);
      }).toList();
    } catch (e) {
      throw ServerException(
        'Erreur lors du chargement des actions actives : $e',
      );
    }
  }

  @override
  Future<void> addToHabitudes(String userId, String actionId) async {
    try {
      await supabaseClient.from('utilisateur_habitudes').insert({
        'utilisateur_id': userId,
        'action_id': actionId,
      });
    } on PostgrestException catch (e) {
      if (e.code == '23505')
        throw const ServerException('Habitude déjà ajoutée.');
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Erreur ajout habitude: $e');
    }
  }

  @override
  Future<List<HabitudeModel>> fetchMyHabitudes(String userId) async {
    try {
      final response = await supabaseClient
          .from('utilisateur_habitudes')
          .select('*, actions(*)')
          .eq('utilisateur_id', userId);

      final data = response as List<dynamic>;

      return data.map((json) {
        return HabitudeModel.fromJson(json);
      }).toList();
    } catch (e) {
      throw ServerException('Erreur lors du chargement des habitudes : $e');
    }
  }

  @override
  Future<void> removeFromHabitudes(String userId, String actionId) async {
    try {
      await supabaseClient
          .from('utilisateur_habitudes')
          .delete()
          .eq('utilisateur_id', userId)
          .eq('action_id', actionId);
    } catch (e) {
      throw ServerException('Erreur lors du retrait de l\'habitude : $e');
    }
  }

  @override
  Future<void> removeFromMyActions(String userId, String actionId) async {
    try {
      await supabaseClient
          .from('actions_en_cours')
          .delete()
          .eq('utilisateur_id', userId)
          .eq('action_id', actionId);
    } catch (e) {
      throw ServerException('Erreur lors du retrait de l\'action : $e');
    }
  }

  @override
  Future<List<LimiteActionFreqEntity>> getLimiteActionsFreq() async {
    try {
      final response = await supabaseClient
          .from('limite_actions_freq')
          .select();

      final data = response as List<dynamic>;
      return data.map((json) => LimiteActionFreqModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException("Erreur lors de la récupération des limites : $e");
    }
  }

  @override
  Future<void> ecarterAction(String userId, String actionId) async {
    try {
      await supabaseClient.from('actions_ecartees').insert({
        'utilisateur_id': userId,
        'action_id': actionId,
      });
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        throw const ServerException('Action déjà écartée.');
      }
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Erreur écarter action: $e');
    }
  }

  @override
  Future<void> ecarterCategorie(String userId, String categorieNom) async {
    try {
      await supabaseClient.from('categories_ecartees').insert({
        'utilisateur_id': userId,
        'categorie_nom': categorieNom,
      });
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        throw const ServerException('Catégorie déjà écartée.');
      }
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Erreur écarter catégorie: $e');
    }
  }

  @override
  Future<void> ecarterTag(String userId, String tagNom) async {
    try {
      await supabaseClient.from('tags_ecartes').insert({
        'utilisateur_id': userId,
        'tag_nom': tagNom,
      });
    } on PostgrestException catch (e) {
      if (e.code == '23505') throw const ServerException('Tag déjà écarté.');
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Erreur écarter tag: $e');
    }
  }

  @override
  Future<List<ActionEcarteeModel>> fetchActionsEcartees(String userId) async {
    try {
      final response = await supabaseClient
          .from('actions_ecartees')
          .select('action_id')
          .eq('utilisateur_id', userId);
      final data = response as List<dynamic>;

      return data.map((json) => ActionEcarteeModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException('Erreur chargement actions écartées: $e');
    }
  }

  @override
  Future<List<CategorieEcarteeModel>> fetchCategoriesEcartees(
    String userId,
  ) async {
    try {
      final response = await supabaseClient
          .from('categories_ecartees')
          .select('categorie_nom')
          .eq('utilisateur_id', userId);
      final data = response as List<dynamic>;
      return data.map((json) => CategorieEcarteeModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException('Erreur chargement catégories écartées: $e');
    }
  }

  @override
  Future<List<TagEcarteModel>> fetchTagsEcartees(String userId) async {
    try {
      final response = await supabaseClient
          .from('tags_ecartes')
          .select('tag_nom')
          .eq('utilisateur_id', userId);
      final data = response as List<dynamic>;
      return data.map((json) => TagEcarteModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException('Erreur chargement tags écartés: $e');
    }
  }
}
