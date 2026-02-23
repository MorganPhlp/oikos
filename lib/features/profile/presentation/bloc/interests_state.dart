import 'package:equatable/equatable.dart';

import '../../../../core/common/domain/entities/categorie_empreinte_entity.dart';

sealed class InterestsState extends Equatable {
  const InterestsState();

  @override
  List<Object> get props => [];
}

final class InterestsLoading extends InterestsState {}

final class InterestsLoaded extends InterestsState {
  final List<CategorieEmpreinteEntity> allCategories;
  final List<CategorieEmpreinteEntity> selectedCategories;

  const InterestsLoaded({
    required this.allCategories,
    required this.selectedCategories,
  });

  @override
  List<Object> get props => [allCategories, selectedCategories];
}

final class InterestsError extends InterestsState {
  final String message;

  const InterestsError(this.message);

  @override
  List<Object> get props => [message];
}

final class InterestsSaved extends InterestsState {}