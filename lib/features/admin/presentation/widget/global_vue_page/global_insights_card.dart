import 'package:flutter/material.dart';
import 'package:oikos/core/theme/app_theme.dart';
import 'package:oikos/core/theme/app_size.dart';
import 'package:oikos/core/theme/breakpoints.dart';

/// Couleurs disponibles pour les KPI Cards
enum KPIColor { green, blue, purple, orange }

/// Statut d'une sous-métrique
enum KPISubMetricStatus { success, warning, error }

/// Données de tendance (trend)
class KPITrend {
  final double value;
  final String label;

  const KPITrend({required this.value, required this.label});
}

/// Sous-métrique affichée dans une KPI Card
class KPISubMetric {
  final String label;
  final String value;
  final String? unit;
  final String? target;
  final KPISubMetricStatus? status;

  const KPISubMetric({
    required this.label,
    required this.value,
    this.unit,
    this.target,
    this.status,
  });
}

/// Configuration des couleurs pour chaque KPIColor
class _KPIColorConfig {
  final Color iconColor;
  final Color iconBgColor;
  final Gradient gradient;

  const _KPIColorConfig({
    required this.iconColor,
    required this.iconBgColor,
    required this.gradient,
  });

  static _KPIColorConfig fromKPIColor(KPIColor color) {
    switch (color) {
      case KPIColor.green:
        return _KPIColorConfig(
          iconColor: const Color(0xFF16A34A), // green-600
          iconBgColor: const Color(0xFFF0FDF4), // green-50
          gradient: const LinearGradient(
            colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
          ),
        );
      case KPIColor.blue:
        return _KPIColorConfig(
          iconColor: const Color(0xFF2563EB), // blue-600
          iconBgColor: const Color(0xFFEFF6FF), // blue-50
          gradient: const LinearGradient(
            colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
          ),
        );
      case KPIColor.purple:
        return _KPIColorConfig(
          iconColor: const Color(0xFF9333EA), // purple-600
          iconBgColor: const Color(0xFFFAF5FF), // purple-50
          gradient: const LinearGradient(
            colors: [Color(0xFFA855F7), Color(0xFF9333EA)],
          ),
        );
      case KPIColor.orange:
        return _KPIColorConfig(
          iconColor: const Color(0xFFEA580C), // orange-600
          iconBgColor: const Color(0xFFFFF7ED), // orange-50
          gradient: const LinearGradient(
            colors: [Color(0xFFF97316), Color(0xFFEA580C)],
          ),
        );
    }
  }
}

/// Widget KPI Card
///
/// Affiche une carte de statistique avec :
/// - Une icône colorée
/// - Un titre
/// - Une valeur avec unité optionnelle
/// - Une tendance optionnelle (badge vert/rouge selon signe)
/// - Des sous-métriques optionnelles avec statut coloré et objectif
class KPICard extends StatefulWidget {
  final String title;
  final String? value;
  final String? unit;
  final IconData icon;
  final KPIColor color;
  final KPITrend? trend;
  final bool isLoading;
  final List<KPISubMetric>? subMetrics;

  const KPICard({
    super.key,
    required this.title,
    this.value,
    this.unit,
    required this.icon,
    required this.color,
    this.trend,
    this.isLoading = false,
    this.subMetrics,
  });

  @override
  State<KPICard> createState() => _KPICardState();
}

