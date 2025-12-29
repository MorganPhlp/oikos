import 'package:oikos/features/bilanCarbone/domain/entities/carbone_equivalent_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/repositories/carbone_equivalent_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CarboneEquivalentRepositoryImpl implements CarboneEquivalentRepository {
  final SupabaseClient supabaseClient;

  CarboneEquivalentRepositoryImpl({required this.supabaseClient});

  @override
  Future<List<CarboneEquivalentEntity>> fetchAllEquivalents() async {
    final response = await supabaseClient
        .from('carbone_equivalent')
        .select()
        .order('id', ascending: true);
    final data = response as List<dynamic>;
    return data
        .map((json) => CarboneEquivalentEntity.fromJson(json))
        .toList();
  }
}