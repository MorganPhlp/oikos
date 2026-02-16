import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contribution_heatmap/contribution_heatmap.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
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
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Bonjour ${state.pseudo}',
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      Text(
                        'Streaks',
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),

                      ContributionHeatmap(
                        heatmapColor: HeatmapColor.green,
                        showMonthLabels: true,
                        weekdayLabel: WeekdayLabel.full,
                        splittedMonthView: true,
                        showCellDate: true,
                        startWeekday: DateTime.monday,
                        cellRadius: 8.0,
                        cellSize: 20.0,
                        minDate: DateTime(2025, 8, 16),
                        maxDate: DateTime.now(),
                        entries: _fakeHeatmapEntries,
                        onCellTap: (date, value) {
                          // ignore: avoid_print
                          print('Tapped: $date with $value contributions');
                        },
                      ),

                      const SizedBox(height: 24),
                      Text(
                        'Bilan Carbone',
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
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
      // Fake data déterministe: quelques pics + du bruit léger.
      final base = (date.day + date.month) % 6;
      final weekendBoost = (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) ? 2 : 0;
      final value = (base + weekendBoost).clamp(0, 10);

      entries.add(
        ContributionEntry(date, value)
      );
    }

    return entries;
  }
}
