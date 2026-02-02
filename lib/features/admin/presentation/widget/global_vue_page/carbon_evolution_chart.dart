import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:oikos/core/theme/breakpoints.dart';
import 'package:oikos/features/admin/domain/entities/carbon_data_point.dart';
import 'package:intl/intl.dart';

enum TimeScale { monthly, annual }

/// Widget d'évolution de l'empreinte carbone - Version Responsive
class CarbonEvolutionChart extends StatefulWidget {
  final List<CarbonDataPoint>? monthlyData;
  final List<CarbonDataPoint>? annualData;

  const CarbonEvolutionChart({super.key, this.monthlyData, this.annualData});

  @override
  State<CarbonEvolutionChart> createState() => _CarbonEvolutionChartState();
}

class _CarbonEvolutionChartState extends State<CarbonEvolutionChart> {
  TimeScale _timeScale = TimeScale.monthly;

  static final List<CarbonDataPoint> _defaultMonthlyData = [
    CarbonDataPoint(period: DateTime(2025, 1, 1), averageCo2: 2.85),
    CarbonDataPoint(period: DateTime(2025, 2, 1), averageCo2: 2.65),
    CarbonDataPoint(period: DateTime(2025, 3, 1), averageCo2: 2.55),
    CarbonDataPoint(period: DateTime(2025, 4, 1), averageCo2: 2.45),
    CarbonDataPoint(period: DateTime(2025, 5, 1), averageCo2: 2.35),
    CarbonDataPoint(period: DateTime(2025, 6, 1), averageCo2: 2.25),
    CarbonDataPoint(period: DateTime(2025, 7, 1), averageCo2: 2.15),
    CarbonDataPoint(period: DateTime(2025, 8, 1), averageCo2: 2.05),
    CarbonDataPoint(period: DateTime(2025, 9, 1), averageCo2: 1.95),
    CarbonDataPoint(period: DateTime(2025, 10, 1), averageCo2: 1.85),
    CarbonDataPoint(period: DateTime(2025, 11, 1), averageCo2: 1.75),
    CarbonDataPoint(period: DateTime(2025, 12, 1), averageCo2: 1.65),
  ];

  static final List<CarbonDataPoint> _defaultAnnualData = [
    CarbonDataPoint(period: DateTime(2020, 1, 1), averageCo2: 10.5),
    CarbonDataPoint(period: DateTime(2021, 1, 1), averageCo2: 9.2),
    CarbonDataPoint(period: DateTime(2022, 1, 1), averageCo2: 7.8),
    CarbonDataPoint(period: DateTime(2023, 1, 1), averageCo2: 5.4),
    CarbonDataPoint(period: DateTime(2024, 1, 1), averageCo2: 3.2),
    CarbonDataPoint(period: DateTime(2025, 1, 1), averageCo2: 2.4),
  ];

  List<CarbonDataPoint> get _monthlyData =>
      widget.monthlyData ?? _defaultMonthlyData;
  List<CarbonDataPoint> get _annualData =>
      widget.annualData ?? _defaultAnnualData;

  List<CarbonDataPoint> get _currentData =>
      _timeScale == TimeScale.monthly ? _monthlyData : _annualData;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final screenType = Breakpoints.getScreenType(width);
        final dim = _ChartDimensions.fromScreenType(screenType, width);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Sélecteur d'échelle
            _buildScaleSelector(dim),
            SizedBox(height: dim.spacing),

            // Graphique
            SizedBox(height: dim.chartHeight, child: _buildChart(dim)),
            SizedBox(height: dim.spacing * 0.5),

