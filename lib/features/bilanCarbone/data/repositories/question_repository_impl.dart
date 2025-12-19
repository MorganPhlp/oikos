import 'package:supabase_flutter/supabase_flutter.dart'; 
import '../../domain/repositories/question_repository.dart';
import '../../domain/entities/question_entity.dart';

class QuestionRepositoryImpl implements QuestionRepository {
  final SupabaseClient supabaseClient;

  QuestionRepositoryImpl({required this.supabaseClient});

  @override
  Future<List<QuestionBilanEntity>> getQuestions() async {
    try {
      final response = await supabaseClient
          .from('question_bilan')
          .select()
          .eq('est_obligatoire', true)
          .order('id', ascending: true);
      final data = response as List<dynamic>;
      return data
          .map((json) => QuestionBilanEntity.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des questions : $e');
    }
  }
}