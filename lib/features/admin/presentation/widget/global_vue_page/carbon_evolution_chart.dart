import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:oikos/core/theme/admin_theme.dart';
import 'package:oikos/core/theme/app_size.dart';
import 'package:oikos/core/theme/breakpoints.dart';
import 'package:oikos/features/admin/data/models/models.dart';

enum TimeScale { monthly, annual }

/// Widget d'évolution de l'empreinte carbone - Version Responsive avec Scroll
class CarbonEvolutionChart extends StatefulWidget {
  final List<CarbonTimeSeries> monthlyData;
  final List<CarbonTimeSeries> annualData;

  const CarbonEvolutionChart({
    super.key,
    required this.monthlyData,
    required this.annualData,
  });

  @override
  State<CarbonEvolutionChart> createState() => _CarbonEvolutionChartState();
}

class _CarbonEvolutionChartState extends State<CarbonEvolutionChart> {
  TimeScale _timeScale = TimeScale.monthly;
  late ScrollController _scrollController;

  List<CarbonTimeSeries> get _currentData =>
      _timeScale == TimeScale.monthly ? widget.monthlyData : widget.annualData;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // Scroll vers la fin après le premier build
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Scroll vers la fin du graphique (données les plus récentes)
  void _scrollToEnd() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void didUpdateWidget(CarbonEvolutionChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Re-scroll si les données changent
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
  }

