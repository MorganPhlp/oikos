import 'package:equatable/equatable.dart';
import 'package:oikos/features/community/domain/entities/community_entity.dart';
import 'package:oikos/features/community/domain/entities/defi_entity.dart';
import 'package:oikos/features/community/domain/entities/participation_defi_entity.dart';
import 'package:oikos/features/community/domain/entities/vote_defi_entity.dart';
import '../../data/models/defi_model.dart';

sealed class DefisState extends Equatable {
  const DefisState();

  @override
  List<Object?> get props => [];
}

final class DefisInitial extends DefisState {}

final class DefisLoading extends DefisState {}

final class DefisLoaded extends DefisState {
  final List<DefiEntity> defis;
  final List<CommunityEntity> adversaries;
  final List<ParticipationDefiEntity>? participations;
  final List<VoteDefiEntity>? votes;

  const DefisLoaded({
    required this.defis,
    required this.adversaries,
    this.participations,
    this.votes,
  });

  @override
  List<Object?> get props => [defis, adversaries, participations, votes];
}

/// État d'erreur avec un message
final class DefisError extends DefisState {
  final String message;

  const DefisError(this.message);

  @override
  List<Object?> get props => [message];
}
