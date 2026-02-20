import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/domain/entities/user.dart';
import 'package:oikos/features/admin/presentation/bloc/carbon_stats_bloc.dart';
import 'package:oikos/features/admin/presentation/bloc/carbon_stats_state.dart';
import 'package:oikos/features/admin/presentation/widget/global_vue_page/category_breakdown.dart';
import 'package:oikos/features/admin/presentation/widget/global_vue_page/global_insights.dart';
import 'package:oikos/features/admin/presentation/widget/global_vue_page/carbon_evolution_chart.dart';

class GlobalVuePage extends StatelessWidget {
  final User user;
  const GlobalVuePage({super.key, required this.user});

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
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GlobalInsightsKPIs(
                      stats: data.globalInsightsStats,
                      isLoading: false,
                    ),
                    const SizedBox(height: 20),
                    CarbonEvolutionChart(
                      annualData: data.co2PerformanceYear,
                      monthlyData: data.co2PerformanceMonthly,
                    ),
                    const SizedBox(height: 20),
                    CategoryBreakdown(data: data.categories),
                  ],
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
