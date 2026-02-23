import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/common/domain/entities/categorie_empreinte_entity.dart';
import 'package:oikos/features/profile/domain/use_cases/get_interests_data_use_case.dart';
import 'package:oikos/features/profile/domain/use_cases/update_interests_use_case.dart';
import 'package:oikos/features/profile/presentation/bloc/interests_state.dart';


class InterestsCubit extends Cubit<InterestsState> {
  final GetInterestsDataUseCase _getInterestsDataUseCase;
  final UpdateInterestsUseCase _updateInterestsUseCase;

  InterestsCubit({
    required GetInterestsDataUseCase getInterestsDataUseCase,
    required UpdateInterestsUseCase updateInterestsUseCase,
  })  : _getInterestsDataUseCase = getInterestsDataUseCase,
        _updateInterestsUseCase = updateInterestsUseCase,
        super(InterestsLoading());

  Future<void> loadInterests() async {
    emit(InterestsLoading());
    try {
      final data = await _getInterestsDataUseCase();
      emit(InterestsLoaded(
        allCategories: data.$1,
        selectedCategories: data.$2,
      ));
    } catch (e) {
      emit(InterestsError('Impossible de charger les intérêts : $e'));
    }
  }

  void toggleCategory(CategorieEmpreinteEntity category) {
    final currentState = state;
    if (currentState is InterestsLoaded) {
      final currentSelection = List<CategorieEmpreinteEntity>.from(currentState.selectedCategories);
      final existingIndex = currentSelection.indexWhere((c) => c.nom == category.nom); // Comparaison par nom pour éviter les problèmes d'instance

      if(existingIndex >= 0) {
        currentSelection.removeAt(existingIndex);
      } else {
        currentSelection.add(category);
      }

      emit(InterestsLoaded(
        allCategories: currentState.allCategories,
        selectedCategories: currentSelection,
      ));
    }
  }

  Future<void> saveInterests() async {
    final currentState = state;
    if (currentState is InterestsLoaded) {
      try {
        await _updateInterestsUseCase(currentState.selectedCategories);
        emit(InterestsSaved());
      } catch (e) {
        emit(InterestsError('Impossible de sauvegarder les intérêts : $e'));
        loadInterests(); // Recharger les données pour revenir à l'état précédent en cas d'erreur
      }
    }
  }

}