            // Légende
            _buildLegend(dim),
            SizedBox(height: dim.spacing),
          ],
        );
      },
    );
  }

  Widget _buildScaleSelector(_ChartDimensions dim) {
    final buttons = [
      _ScaleButton(
        label: dim.isMobile ? 'Mensuel' : 'Vue mensuelle',
        isSelected: _timeScale == TimeScale.monthly,
        onPressed: () => setState(() => _timeScale = TimeScale.monthly),
        fontSize: dim.fontSize,
        expanded: dim.isMobile,
      ),
      _ScaleButton(
        label: dim.isMobile ? 'Annuel' : 'Vue annuelle',
        isSelected: _timeScale == TimeScale.annual,
        onPressed: () => setState(() => _timeScale = TimeScale.annual),
        fontSize: dim.fontSize,
        expanded: dim.isMobile,
      ),
    ];

    if (dim.isMobile) {
      return Row(
        children: [
          Expanded(child: buttons[0]),
          SizedBox(width: dim.spacing * 0.5),
          Expanded(child: buttons[1]),
        ],
      );
    }

    return Wrap(spacing: 12, runSpacing: 8, children: buttons);
  }

  Widget _buildChart(_ChartDimensions dim) {
    final data = _currentData;

    // Protection si pas de données
    if (data.isEmpty) {
      return const Center(child: Text('Aucune donnée disponible'));
    }

    // ✅ Calculer maxY dynamiquement à partir des données
    final dataMax = data
        .map((e) => e.averageCo2)
        .reduce((a, b) => a > b ? a : b);
    final maxY = _calculateMaxY(dataMax);
    final horizontalInterval = _calculateInterval(maxY);

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: maxY,
        clipData: const FlClipData.all(),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: !dim.isMobile,
          horizontalInterval: horizontalInterval,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) => FlLine(
            color: const Color(0xFFE5E7EB),
            strokeWidth: 1,
            dashArray: [5, 5],
          ),
          getDrawingVerticalLine: (value) => FlLine(
            color: const Color(0xFFE5E7EB),
            strokeWidth: 1,
            dashArray: [5, 5],
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: dim.reservedSizeBottom,
              interval: 1,
              getTitlesWidget: (value, meta) => _buildBottomTitle(
                value,
                data,
                dim,
                _timeScale == TimeScale.monthly,
              ),
            ),
          ),
          leftTitles: AxisTitles(
            axisNameWidget: dim.showAxisName
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      'Empreinte carbone (Kg en CO2e)',
                      style: TextStyle(
                        color: const Color(0xFF6B7280),
                        fontSize: dim.labelFontSize,
                      ),
                    ),
                  )
                : null,
            axisNameSize: dim.showAxisName ? 24 : 0,
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: dim.reservedSizeLeft,
              interval: horizontalInterval,
              getTitlesWidget: (value, meta) => _buildLeftTitle(value, dim),
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(color: Color(0xFFE5E7EB)),
            left: BorderSide(color: Color(0xFFE5E7EB)),
          ),
        ),
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => Colors.white,
            tooltipBorder: const BorderSide(color: Color(0xFFE5E7EB)),
            tooltipPadding: EdgeInsets.all(dim.isMobile ? 8 : 12),
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final dataPoint = data[spot.x.toInt()];
                return LineTooltipItem(
                  '${DateFormat.yMMMd('fr_FR').format(dataPoint.period)}\n',
                  TextStyle(
                    color: const Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                    fontSize: dim.fontSize,
                  ),
                  children: [
                    TextSpan(
                      text: '${spot.y.toStringAsFixed(2)} kg CO2e',
                      style: TextStyle(
                        color: const Color(0xFF10B981),
                        fontWeight: FontWeight.bold,
                        fontSize: dim.fontSize,
                      ),
                    ),
                  ],
                );
              }).toList();
            },
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              data.length,
              (index) => FlSpot(index.toDouble(), data[index].averageCo2),
            ),
            isCurved: true,
            curveSmoothness: 0.3,
            color: const Color(0xFF10B981),
            barWidth: dim.lineWidth,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: dim.dotRadius,
                  color: const Color(0xFF10B981),
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: const Color(0xFF10B981).withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  /// ✅ Calcule maxY avec une marge et un arrondi propre
  double _calculateMaxY(double dataMax) {
    // Ajouter 20% de marge
    final withMargin = dataMax * 1.2;

    // Arrondir vers le haut à un nombre "propre"
    if (withMargin <= 5) {
      return (withMargin / 0.5).ceil() * 0.5; // Arrondir à 0.5
    } else if (withMargin <= 10) {
      return (withMargin / 1).ceil() * 1.0; // Arrondir à 1
    } else if (withMargin <= 20) {
      return (withMargin / 2).ceil() * 2.0; // Arrondir à 2
    } else if (withMargin <= 50) {
      return (withMargin / 5).ceil() * 5.0; // Arrondir à 5
    } else if (withMargin <= 100) {
      return (withMargin / 10).ceil() * 10.0; // Arrondir à 10
    } else if (withMargin <= 500) {
      return (withMargin / 50).ceil() * 50.0; // Arrondir à 50
    } else {
      return (withMargin / 100).ceil() * 100.0; // Arrondir à 100
    }
  }

  /// ✅ Calcule l'intervalle des lignes horizontales
  double _calculateInterval(double maxY) {
    if (maxY <= 5) return 0.5;
    if (maxY <= 10) return 1;
    if (maxY <= 20) return 2;
    if (maxY <= 50) return 5;
    if (maxY <= 100) return 10;
    if (maxY <= 500) return 50;
    return 100;
  }

  Widget _buildBottomTitle(
    double value,
    List<CarbonDataPoint> data,
    _ChartDimensions dim,
    bool isMonthly,
  ) {
    final index = value.toInt();
    if (index < 0 || index >= data.length) {
      return const SizedBox.shrink();
    }
    if (index % dim.labelInterval != 0) {
      return const SizedBox.shrink();
    }

    String label = isMonthly
        ? DateFormat.MMM('fr_FR').format(data[index].period)
        : DateFormat.y('fr_FR').format(data[index].period);

    // Raccourcir sur mobile
    if (dim.isMobile && label.length > 3) {
      label = label.substring(0, 3);
    }

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Text(
        label,
        style: TextStyle(
          color: const Color(0xFF6B7280),
          fontSize: dim.labelFontSize,
        ),
      ),
    );
  }

  Widget _buildLeftTitle(double value, _ChartDimensions dim) {
    if (dim.isMobile && value % 1 != 0) {
      return const SizedBox.shrink();
    }
    return Text(
      value.toStringAsFixed(dim.isMobile ? 0 : 1),
      style: TextStyle(
        color: const Color(0xFF6B7280),
        fontSize: dim.labelFontSize,
      ),
    );
  }

  Widget _buildLegend(_ChartDimensions dim) {
    return _LegendItem(
      color: const Color(0xFF10B981),
      label: dim.isMobile ? 'Empreinte' : 'Empreinte carbone',
      fontSize: dim.fontSize,
    );
  }
}

