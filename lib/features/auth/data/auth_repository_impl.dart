import 'package:oikos/features/auth/domain/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient supabaseClient;

  AuthRepositoryImpl({required this.supabaseClient});

  @override
  Future<String?> getUserId() async {
    final user = supabaseClient.auth.currentUser;
    return user?.id;
  }
}