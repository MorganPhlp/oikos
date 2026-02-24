import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/features/dashboard/presentation/widgets/dashboard_back_button.dart';
import 'package:oikos/features/dashboard/presentation/widgets/dashboard_bilan_carbone_section.dart';
import 'package:oikos/features/dashboard/presentation/widgets/dashboard_bilan_vs_actions_radar.dart';
import 'package:oikos/features/dashboard/presentation/widgets/dashboard_co2_saved_over_time_chart.dart';
import 'package:oikos/features/dashboard/presentation/widgets/dashboard_community_position_gauge.dart';
import 'package:oikos/features/dashboard/presentation/widgets/dashboard_streaks_section.dart';
import 'package:oikos/features/dashboard/presentation/fake/dashboard_fake_data.dart';
import '../bloc/dashboard_bloc.dart';

class DashboardPage extends StatefulWidget {
  static MaterialPageRoute<dynamic> route() =>
      MaterialPageRoute(builder: (_) => const DashboardPage());

  final bool useFakeData;

  const DashboardPage({super.key, this.useFakeData = true});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Widget _framed(BuildContext context, Widget child) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.8)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (!widget.useFakeData) {
        context.read<DashboardBloc>().add(DashboardLoadRequested());
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.useFakeData) {
      final now = DateTime.now();
      final maxDate = DateTime(now.year, now.month, now.day);
      final minDate = DashboardFakeData.subtractMonths(maxDate, 5);
      final heatmapEntries = DashboardFakeData.buildFakeHeatmapEntries(
        minDate: minDate,
        maxDate: maxDate,
      );

      final fakeBilanScores = DashboardFakeData.fakeBilanScoresKg();
      final fakeBilanTotal = DashboardFakeData.fakeBilanTotalKg(fakeBilanScores);
      final fakeActions = DashboardFakeData.fakeActionsCountsByCategory();
      final fakeXpSeries = DashboardFakeData.buildFakeXpGainedSeries(
        minDate: minDate,
        maxDate: maxDate,
      );

      final userPoints = fakeXpSeries.isNotEmpty ? fakeXpSeries.last.cumulativeXp : 0.0;
      final gauge = DashboardFakeData.buildFakeCommunityGaugeFromUserPoints(userPoints);

      return Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 56, 16, 16),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 700),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Statistiques',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        _framed(
                          context,
                          DashboardStreaksSection(
                            entries: heatmapEntries,
                            minDate: minDate,
                            maxDate: maxDate,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _framed(
                          context,
                          DashboardBilanCarboneSection(
                            scoreKg: fakeBilanTotal,
                            scoresParCategorieKg: fakeBilanScores,
                            equivalents: const [],
                          ),
                        ),
                        const SizedBox(height: 24),
                        _framed(
                          context,
                          DashboardBilanVsActionsRadar(
                            bilanScoresKg: fakeBilanScores,
                            actionCountsByCategoryLabel: fakeActions,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _framed(
                          context,
                          DashboardXpGainedOverTimeChart(points: fakeXpSeries),
                        ),
                        const SizedBox(height: 24),
                        _framed(
                          context,
                          DashboardCommunityPositionGauge(
                            userPoints: gauge.userPoints,
                            teamAveragePoints: gauge.teamAveragePoints,
                            top10PercentPoints: gauge.top10PercentPoints,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Positioned(
                left: 16,
                top: 12,
                child: DashboardBackButton(),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            BlocBuilder<DashboardBloc, DashboardState>(
              builder: (context, state) {
                if (state is DashboardLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is DashboardError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                if (state is DashboardLoaded) {
                  final bilan = state.bilanCarbone;
                  final community = state.communityPositioningStats;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 56, 16, 16),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 700),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Statistiques',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            _framed(
                              context,
                              DashboardStreaksSection(
                                entries: state.heatmapEntries,
                                minDate: state.heatmapMinDate,
                                maxDate: state.heatmapMaxDate,
                              ),
                            ),
                            const SizedBox(height: 24),
                            if (bilan == null)
                              Text(
                                'Aucun bilan carbone disponible',
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              )
                            else
                              ...[
                                _framed(
                                  context,
                                  DashboardBilanCarboneSection(
                                    scoreKg: bilan.scoreTotalKg,
                                    scoresParCategorieKg: bilan.detail.toMap(),
                                    equivalents: state.equivalents,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                _framed(
                                  context,
                                  DashboardBilanVsActionsRadar(
                                    bilanScoresKg: bilan.detail.toMap(),
                                    actionCountsByCategoryLabel: state.actionCountsByCategoryLabel,
                                  ),
                                ),
                              ],
                            const SizedBox(height: 24),
                            _framed(
                              context,
                              DashboardXpGainedOverTimeChart(points: state.xpGainedSeries),
                            ),
                            if (community != null) ...[
                              const SizedBox(height: 24),
                              _framed(
                                context,
                                DashboardCommunityPositionGauge(
                                  userPoints: community.userPoints,
                                  teamAveragePoints: community.communityAveragePoints,
                                  top10PercentPoints: community.communityTop10PercentPoints,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
            Positioned(
              left: 16,
              top: 12,
              child: DashboardBackButton(),
            ),
          ],
        ),
      ),
    );
  }
}