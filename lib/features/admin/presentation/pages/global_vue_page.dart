import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/domain/entities/user.dart';
import 'package:oikos/core/theme/admin_theme.dart';
import 'package:oikos/features/admin/data/models/models.dart';
import 'package:oikos/features/admin/presentation/bloc/carbon_stats_bloc.dart';
import 'package:oikos/features/admin/presentation/bloc/carbon_stats_event.dart';
import 'package:oikos/features/admin/presentation/bloc/carbon_stats_state.dart';
import 'package:oikos/features/admin/presentation/widget/global_vue_page/category_breakdown.dart';
import 'package:oikos/features/admin/presentation/widget/global_vue_page/global_insights.dart';
import 'package:oikos/features/admin/presentation/widget/global_vue_page/carbon_evolution_chart.dart';

class GlobalVuePage extends StatefulWidget {
  final User user;
  final Company company;
  const GlobalVuePage({super.key, required this.user, required this.company});

  @override
  State<GlobalVuePage> createState() => _GlobalVuePageState();
}

class _GlobalVuePageState extends State<GlobalVuePage> {
  @override
  void initState() {
    super.initState();
    context.read<CarbonFootPrintBloc>().add(
      CarbonFootPrintfetched(companyId: widget.company.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CarbonFootPrintBloc, CarbonStatsState>(
      builder: (context, state) {
        if (state is CarbonFootPrintLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is CarbonFootPrintError) {
          return Center(
            child: Text(
              'Erreur',
              style: const TextStyle(color: AdminTheme.errorForeground),
            ),
          );
        }

        if (state is CarbonFootPrintLoaded) {
          final data = state.data;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AdminTheme.spacingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                CarbonEvolutionChart(
                  annualData: data.co2PerformanceYear,
                  monthlyData: data.co2PerformanceMonthly,
                ),
                const SizedBox(height: AdminTheme.spacingLg),
                CategoryBreakdown(data: data.categories),
                const SizedBox(height: AdminTheme.spacingLg),
                GlobalInsightsKPIs(stats: data.kpiStats, isLoading: false),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