class _KPICardState extends State<KPICard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colorConfig = _KPIColorConfig.fromKPIColor(widget.color);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        decoration: AdminColors.of(context).cardDecoration.copyWith(
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: widget.isLoading
              ? _buildLoadingState()
              : _buildContent(context, colorConfig),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, _KPIColorConfig colorConfig) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        // Header: Icon + Trend badge
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorConfig.iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                widget.icon,
                size: AppSizes.iconSize(context),
                color: colorConfig.iconColor,
              ),
            ),
            if (widget.trend != null) _buildTrendBadge(widget.trend!),
          ],
        ),
        const SizedBox(height: 16),

        // Title
        Text(
          widget.title,
          style: AppSizes.bodySize(
            context,
          ).copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),

        // Value + Unit
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            if (widget.value != null) ...[
              Text(
                widget.value!,
                style: AppSizes.headlineSize(context).copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            if (widget.unit != null) ...[
              const SizedBox(width: 4),
              Text(
                widget.unit!,
                style: AppSizes.headlineSize(context).copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ],
        ),

        // Sous-métriques
        if (widget.subMetrics != null && widget.subMetrics!.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildSubMetrics(context),
        ],

        // Label de tendance
        if (widget.trend != null) ...[
          const SizedBox(height: 8),
          Text(
            widget.trend!.label,
            style: AppSizes.bodySize(context).copyWith(color: Colors.grey[500]),
          ),
        ],
      ],
    );
  }

  Widget _buildSubMetrics(BuildContext context) {
    return Column(
      children: widget.subMetrics!.map((metric) {
        final Color valueColor = switch (metric.status) {
          KPISubMetricStatus.success => const Color(0xFF16A34A), // green-600
          KPISubMetricStatus.warning => const Color(0xFFEA580C), // orange-600
          KPISubMetricStatus.error => const Color(0xFFDC2626), // red-600
          null => Colors.grey[900]!,
        };

        return Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  metric.label,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${metric.value}${metric.unit ?? '%'}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: valueColor,
                    ),
                  ),
                  if (metric.target != null) ...[
                    const SizedBox(width: 4),
                    Text(
                      '(obj: ${metric.target}${metric.unit ?? '%'})',
                      style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTrendBadge(KPITrend trend) {
    final isPositive = trend.value > 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isPositive
            ? const Color(0xFFDCFCE7) // green-100
            : const Color(0xFFFEE2E2), // red-100
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Transform.rotate(
            angle: isPositive ? 0 : 3.14159, // 180° si négatif
            child: Icon(
              Icons.trending_up,
              size: 12,
              color: isPositive
                  ? const Color(0xFF15803D) // green-700
                  : const Color(0xFFB91C1C), // red-700
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '${trend.value.abs()}%',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isPositive
                  ? const Color(0xFF15803D) // green-700
                  : const Color(0xFFB91C1C), // red-700
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _ShimmerBox(width: 48, height: 48, borderRadius: 12),
            _ShimmerBox(width: 60, height: 24, borderRadius: 20),
          ],
        ),
        const SizedBox(height: 16),
        _ShimmerBox(width: 100, height: 14, borderRadius: 4),
        const SizedBox(height: 8),
        _ShimmerBox(width: 80, height: 32, borderRadius: 4),
        const SizedBox(height: 16),
        _ShimmerBox(width: double.infinity, height: 36, borderRadius: 8),
        const SizedBox(height: 8),
        _ShimmerBox(width: double.infinity, height: 36, borderRadius: 8),
        const SizedBox(height: 8),
        _ShimmerBox(width: 120, height: 12, borderRadius: 4),
      ],
    );
  }
}

/// Effet shimmer pour le loading
class _ShimmerBox extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const _ShimmerBox({
    required this.width,
    required this.height,
    required this.borderRadius,
  });

  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(
      begin: -2,
      end: 2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value + 1, 0),
              colors: [Colors.grey[200]!, Colors.grey[100]!, Colors.grey[200]!],
            ),
          ),
        );
      },
    );
  }
}

/// Grille de KPI Cards responsive
///
/// Utilise [IntrinsicHeight] par ligne pour que toutes les cartes d'une même
/// ligne aient la même hauteur, même si certaines ont des sous-métriques.
class KPICardsGrid extends StatelessWidget {
  final List<KPICard> cards;

  const KPICardsGrid({super.key, required this.cards});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        // Responsive: 1 col mobile, 2 cols tablet, 4 cols desktop
        int crossAxisCount;
        if (Breakpoints.isMobile(width)) {
          crossAxisCount = 1;
        } else if (Breakpoints.isTablet(width)) {
          crossAxisCount = 2;
        } else {
          crossAxisCount = 4;
        }

        const spacing = 24.0;
        final rows = <Widget>[];

        for (int i = 0; i < cards.length; i += crossAxisCount) {
          final rowCards = cards.sublist(
            i,
            (i + crossAxisCount).clamp(0, cards.length),
          );

          rows.add(
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (int j = 0; j < rowCards.length; j++) ...[
                    if (j > 0) const SizedBox(width: spacing),
                    Expanded(child: rowCards[j]),
                  ],
                  // Cellules vides si la dernière ligne est incomplète
                  for (int j = rowCards.length; j < crossAxisCount; j++) ...[
                    const SizedBox(width: spacing),
                    const Expanded(child: SizedBox()),
                  ],
                ],
              ),
            ),
          );
        }

        return Column(
          spacing: spacing,
          children: rows,
        );
      },
    );
  }
}
