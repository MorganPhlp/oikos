import 'package:equatable/equatable.dart';
import 'package:oikos/features/actions_et_defis/domain/entities/habitude_entity.dart';
import '../../domain/entities/user_active_action_entity.dart';

abstract class HabitudeState extends Equatable {
  @override
  List<Object?> get props => [];
}

// État initial
class HabitudeInitial extends HabitudeState {}

// État de chargement
class HabitudeLoading extends HabitudeState {}

// État de succès avec la liste des habitudes
class HabitudeLoaded extends HabitudeState {
  final List<HabitudeEntity> habitudes;

  HabitudeLoaded({required this.habitudes});

  Set<String> get habitueActionIds => habitudes.map((e) => e.action.id).toSet();

  @override
  List<Object?> get props => [habitudes];
}

// État d'erreur
class HabitudeError extends HabitudeState {
  final String message;

  HabitudeError(this.message);

  @override
  List<Object?> get props => [message];
}
