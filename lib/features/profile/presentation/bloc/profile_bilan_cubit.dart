import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/features/profile/domain/use_cases/get_questions_restantes_use_case.dart';
import 'package:oikos/features/profile/presentation/bloc/profile_bilan_state.dart';

class ProfileBilanCubit extends Cubit<ProfileBilanState>{

 GetQuestionsRestantesUseCase getQuestionsRestantesUseCase;

  ProfileBilanCubit({
    required this.getQuestionsRestantesUseCase,
  }) : super(const ProfileBilanState(questionsRestantes: 0));

  void updateQuestionsRestantes(String userId) async {
    int questionsRestantes = await getQuestionsRestantesUseCase.call(userId);
    emit(ProfileBilanState(questionsRestantes: questionsRestantes));
  }
}