/// Dimensions responsives du graphique
class _ChartDimensions {
  final double chartHeight;
  final double spacing;
  final double fontSize;
  final double labelFontSize;
  final double dotRadius;
  final double lineWidth;
  final double reservedSizeBottom;
  final double reservedSizeLeft;
  final double infoPadding;
  final int labelInterval;
  final bool isMobile;
  final bool isTablet;
  final bool showAxisName;
  final bool showReferenceLabel;

  const _ChartDimensions({
    required this.chartHeight,
    required this.spacing,
    required this.fontSize,
    required this.labelFontSize,
    required this.dotRadius,
    required this.lineWidth,
    required this.reservedSizeBottom,
    required this.reservedSizeLeft,
    required this.infoPadding,
    required this.labelInterval,
    required this.isMobile,
    required this.isTablet,
    required this.showAxisName,
    required this.showReferenceLabel,
  });

  factory _ChartDimensions.fromScreenType(ScreenType type, double width) {
    switch (type) {
      case ScreenType.mobile:
        return const _ChartDimensions(
          chartHeight: 200,
          spacing: 12,
          fontSize: 11,
          labelFontSize: 9,
          dotRadius: 3,
          lineWidth: 2,
          reservedSizeBottom: 22,
          reservedSizeLeft: 28,
          infoPadding: 12,
          labelInterval: 3,
          isMobile: true,
          isTablet: false,
          showAxisName: false,
          showReferenceLabel: false,
        );
      case ScreenType.tablet:
        return const _ChartDimensions(
          chartHeight: 260,
          spacing: 16,
          fontSize: 12,
          labelFontSize: 10,
          dotRadius: 4,
          lineWidth: 2.5,
          reservedSizeBottom: 26,
          reservedSizeLeft: 35,
          infoPadding: 14,
          labelInterval: 2,
          isMobile: false,
          isTablet: true,
          showAxisName: true,
          showReferenceLabel: true,
        );
      case ScreenType.desktop:
        return const _ChartDimensions(
          chartHeight: 320,
          spacing: 20,
          fontSize: 13,
          labelFontSize: 11,
          dotRadius: 4.5,
          lineWidth: 3,
          reservedSizeBottom: 28,
          reservedSizeLeft: 38,
          infoPadding: 16,
          labelInterval: 2,
          isMobile: false,
          isTablet: false,
          showAxisName: true,
          showReferenceLabel: true,
        );
    }
  }
}

/// Bouton de sélection d'échelle
class _ScaleButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;
  final double fontSize;
  final bool expanded;

  const _ScaleButton({
    required this.label,
    required this.isSelected,
    required this.onPressed,
    this.fontSize = 14,
    this.expanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? const Color(0xFF16A34A) : const Color(0xFFF3F4F6),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: fontSize,
            vertical: fontSize * 0.6,
          ),
          alignment: expanded ? Alignment.center : null,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF374151),
              fontWeight: FontWeight.w500,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    );
  }
}

/// Item de légende
class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final double fontSize;

  const _LegendItem({
    required this.color,
    required this.label,
    this.fontSize = 13,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: fontSize * 1.5,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: fontSize * 0.4),
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              color: const Color(0xFF6B7280),
              fontSize: fontSize,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
