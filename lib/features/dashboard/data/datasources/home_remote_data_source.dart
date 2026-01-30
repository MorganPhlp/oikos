import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class HomeRemoteDataSource {
  Future<String> getMyPseudo();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final SupabaseClient supabaseClient;
  HomeRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<String> getMyPseudo() async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) {
      throw AuthException('User not logged in');
    }

    final data = await supabaseClient
        .from('utilisateur')
        .select('pseudo')
        .eq('id', user.id)
        .single();

    final pseudo = data['pseudo'] as String?;
    if (pseudo == null || pseudo.isEmpty) {
      throw Exception('Pseudo not found');
    }

    return pseudo;
  }
}
