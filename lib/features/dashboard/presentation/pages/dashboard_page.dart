import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
<<<<<<< HEAD
import 'package:contribution_heatmap/contribution_heatmap.dart';
import 'package:go_router/go_router.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/carbone_equivalent_entity.dart';
import 'package:oikos/features/bilanCarbone/presentation/widgets/bilan_category_bars.dart';
import 'package:oikos/features/bilanCarbone/presentation/widgets/bilan_category_pie_chart.dart';
import 'package:oikos/features/bilanCarbone/presentation/widgets/bilan_equivalents_list.dart';
import 'package:oikos/features/bilanCarbone/presentation/widgets/bilan_hero_score.dart';
=======
import 'package:oikos/features/dashboard/presentation/widgets/dashboard_back_button.dart';
import 'package:oikos/features/dashboard/presentation/widgets/dashboard_bilan_carbone_section.dart';
import 'package:oikos/features/dashboard/presentation/widgets/dashboard_bilan_vs_actions_radar.dart';
import 'package:oikos/features/dashboard/presentation/widgets/dashboard_co2_saved_over_time_chart.dart';
import 'package:oikos/features/dashboard/presentation/widgets/dashboard_streaks_section.dart';
import 'package:oikos/features/dashboard/presentation/fake/dashboard_fake_data.dart';
>>>>>>> feature/dashboard
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
<<<<<<< HEAD
    final theme = Theme.of(context);//theme global de l'appli
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => context.go('/home'), // Retour direct au home avec go_router
        ),
        title: Text(
          "Tableau de bord",
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
      ),

      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }
=======
    if (widget.useFakeData) {
      final now = DateTime.now();
      final maxDate = DateTime(now.year, now.month, now.day);
      final minDate = DashboardFakeData.subtractMonths(maxDate, 5);
      final heatmapEntries = DashboardFakeData.buildFakeHeatmapEntries(
        minDate: minDate,
        maxDate: maxDate,
      );
>>>>>>> feature/dashboard

      final fakeBilanScores = DashboardFakeData.fakeBilanScoresKg();
      final fakeBilanTotal = DashboardFakeData.fakeBilanTotalKg(fakeBilanScores);
      final fakeActions = DashboardFakeData.fakeActionsCountsByCategory();
      final fakeXpSeries = DashboardFakeData.buildFakeXpGainedSeries(
        minDate: minDate,
        maxDate: maxDate,
      );

<<<<<<< HEAD
          if (state is DashboardLoaded) {
            // approx. 3 mois = ~13 semaines (colonnes)
            const visibleWeeks = 13;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 28),
                      Text(
                        'Streaks',
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),

                      // Viewport largeur écran + scroll horizontal
                      LayoutBuilder(
                        builder: (context, constraints) {
                          // On adapte la taille des cases pour qu’environ 13 colonnes rentrent
                          // (le widget a aussi des labels à gauche; donc on prend une taille prudente)
                          final safeWidth = constraints.maxWidth;
                          final cellSpacing = 3.0;
                          final estimatedLabelWidth = 48.0; // marge pour les weekday labels
                          final usable = (safeWidth - estimatedLabelWidth).clamp(200.0, safeWidth);
                          final cellSize = ((usable - (visibleWeeks - 1) * cellSpacing) / visibleWeeks)
                              .clamp(10.0, 22.0);

                          // Après le premier layout, on se positionne à la fin (dernier mois)
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (!mounted) return;
                            _scrollHeatmapToLatest();
                          });

                          return SizedBox(
                            width: constraints.maxWidth, // <- ne dépasse jamais l'écran
                            child: SingleChildScrollView(
                              controller: _heatmapScrollController,
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              child: ContributionHeatmap(
                                heatmapColor: HeatmapColor.green,
                                showMonthLabels: true,
                                weekdayLabel: WeekdayLabel.none,
                                splittedMonthView: true,
                                showCellDate: false,
                                startWeekday: DateTime.monday,

                                // important pour le fitting + estimation "3 derniers mois"
                                padding: EdgeInsets.zero,
                                cellSize: cellSize,
                                cellSpacing: cellSpacing,
                                cellRadius: 6.0,

                                minDate: DateTime(2025, 8, 16),
                                maxDate: DateTime.now(),
                                entries: _fakeHeatmapEntries,
                                onCellTap: (date, value) {
                                  // ignore: avoid_print
                                  print('Tapped: $date with $value contributions');
                                },
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 24),
                      Text(
                        'Bilan Carbone',
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),

                      // Récap + objectif (même design que la page résultats)
                      const BilanHeroScore(scoreKg: _fakeScoreKg),
                      const SizedBox(height: 20),

                      BilanCategoryPieChart(scoresKg: _fakeScoresParCategorie),
                      const SizedBox(height: 16),

                      // Descriptif du camembert + pourcentages
                      BilanCategoryBars(scoresKg: _fakeScoresParCategorie, totalKg: _fakeScoreKg),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "C'est l'équivalent de :",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
=======
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
                          style: Theme.of(context).textTheme.headlineSmall,
                          textAlign: TextAlign.center,
>>>>>>> feature/dashboard
                        ),
                        const SizedBox(height: 24),
                        DashboardStreaksSection(
                          entries: heatmapEntries,
                          minDate: minDate,
                          maxDate: maxDate,
                        ),
                        const SizedBox(height: 24),
                        Column(
                          children: [
                            DashboardBilanCarboneSection(
                              scoreKg: fakeBilanTotal,
                              scoresParCategorieKg: fakeBilanScores,
                              equivalents: const [],
                            ),
                            const SizedBox(height: 24),
                            DashboardBilanVsActionsRadar(
                              bilanScoresKg: fakeBilanScores,
                              actionCountsByCategoryLabel: fakeActions,
                            ),
                            const SizedBox(height: 24),
                            DashboardXpGainedOverTimeChart(points: fakeXpSeries),
                          ],
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
                              style: Theme.of(context).textTheme.headlineSmall,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            DashboardStreaksSection(
                              entries: state.heatmapEntries,
                              minDate: state.heatmapMinDate,
                              maxDate: state.heatmapMaxDate,
                            ),
                            const SizedBox(height: 24),
                            if (bilan == null)
                              Text(
                                'Aucun bilan carbone disponible',
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              )
                            else
                              Column(
                                children: [
                                  DashboardBilanCarboneSection(
                                    scoreKg: bilan.scoreTotalKg,
                                    scoresParCategorieKg: bilan.detail.toMap(),
                                    equivalents: state.equivalents,
                                  ),
                                  const SizedBox(height: 24),
                                  DashboardBilanVsActionsRadar(
                                    bilanScoresKg: bilan.detail.toMap(),
                                    actionCountsByCategoryLabel: state.actionCountsByCategoryLabel,
                                  ),
                                  const SizedBox(height: 24),
                                  DashboardXpGainedOverTimeChart(points: state.xpGainedSeries),
                                ],
                              ),
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
