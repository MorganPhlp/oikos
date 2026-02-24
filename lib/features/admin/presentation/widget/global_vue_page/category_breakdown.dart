import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:oikos/core/theme/admin_theme.dart';
import 'package:oikos/core/theme/app_size.dart';
import 'package:oikos/core/theme/breakpoints.dart';
import 'package:oikos/features/admin/data/models/models.dart';

/// Widget de répartition par catégorie - Version Responsive
class CategoryBreakdown extends StatefulWidget {
  final List<CategoryData>? data;

  const CategoryBreakdown({super.key, this.data});

  @override
  State<CategoryBreakdown> createState() => _CategoryBreakdownState();
}

class _CategoryBreakdownState extends State<CategoryBreakdown> {
  int? _touchedIndex;

  // Données par défaut
  static const List<CategoryData> _defaultData = [
    CategoryData(
      name: 'Transport',
      percentage: 30,
      co2: 0.48,
      color: Color(0xFF3B82F6),
    ),
    CategoryData(
      name: 'Alimentation',
      percentage: 40,
      co2: 0.64,
      color: Color(0xFF10B981),
    ),
    CategoryData(
      name: 'Logement',
      percentage: 20,
      co2: 0.32,
      color: Color(0xFFF59E0B),
    ),
    CategoryData(
      name: 'Numérique',
      percentage: 10,
      co2: 0.16,
      color: Color(0xFF8B5CF6),
    ),
  ];

  List<CategoryData> get categoryData => widget.data ?? _defaultData;
  double get totalCO2 => categoryData.fold(0, (sum, cat) => sum + cat.co2);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final dim = _ChartDimensions.fromWidth(width);