  void _onTimeScaleChanged(TimeScale scale) {
    setState(() => _timeScale = scale);
    // Scroll vers la fin après changement d'échelle
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenType = Breakpoints.getScreenType(screenWidth);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final dim = _ChartDimensions.fromScreenType(screenType, width);

        return Container(
          padding: EdgeInsets.all(dim.containerPadding),
          decoration: AdminColors.of(context).cardDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header avec titre et sélecteur
              _buildHeader(dim),
              SizedBox(height: dim.spacing),

              // Graphique scrollable
              _buildScrollableChart(dim, width),
              SizedBox(height: dim.spacing * 0.5),

              // Légende
              _buildLegend(dim),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(_ChartDimensions dim) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre (côté gauche)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Évolution du Bilan Carbone Moyen',
                style: AppSizes.headlineSize(
                  context,
                ).copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                'En kg CO2e',
                style: TextStyle(
                  fontSize: dim.labelFontSize,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),

        // Sélecteur d'échelle (côté droit)
        _buildScaleSelector(dim),
      ],
    );
  }

  Widget _buildScaleSelector(_ChartDimensions dim) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ScaleButton(
            label: dim.isMobile ? 'Mois' : 'Mensuel',
            isSelected: _timeScale == TimeScale.monthly,
            onPressed: () => _onTimeScaleChanged(TimeScale.monthly),
            fontSize: dim.fontSize,
          ),
          const SizedBox(width: 4),
          _ScaleButton(
            label: dim.isMobile ? 'An' : 'Annuel',
            isSelected: _timeScale == TimeScale.annual,
            onPressed: () => _onTimeScaleChanged(TimeScale.annual),
            fontSize: dim.fontSize,
          ),
        ],
      ),
    );
  }

  Widget _buildScrollableChart(_ChartDimensions dim, double containerWidth) {
    final data = _currentData;

    // Protection si pas de données
    if (data.isEmpty) {
      return SizedBox(
        height: dim.chartHeight,
        child: const Center(
          child: Text(
            'Aucune donnée disponible',
            style: TextStyle(color: Color(0xFF6B7280)),
          ),
        ),
      );
    }

    // Calculer la largeur du graphique selon le nombre de points
    final minWidthPerPoint = dim.isMobile ? 50.0 : 60.0;
    final calculatedWidth = data.length * minWidthPerPoint;
    final chartWidth = calculatedWidth > containerWidth
        ? calculatedWidth
        : containerWidth;

    final needsScroll = calculatedWidth > containerWidth;

    // Calculer maxY dynamiquement
    final dataMax = data
        .map((e) => e.averageCo2)
        .reduce((a, b) => a > b ? a : b);
    final maxY = _calculateMaxY(dataMax);
    final interval = _calculateInterval(maxY);

    return SizedBox(
      height: dim.chartHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Axe Y fixe (ne scroll pas)
          SizedBox(
            width: dim.reservedSizeLeft,
            child: _buildYAxis(dim, maxY, interval),
          ),

          // Graphique scrollable
          Expanded(
            child: needsScroll
                ? SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    reverse: false, // On scroll de gauche à droite
                    child: SizedBox(
                      width: chartWidth - dim.reservedSizeLeft,
                      child: _buildChartContent(dim, data, maxY, interval),
                    ),
                  )
                : _buildChartContent(dim, data, maxY, interval),
          ),
        ],
      ),
    );
  }

  /// Construit l'axe Y fixe
  Widget _buildYAxis(_ChartDimensions dim, double maxY, double interval) {
    final labels = <double>[];
    for (double value = 0; value <= maxY; value += interval) {
      labels.add(value);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Espace pour le haut du graphique
        const Expanded(flex: 1, child: SizedBox()),

        // Labels de l'axe Y
        ...labels.reversed.map((value) {
          return Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  value.toStringAsFixed(dim.isMobile ? 0 : 1),
                  style: TextStyle(
                    color: const Color(0xFF6B7280),
                    fontSize: dim.labelFontSize,
                  ),
                ),
              ),
            ),
          );
        }),

        // Espace pour les labels du bas
        SizedBox(height: dim.reservedSizeBottom),
      ],
    );
  }

  /// Construit le contenu du graphique (sans l'axe Y)
  Widget _buildChartContent(
    _ChartDimensions dim,
    List<CarbonTimeSeries> data,
    double maxY,
    double interval,
  ) {
    return LineChart(
      LineChartData(
        minY: 0,
        maxY: maxY,
        minX: 0,
        maxX: (data.length - 1).toDouble(),
        clipData: const FlClipData.all(),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: interval,
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
          leftTitles: const AxisTitles(
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
                final index = spot.x.toInt();
                if (index < 0 || index >= data.length) return null;
                final dataPoint = data[index];
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
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF10B981).withValues(alpha: 0.2),
                  const Color(0xFF10B981).withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ],
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  double _calculateMaxY(double dataMax) {
    final withMargin = dataMax * 1.2;
    if (withMargin <= 0) return 10;
    if (withMargin <= 5) return (withMargin / 0.5).ceil() * 0.5;
    if (withMargin <= 10) return (withMargin / 1).ceil() * 1.0;
    if (withMargin <= 20) return (withMargin / 2).ceil() * 2.0;
    if (withMargin <= 50) return (withMargin / 5).ceil() * 5.0;
    if (withMargin <= 100) return (withMargin / 10).ceil() * 10.0;
    if (withMargin <= 500) return (withMargin / 50).ceil() * 50.0;
    return (withMargin / 100).ceil() * 100.0;
  }

  double _calculateInterval(double maxY) {
    if (maxY <= 5) return 1;
    if (maxY <= 10) return 2;
    if (maxY <= 20) return 4;
    if (maxY <= 50) return 10;
    if (maxY <= 100) return 20;
    if (maxY <= 500) return 100;
    return 200;
  }

  Widget _buildBottomTitle(
    double value,
    List<CarbonTimeSeries> data,
    _ChartDimensions dim,
    bool isMonthly,
  ) {
    final index = value.toInt();
    if (index < 0 || index >= data.length) {
      return const SizedBox.shrink();
    }

    // Afficher un label sur N points selon l'espace
    final showEvery = dim.isMobile ? 2 : 1;
    if (index % showEvery != 0 && index != data.length - 1) {
      return const SizedBox.shrink();
    }

    String label = isMonthly
        ? DateFormat.MMM('fr_FR').format(data[index].period)
        : DateFormat.y('fr_FR').format(data[index].period);

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        label,
        style: TextStyle(
          color: const Color(0xFF6B7280),
          fontSize: dim.labelFontSize,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildLegend(_ChartDimensions dim) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 3,
          decoration: BoxDecoration(
            color: const Color(0xFF10B981),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Bilan carbone',
          style: TextStyle(
            color: const Color(0xFF6B7280),
            fontSize: dim.fontSize,
          ),
        ),
        const Spacer(),
        // Indicateur de scroll si nécessaire
        if (_currentData.length > 6)
          Row(
            children: [
              Icon(
                Icons.swipe,
                size: dim.fontSize + 4,
                color: const Color(0xFF9CA3AF),
              ),
              const SizedBox(width: 4),
              Text(
                'Glissez pour voir plus',
                style: TextStyle(
                  color: const Color(0xFF9CA3AF),
                  fontSize: dim.labelFontSize,
                ),
              ),
            ],
          ),
      ],
    );
  }
}

