import 'package:oikos/features/profile/domain/repositories/bilan_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileBilanRepositoryImpl implements ProfileBilanRepository {

  SupabaseClient supabaseClient;

  ProfileBilanRepositoryImpl(this.supabaseClient);

  @override
  Future<int> getQuestionsRestantes(String userId) async {
    final response = await supabaseClient
        .from('vue_bilan_questions_restantes')
        .select()
        .eq('utilisateur_id', userId)
        .maybeSingle();
    return response?['questions_restantes'] as int? ?? 0;
  }
}