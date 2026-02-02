import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/theme/breakpoints.dart';
import 'package:oikos/features/admin/domain/entities/co2_performance_data.dart';
import 'package:oikos/features/admin/domain/use_cases/get_co2_performance.dart';
import 'package:oikos/features/admin/presentation/bloc/carbon_stats_bloc.dart';
import 'package:oikos/features/admin/presentation/bloc/carbon_stats_state.dart';
import 'package:oikos/features/admin/presentation/widget/global_vue_page/category_breakdown.dart';
import 'package:oikos/features/admin/presentation/widget/global_vue_page/impact_stats.dart';
import 'package:oikos/features/admin/presentation/widget/global_vue_page/carbon_evolution_chart.dart';
import 'package:oikos/injection_container.dart';

class GlobalVuePage extends StatefulWidget {
  const GlobalVuePage({super.key});

  @override
  State<GlobalVuePage> createState() => _GlobalVuePageState();
}

class _GlobalVuePageState extends State<GlobalVuePage> {
  final getCo2Performance = sl<GetCo2Performance>();

  @override
  void initState() {
    super.initState();
  }

  Widget _buildOverviewContent(Co2PerformanceData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        ImpactStats(data: data.impactStats),
        const SizedBox(height: 20),

        // Card : Évolution de l'empreinte carbone
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.trending_down, color: Colors.green),
                  const SizedBox(width: 12),
                  Text(
                    "Évolution de l'empreinte carbone",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CarbonEvolutionChart(
                annualData: data.co2PerformanceYear,
                monthlyData: data.co2PerformanceMonthly,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Card : Répartition par catégories
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.pie_chart, color: Colors.green),
                  const SizedBox(width: 12),
                  Text(
                    "Répartition par catégories",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Placeholder pour le contenu
              Container(
                padding: const EdgeInsets.all(20),
                child: CategoryBreakdown(data: data.categories),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Co2PerformanceBloc, CarbonStatsState>(
      builder: (context, state) {
        if (state is Co2PerformanceLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is Co2PerformanceError) {
          return Center(
            child: Text("Erreur", style: TextStyle(color: Colors.red)),
          );
        }

        if (state is Co2PerformanceLoaded) {
          final data = state.data;
          return SafeArea(
            child: LayoutBuilder(
              builder: (context, constraint) {
                final width = constraint.maxWidth;

                double h = 100;
                double v = 40;

                if (width < Breakpoints.mobile) {
                  h = 10;
                  v = 10;
                }
                return ListView(
                  padding: EdgeInsets.symmetric(horizontal: h, vertical: v),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [_buildOverviewContent(data)],
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
