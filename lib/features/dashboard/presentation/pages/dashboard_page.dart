import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contribution_heatmap/contribution_heatmap.dart';
import 'package:oikos/features/dashboard/presentation/widgets/dashboard_back_button.dart';
import 'package:oikos/features/dashboard/presentation/widgets/dashboard_bilan_carbone_section.dart';
import 'package:oikos/features/dashboard/presentation/widgets/dashboard_streaks_section.dart';
import '../bloc/dashboard_bloc.dart';

class DashboardPage extends StatefulWidget {
  static MaterialPageRoute<dynamic> route() =>
      MaterialPageRoute(builder: (_) => const DashboardPage());

  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final List<ContributionEntry> _fakeHeatmapEntries;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                              entries: _fakeHeatmapEntries,
                              minDate: DateTime(2025, 8, 16),
                              maxDate: DateTime.now(),
                            ),
                            const SizedBox(height: 24),
                            if (bilan == null)
                              Text(
                                'Aucun bilan carbone disponible',
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              )
                            else
                              DashboardBilanCarboneSection(
                                scoreKg: bilan.scoreTotalKg,
                                scoresParCategorieKg: bilan.detail.toMap(),
                                equivalents: state.equivalents,
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
