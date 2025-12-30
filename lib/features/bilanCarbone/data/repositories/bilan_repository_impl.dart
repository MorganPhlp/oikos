// features/bilanCarbone/data/repositories/bilan_session_repository_impl.dart
// Doit DEPENDRE de l'AuthRepository
import 'package:oikos/features/auth/domain/repository/auth_repository.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/bilan_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; 
// Et de la source de données pour l'accès à Supabase (si vous en avez une)

class BilanSessionRepositoryImpl implements BilanSessionRepository {
  final SupabaseClient supabaseClient; // Injecté
  final AuthRepository authRepo; // Injecté

  BilanSessionRepositoryImpl({required this.supabaseClient, required this.authRepo});
  
  @override
  Future<int?> getBilanId() async {
    try {
      // 1. Utiliser le Repo d'Auth pour obtenir l'ID utilisateur (nettoyage de la dépendance)
      final userId = await authRepo.getUserId();
      if (userId == null) return null; // Utilisateur non connecté

      // 2. Logique de récupération
      final response = await supabaseClient
          .from('bilan_carbone')
          .select('id,date_bilan')
          .eq('utilisateur_id', userId) // Utiliser l'ID du repo d'Auth
          .order('date_bilan', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response == null) return null;
      return response['id'] as int;
    } catch (e) {
      throw Exception('Erreur lors de la récupération de l\'ID du bilan : $e');
    }
  }

  @override
  Future<void> createNewBilanSession() async {
    try {
      // 1. Obtenir l'ID utilisateur via le repo d'Auth
      final userId = await authRepo.getUserId();
      if (userId == null) {
        throw Exception("Utilisateur non connecté. Impossible de créer une session de bilan.");
      }
      // 2. Insérer une nouvelle session de bilan dans la base de données
      await supabaseClient
          .from('bilan_carbone')
          .upsert({'id':0,'utilisateur_id': userId, 'date_bilan': DateTime.now().toIso8601String(),'scoretotalco2ean':0});
    } catch (e) {
      throw Exception('Erreur lors de la création d\'une nouvelle session de bilan : $e');
    }
  }
}