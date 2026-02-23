import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contribution_heatmap/contribution_heatmap.dart';
import 'package:go_router/go_router.dart';
import 'package:oikos/features/bilanCarbone/domain/entities/carbone_equivalent_entity.dart';
import 'package:oikos/features/bilanCarbone/presentation/widgets/bilan_category_bars.dart';
import 'package:oikos/features/bilanCarbone/presentation/widgets/bilan_category_pie_chart.dart';
import 'package:oikos/features/bilanCarbone/presentation/widgets/bilan_equivalents_list.dart';
import 'package:oikos/features/bilanCarbone/presentation/widgets/bilan_hero_score.dart';
import '../bloc/dashboard_bloc.dart';

class DashboardPage extends StatefulWidget {
  static MaterialPageRoute<dynamic> route() =>
      MaterialPageRoute(builder: (_) => const DashboardPage());

  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  static const double _fakeScoreKg = 8400.0;
  static const Map<String, double> _fakeScoresParCategorie = {
    'Transport': 2500.0,
    'Logement': 3000.0,
    'Alimentation': 1800.0,
    'Services': 1100.0,
  };

  static const List<CarboneEquivalentEntity> _fakeEquivalents = [
    CarboneEquivalentEntity(
      id: 1,
      equivalentLabel: 'Aller-retours Paris–Lyon en voiture',
      valeur1Tonne: 4.0,
      icone: '🚗',
    ),
    CarboneEquivalentEntity(
      id: 2,
      equivalentLabel: 'Burgers (repas)',
      valeur1Tonne: 60.0,
      icone: '🍔',
    ),
    CarboneEquivalentEntity(
      id: 3,
      equivalentLabel: 'Heures de streaming vidéo',
      valeur1Tonne: 900.0,
      icone: '📺',
    ),
    CarboneEquivalentEntity(
      id: 4,
      equivalentLabel: 'T-shirts neufs',
      valeur1Tonne: 120.0,
      icone: '👕',
    ),
    CarboneEquivalentEntity(
      id: 5,
      equivalentLabel: 'Charges de smartphone',
      valeur1Tonne: 100000.0,
      icone: '📱',
    ),
  ];

  late final List<ContributionEntry> _fakeHeatmapEntries;

  final ScrollController _heatmapScrollController = ScrollController();
  bool _scrolledToEndOnce = false;

  @override
  void initState() {
    super.initState();

    _fakeHeatmapEntries = _buildFakeHeatmapEntries(
      minDate: DateTime(2025, 8, 16),
      maxDate: DateTime.now(),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<DashboardBloc>().add(DashboardLoadRequested());
    });
  }

  @override
  void dispose() {
    _heatmapScrollController.dispose();
    super.dispose();
  }

  void _scrollHeatmapToLatest() {
    if (_scrolledToEndOnce) return;
    if (!_heatmapScrollController.hasClients) return;

    _scrolledToEndOnce = true;
    _heatmapScrollController.jumpTo(_heatmapScrollController.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
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
                        ),
                      ),
                      const SizedBox(height: 12),
                      BilanEquivalentsList(items: _fakeEquivalents, scoreKg: _fakeScoreKg),
                    ],
                  ),
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  List<ContributionEntry> _buildFakeHeatmapEntries({
    required DateTime minDate,
    required DateTime maxDate,
  }) {
    final entries = <ContributionEntry>[];
    final normalizedMin = DateTime(minDate.year, minDate.month, minDate.day);
    final normalizedMax = DateTime(maxDate.year, maxDate.month, maxDate.day);

    for (var date = normalizedMin;
        !date.isAfter(normalizedMax);
        date = date.add(const Duration(days: 1))) {
      final base = (date.day + date.month) % 6;
      final weekendBoost =
          (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) ? 2 : 0;

      final value = (base + weekendBoost).clamp(0, 10).toInt();

      entries.add(ContributionEntry(date, value));
    }

    return entries;
  }
}
