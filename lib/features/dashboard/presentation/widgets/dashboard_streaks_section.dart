import 'package:contribution_heatmap/contribution_heatmap.dart';
import 'package:flutter/material.dart';
import 'package:oikos/features/dashboard/presentation/widgets/dashboard_info_button.dart';

class DashboardStreaksSection extends StatefulWidget {
  final List<ContributionEntry> entries;
  final DateTime minDate;
  final DateTime maxDate;
  final int visibleWeeks;

  const DashboardStreaksSection({
    super.key,
    required this.entries,
    required this.minDate,
    required this.maxDate,
    this.visibleWeeks = 13,
  });

  @override
  State<DashboardStreaksSection> createState() => _DashboardStreaksSectionState();
}

class _DashboardStreaksSectionState extends State<DashboardStreaksSection> {
  final ScrollController _heatmapScrollController = ScrollController();
  bool _scrolledToEndOnce = false;

  @override
  void dispose() {
    _heatmapScrollController.dispose();
    super.dispose();
  }

  void _scrollHeatmapToLatest() {
    if (_scrolledToEndOnce) return;
    if (!_heatmapScrollController.hasClients) return;

    _scrolledToEndOnce = true;
    _heatmapScrollController.jumpTo(
      _heatmapScrollController.position.maxScrollExtent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Streaks',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(width: 8),
            const DashboardInfoButton(
              title: 'Streaks',
              message:
                  "Heatmap des actions quotidiennes sur les 5 derniers mois. Plus une case est foncée, plus tu as été actif ce jour-là.",
            ),
          ],
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final safeWidth = constraints.maxWidth;
            const cellSpacing = 3.0;
            const estimatedLabelWidth = 48.0;
            final usable = (safeWidth - estimatedLabelWidth).clamp(200.0, safeWidth);
            final cellSize = ((usable - (widget.visibleWeeks - 1) * cellSpacing) / widget.visibleWeeks)
                .clamp(10.0, 22.0);

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              _scrollHeatmapToLatest();
            });

            return SizedBox(
              width: constraints.maxWidth,
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
                  padding: EdgeInsets.zero,
                  cellSize: cellSize,
                  cellSpacing: cellSpacing,
                  cellRadius: 6.0,
                  minDate: widget.minDate,
                  maxDate: widget.maxDate,
                  entries: widget.entries,
                  onCellTap: (date, value) {
                    // ignore: avoid_print
                    print('Tapped: $date with $value contributions');
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