/// Dimensions responsives du graphique
class _ChartDimensions {
  final double chartHeight;
  final double spacing;
  final double fontSize;
  final double titleFontSize;
  final double labelFontSize;
  final double dotRadius;
  final double lineWidth;
  final double reservedSizeBottom;
  final double reservedSizeLeft;
  final double containerPadding;
  final bool isMobile;
  final bool isTablet;

  const _ChartDimensions({
    required this.chartHeight,
    required this.spacing,
    required this.fontSize,
    required this.titleFontSize,
    required this.labelFontSize,
    required this.dotRadius,
    required this.lineWidth,
    required this.reservedSizeBottom,
    required this.reservedSizeLeft,
    required this.containerPadding,
    required this.isMobile,
    required this.isTablet,
  });

  factory _ChartDimensions.fromScreenType(ScreenType type, double width) {
    switch (type) {
      case ScreenType.mobile:
        return const _ChartDimensions(
          chartHeight: 220,
          spacing: 16,
          fontSize: 12,
          titleFontSize: 16,
          labelFontSize: 10,
          dotRadius: 4,
          lineWidth: 2.5,
          reservedSizeBottom: 32,
          reservedSizeLeft: 40,
          containerPadding: 16,
          isMobile: true,
          isTablet: false,
        );
      case ScreenType.tablet:
        return const _ChartDimensions(
          chartHeight: 280,
          spacing: 20,
          fontSize: 13,
          titleFontSize: 18,
          labelFontSize: 11,
          dotRadius: 4.5,
          lineWidth: 3,
          reservedSizeBottom: 36,
          reservedSizeLeft: 48,
          containerPadding: 20,
          isMobile: false,
          isTablet: true,
        );
      case ScreenType.desktop:
        return const _ChartDimensions(
          chartHeight: 320,
          spacing: 24,
          fontSize: 14,
          titleFontSize: 20,
          labelFontSize: 12,
          dotRadius: 5,
          lineWidth: 3,
          reservedSizeBottom: 40,
          reservedSizeLeft: 56,
          containerPadding: 24,
          isMobile: false,
          isTablet: false,
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

  const _ScaleButton({
    required this.label,
    required this.isSelected,
    required this.onPressed,
    this.fontSize = 13,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? const Color(0xFF10B981) : Colors.transparent,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: fontSize,
            vertical: fontSize * 0.5,
          ),
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

// =============================================================================
// EXEMPLE D'UTILISATION
// =============================================================================

class ExampleChartPage extends StatelessWidget {
  const ExampleChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Données de test (12 mois)
    final monthlyData = List.generate(12, (index) {
      return CarbonTimeSeries(
        period: DateTime(2024, index + 1),
        averageCo2: 5 + (index * 0.8) + (index % 3) * 2,
      );
    });

    // Données annuelles (5 ans)
    final annualData = List.generate(5, (index) {
      return CarbonTimeSeries(
        period: DateTime(2020 + index),
        averageCo2: 50 + (index * 15) + (index % 2) * 10,
      );
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: const Text('Carbon Evolution'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: CarbonEvolutionChart(
          monthlyData: monthlyData,
          annualData: annualData,
        ),
      ),
    );
  }
}
