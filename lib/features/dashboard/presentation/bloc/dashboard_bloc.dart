import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contribution_heatmap/contribution_heatmap.dart';
import 'package:oikos/core/usecase/usecase.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/carbone_equivalent_entity.dart';
import 'package:oikos/features/bilanCarbone/domain/use_cases/recuperer_equivalents_carbone_use_case.dart';
import '../../domain/usecases/get_my_profile.dart';
import '../../domain/usecases/get_my_latest_bilan_carbone_summary.dart';
import '../../domain/usecases/get_my_heatmap_data.dart';
import '../../domain/entities/dashboard_bilan_carbone_summary.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetMyPseudo _getMyPseudo;
  final GetMyLatestBilanCarboneSummary _getMyLatestBilan;
  final GetMyHeatmapData _getMyHeatmapData;
  final RecupererEquivalentsCarboneUseCase _equivalentsUseCase;

  DashboardBloc({
    required GetMyPseudo getMyPseudo,
    required GetMyLatestBilanCarboneSummary getMyLatestBilan,
    required GetMyHeatmapData getMyHeatmapData,
    required RecupererEquivalentsCarboneUseCase equivalentsUseCase,
  })  : _getMyPseudo = getMyPseudo,
        _getMyLatestBilan = getMyLatestBilan,
        _getMyHeatmapData = getMyHeatmapData,
        _equivalentsUseCase = equivalentsUseCase,
        super(DashboardInitial()) {
    on<DashboardLoadRequested>(_onDashboardLoadRequested);
  }

  Future<void> _onDashboardLoadRequested(
    DashboardLoadRequested event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());

    final pseudoRes = await _getMyPseudo(NoParams());

    await pseudoRes.fold(
      (failure) async => emit(DashboardError(message: failure.message)),
      (pseudo) async {
        final bilanRes = await _getMyLatestBilan(NoParams());

        final bilan = bilanRes.getOrElse((_) => null);

        // On charge les équivalents uniquement si on a un bilan à afficher.
        final List<CarboneEquivalentEntity> equivalents = bilan == null
            ? const []
            : await () async {
                try {
                  return await _equivalentsUseCase();
                } catch (_) {
                  return const <CarboneEquivalentEntity>[];
                }
              }();

        final heatmapRes = await _getMyHeatmapData(NoParams());
        final heatmap = heatmapRes.getOrElse((_) => null);

        final DateTime heatmapMinDate = heatmap?.minDate ?? DateTime.now().subtract(const Duration(days: 153));
        final DateTime heatmapMaxDate = heatmap?.maxDate ?? DateTime.now();
        final normalizedMin = DateTime(heatmapMinDate.year, heatmapMinDate.month, heatmapMinDate.day);
        final normalizedMax = DateTime(heatmapMaxDate.year, heatmapMaxDate.month, heatmapMaxDate.day);

        final entries = <ContributionEntry>[];
        if (!normalizedMax.isBefore(normalizedMin)) {
          for (var date = normalizedMin;
              !date.isAfter(normalizedMax);
              date = date.add(const Duration(days: 1))) {
            final count = heatmap?.dailyCounts[date] ?? 0;
            entries.add(ContributionEntry(date, count.clamp(0, 10)));
          }
        }

        emit(
          DashboardLoaded(
            pseudo: pseudo,
            bilanCarbone: bilan,
            equivalents: equivalents,
            heatmapEntries: entries,
            heatmapMinDate: normalizedMin,
            heatmapMaxDate: normalizedMax,
          ),
        );
      },
    );
  }
}
