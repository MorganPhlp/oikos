import 'package:flutter/material.dart';
import 'package:oikos/core/theme/app_size.dart';
import 'package:oikos/core/theme/breakpoints.dart';

/// Couleurs disponibles pour les KPI Cards
enum KPIColor {
  green,
  blue,
  purple,
  orange,
}

/// Données de tendance (trend)
class KPITrend {
  final double value;
  final String label;

  const KPITrend({
    required this.value,
    required this.label,
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
            colors: [Color(0xFF22C55E), Color(0xFF16A34A)], // green-500 to green-600
          ),
        );
      case KPIColor.blue:
        return _KPIColorConfig(
          iconColor: const Color(0xFF2563EB), // blue-600
          iconBgColor: const Color(0xFFEFF6FF), // blue-50
          gradient: const LinearGradient(
            colors: [Color(0xFF3B82F6), Color(0xFF2563EB)], // blue-500 to blue-600
          ),
        );
      case KPIColor.purple:
        return _KPIColorConfig(
          iconColor: const Color(0xFF9333EA), // purple-600
          iconBgColor: const Color(0xFFFAF5FF), // purple-50
          gradient: const LinearGradient(
            colors: [Color(0xFFA855F7), Color(0xFF9333EA)], // purple-500 to purple-600
          ),
        );
      case KPIColor.orange:
        return _KPIColorConfig(
          iconColor: const Color(0xFFEA580C), // orange-600
          iconBgColor: const Color(0xFFFFF7ED), // orange-50
          gradient: const LinearGradient(
            colors: [Color(0xFFF97316), Color(0xFFEA580C)], // orange-500 to orange-600
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
/// - Une tendance optionnelle (pourcentage + label)
/// 
/// ## Exemple d'utilisation
/// ```dart
/// KPICard(
///   title: 'CO₂ Total Économisé',
///   value: '247.8',
///   unit: 'tonnes',
///   icon: Icons.trending_down,
///   color: KPIColor.green,
/// )
/// ```
class KPICard extends StatefulWidget {
  final String title;
  final String value;
  final String? unit;
  final IconData icon;
  final KPIColor color;
  final KPITrend? trend;
  final bool isLoading;

  const KPICard({
    super.key,
    required this.title,
    required this.value,
    this.unit,
    required this.icon,
    required this.color,
    this.trend,
    this.isLoading = false,
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
        // S'étend sur toute la largeur disponible
        width: double.infinity, 
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: _isHovered ? 0.12 : 0.08),
              blurRadius: _isHovered ? 20 : 10,
              offset: Offset(0, _isHovered ? 8 : 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: widget.isLoading 
              ? _buildLoadingState()
              : _buildContent(context, colorConfig), // Ajout du context ici
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, _KPIColorConfig colorConfig) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header: Icon + Trend
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
                // Utilisation de AppSizes pour l'icône
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
          // Utilisation de titleSize ou bodySize selon ton choix de design
          style: AppSizes.bodySize(context).copyWith(
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),

        // Value + Unit
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              widget.value,
              // Utilisation de headlineSize pour la valeur numérique
              style: AppSizes.headlineSize(context).copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey[900],
              ),
            ),
            if (widget.unit != null) ...[
              const SizedBox(width: 4),
              Text(
                widget.unit!,
                // Unité légèrement plus petite que la valeur
                style: AppSizes.headlineSize(context).copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ],
        ),

        if (widget.trend != null) ...[
          const SizedBox(height: 8),
          Text(
            widget.trend!.label,
            style: AppSizes.bodySize(context).copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ],
    );
  }
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
        const SizedBox(height: 8),
        _ShimmerBox(width: 120, height: 12, borderRadius: 4),
      ],
    );
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
    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
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
              colors: [
                Colors.grey[200]!,
                Colors.grey[100]!,
                Colors.grey[200]!,
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Grille de KPI Cards responsive
class KPICardsGrid extends StatelessWidget {
  final List<KPICard> cards;

  const KPICardsGrid({
    super.key,
    required this.cards,
  });

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

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: 1.4,
          ),
          itemCount: cards.length,
          itemBuilder: (context, index) => cards[index],
        );
      },
    );
  }
}