        return Container(
          
          decoration: AdminColors.of(context).cardDecoration,
          padding: EdgeInsets.all(dim.spacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Consommation CO₂ par catégorie',
                  style: AppSizes.headlineSize(context).copyWith(fontWeight: FontWeight.w600)
              ),
              _buildContent(dim)
              
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(_ChartDimensions dim) {
    // Mobile : layout vertical
    if (dim.isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [SizedBox(height: dim.chartHeight, child: _buildChart(dim))],
      );
    }

    // Tablet : layout vertical mais plus grand
    if (dim.isTablet) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: dim.chartHeight, child: _buildChart(dim)),
          SizedBox(height: dim.spacing),
          _buildLegend(dim),
        ],
      );
    }

    // Desktop : layout horizontal
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: SizedBox(height: dim.chartHeight, child: _buildChart(dim)),
        ),
        SizedBox(width: dim.spacing * 1.5),
        Expanded(flex: 2, child: _buildLegend(dim)),
      ],
    );
  }

  Widget _buildChart(_ChartDimensions dim) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _buildPieChart(dim),
    );
  }

  Widget _buildPieChart(_ChartDimensions dim) {
    // Protection contre les données vides
    if (categoryData.isEmpty) {
      return const Center(child: Text('Aucune donnée disponible'));
    }

    return PieChart(
      key: const ValueKey('pie'),
      PieChartData(
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  pieTouchResponse == null ||
                  pieTouchResponse.touchedSection == null) {
                _touchedIndex = -1;
                return;
              }
              _touchedIndex =
                  pieTouchResponse.touchedSection!.touchedSectionIndex;
            });
          },
        ),
        borderData: FlBorderData(show: false),
        sectionsSpace: dim.isMobile ? 1 : 2,
        centerSpaceRadius: dim.pieHoleRadius,
        sections: _buildPieSections(dim),
      ),
    );
  }

  List<PieChartSectionData> _buildPieSections(_ChartDimensions dim) {
    return List.generate(categoryData.length, (index) {
      final isTouched = index == _touchedIndex;
      final data = categoryData[index];

      final fontSize = isTouched ? dim.pieFontSize + 2 : dim.pieFontSize;
      final radius = isTouched ? dim.pieRadius + 10 : dim.pieRadius;

      return PieChartSectionData(
        color: data.color,
        value: data.percentage,
        title: '${data.percentage.toInt()}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: const [Shadow(color: Colors.black26, blurRadius: 2)],
        ),
        badgeWidget: isTouched ? _buildBadge(data, dim) : null,
        badgePositionPercentageOffset: dim.isMobile ? 1.2 : 1.3,
      );
    });
  }

  Widget _buildBadge(CategoryData data, _ChartDimensions dim) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dim.isMobile ? 6 : 8,
        vertical: dim.isMobile ? 3 : 4,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        data.name,
        style: TextStyle(
          fontSize: dim.isMobile ? 10 : 12,
          fontWeight: FontWeight.w600,
          color: data.color,
        ),
      ),
    );
  }

  Widget _buildLegend(_ChartDimensions dim) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Répartition par catégorie',
          style: TextStyle(
            fontSize: dim.titleFontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: dim.spacing * 0.75),

        // Liste des catégories
        ...categoryData.map(
          (data) => _LegendItem(data: data, totalCO2: totalCO2, dim: dim),
        ),

        SizedBox(height: dim.spacing * 0.5),
        const Divider(color: Color(0xFFE5E7EB), height: 1),
        SizedBox(height: dim.spacing * 0.5),

        // Total
        _buildTotal(dim),
      ],
    );
  }

  Widget _buildTotal(_ChartDimensions dim) {
    return Container(
      padding: EdgeInsets.all(dim.isMobile ? 12 : 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total',
            style: TextStyle(
              fontSize: dim.fontSize,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF111827),
            ),
          ),
          Text(
            '${totalCO2.toStringAsFixed(2)} Kg en CO2e',
            style: TextStyle(
              fontSize: dim.fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }
}

/// Dimensions responsives
class _ChartDimensions {
  final double chartHeight;
  final double spacing;
  final double fontSize;
  final double labelFontSize;
  final double titleFontSize;
  final double pieRadius;
  final double pieHoleRadius;
  final double pieFontSize;
  final double barWidth;
  final double barRadius;
  final double reservedSizeBottom;
  final double reservedSizeLeft;
  final double legendItemSpacing;
  final double progressBarHeight;
  final ScreenType screenType;

  const _ChartDimensions({
    required this.chartHeight,
    required this.spacing,
    required this.fontSize,
    required this.labelFontSize,
    required this.titleFontSize,
    required this.pieRadius,
    required this.pieHoleRadius,
    required this.pieFontSize,
    required this.barWidth,
    required this.barRadius,
    required this.reservedSizeBottom,
    required this.reservedSizeLeft,
    required this.legendItemSpacing,
    required this.progressBarHeight,
    required this.screenType,
  });

  bool get isMobile => screenType == ScreenType.mobile;
  bool get isTablet => screenType == ScreenType.tablet;
  bool get isDesktop => screenType == ScreenType.desktop;
  bool get showAxisName => screenType != ScreenType.mobile;

  factory _ChartDimensions.fromWidth(double width) {
    final screenType = Breakpoints.getScreenType(width);

    switch (screenType) {
      case ScreenType.mobile:
        return _ChartDimensions(
          chartHeight: 220,
          spacing: 16,
          fontSize: 12,
          labelFontSize: 10,
          titleFontSize: 14,
          pieRadius: 70,
          pieHoleRadius: 30,
          pieFontSize: 10,
          barWidth: 24,
          barRadius: 4,
          reservedSizeBottom: 32,
          reservedSizeLeft: 32,
          legendItemSpacing: 10,
          progressBarHeight: 5,
          screenType: screenType,
        );

      case ScreenType.tablet:
        return _ChartDimensions(
          chartHeight: 280,
          spacing: 20,
          fontSize: 13,
          labelFontSize: 11,
          titleFontSize: 15,
          pieRadius: 90,
          pieHoleRadius: 35,
          pieFontSize: 11,
          barWidth: 32,
          barRadius: 5,
          reservedSizeBottom: 36,
          reservedSizeLeft: 36,
          legendItemSpacing: 12,
          progressBarHeight: 6,
          screenType: screenType,
        );

      case ScreenType.desktop:
        return _ChartDimensions(
          chartHeight: 320,
          spacing: 24,
          fontSize: 14,
          labelFontSize: 12,
          titleFontSize: 16,
          pieRadius: 100,
          pieHoleRadius: 40,
          pieFontSize: 12,
          barWidth: 40,
          barRadius: 6,
          reservedSizeBottom: 40,
          reservedSizeLeft: 40,
          legendItemSpacing: 12,
          progressBarHeight: 6,
          screenType: screenType,
        );
    }
  }
}

/// Item de légende responsive
class _LegendItem extends StatelessWidget {
  final CategoryData data;
  final double totalCO2;
  final _ChartDimensions dim;

  const _LegendItem({
    required this.data,
    required this.totalCO2,
    required this.dim,
  });

  @override
  Widget build(BuildContext context) {
    // Protection contre division par zéro
    final progressValue = totalCO2 > 0 ? data.co2 / totalCO2 : 0.0;

    return Padding(
      padding: EdgeInsets.only(bottom: dim.legendItemSpacing),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: dim.isMobile ? 12 : 16,
            height: dim.isMobile ? 12 : 16,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: data.color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(width: dim.isMobile ? 8 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        data.name,
                        style: TextStyle(
                          fontSize: dim.fontSize,
                          fontWeight: FontWeight.w500,
                          
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${data.co2.toStringAsFixed(2)} Kg CO2e',
                      style: TextStyle(
                        fontSize: dim.fontSize,
                        fontWeight: FontWeight.w600,  
                      ),
                    ),
                  ],
                ),
                SizedBox(height: dim.isMobile ? 3 : 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progressValue.clamp(0.0, 1.0),
                    backgroundColor: const Color(0xFFE5E7EB),
                    valueColor: AlwaysStoppedAnimation<Color>(data.color),
                    minHeight: dim.progressBarHeight,
                  ),
                ),
                SizedBox(height: dim.isMobile ? 2 : 3),
                Text(
                  '${data.percentage.toInt()}% de votre empreinte',
                  style: TextStyle(
                    fontSize: dim.labelFontSize,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
