import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/community/domain/entities/community_entity.dart';
import 'package:oikos/features/community/domain/entities/defi_entity.dart';
import 'package:oikos/features/community/domain/entities/participation_defi_entity.dart';
import 'package:oikos/features/community/domain/entities/vote_defi_entity.dart';
import 'package:oikos/features/community/domain/use_cases/fetch_adversaries_use_case.dart';
import 'package:oikos/features/community/domain/use_cases/fetch_defis.dart';
import 'package:oikos/features/community/domain/use_cases/fetch_participations_defis.dart';
import 'package:oikos/features/community/domain/use_cases/fetch_votes_use_case.dart';
import 'package:oikos/features/community/domain/use_cases/lancer_defi.dart';
import 'package:oikos/features/community/domain/use_cases/validate_defi.dart';
import 'package:oikos/features/community/domain/use_cases/vote_defi.dart';
import 'package:oikos/features/community/presentation/bloc/defis_state.dart';

class DefisCubit extends Cubit<DefisState> {
  final FetchDefisUseCase fetchDefisUseCase;
  final ValidateDefiUseCase validateDefiUseCase;
  final VoteDefiUseCase voteDefiUseCase;
  final FetchAdversariesUseCase fetchAdversariesUseCase;
  final LancerDefiUseCase lancerDefiUseCase;
  final FetchParticipationsDefisUseCase fetchParticipationsDefisUseCase;
  final FetchVotesUseCase fetchVotesUseCase;

  DefisCubit({
    required this.fetchDefisUseCase,
    required this.validateDefiUseCase,
    required this.voteDefiUseCase,
    required this.fetchAdversariesUseCase,
    required this.lancerDefiUseCase,
    required this.fetchVotesUseCase,
    required this.fetchParticipationsDefisUseCase,
  }) : super(DefisInitial());

  Future<void> loadDefis(String communityCode, String userId) async {
    try {
      final results = await Future.wait([
        fetchDefisUseCase(communityCode),
        fetchAdversariesUseCase(communityCode),
        fetchParticipationsDefisUseCase(userId),
        fetchVotesUseCase(userId),
      ]);

      final defis = results[0] as List<DefiEntity>;
      final adversaries = results[1] as List<CommunityEntity>;
      final participationEither =
          results[2] as Either<Failure, List<ParticipationDefiEntity>>;
      final votesEither = results[3] as Either<Failure, List<VoteDefiEntity>>;

      // Déplier les Either pour émettre l'état final
      participationEither.fold((failure) => emit(DefisError(failure.message)), (
        participationList,
      ) {
        votesEither.fold((failure) => emit(DefisError(failure.message)), (
          votesList,
        ) {
          emit(
            DefisLoaded(
              defis: defis,
              adversaries: adversaries,
              participations: participationList,
              votes: votesList,
            ),
          );
        });
      });
    } catch (e) {
      emit(DefisError("Erreur lors du chargement : ${e.toString()}"));
    }
  }

  /// Propose un nouveau duel
  Future<void> proposeDuel(LancerDefiParams params, String myComm) async {
    try {
      final result = await lancerDefiUseCase(params);

      result.fold((failure) => emit(DefisError(failure.message)), (_) async {
        await Future.delayed(const Duration(milliseconds: 800));
        loadDefis(myComm, params.userId);
      });
    } catch (e) {
      emit(DefisError("Impossible de lancer le défi : ${e.toString()}"));
    }
  }

  Future<void> validateDefi(
    String defiId,
    String userId,
    String communityCode,
  ) async {
    try {
      await validateDefiUseCase(defiId, userId);
      await loadDefis(communityCode, userId); // Refresh avec userId
    } catch (e) {
      emit(DefisError(e.toString()));
    }
  }

  Future<void> voteForDefiLaunch({
    required String defiId,
    required String userId,
    required bool isFavorable,
    required String communityCode,
  }) async {
    try {
      await voteDefiUseCase(defiId, userId, isFavorable);
      await loadDefis(communityCode, userId); // Refresh avec userId
    } catch (e) {
      emit(DefisError(e.toString()));
    }
  }
}
