import 'package:flutter/material.dart';
import 'package:oikos/core/theme/breakpoints.dart';

class ImpactStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final String badgeText;
  final List<Color> gradientColors;
  final bool isLoading;

  const ImpactStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.badgeText,
    required this.gradientColors,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final screenWidth = MediaQuery.of(context).size.width;

        // Déterminer les dimensions responsives
        final dimensions = _getResponsiveDimensions(screenWidth, width);

        return Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(dimensions.borderRadius),
          child: Container(
            padding: EdgeInsets.all(dimensions.padding),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(dimensions.borderRadius),
              boxShadow: [
                BoxShadow(
                  color: gradientColors[0].withValues(alpha: 0.3),
                  blurRadius: dimensions.shadowBlur,
                  offset: Offset(0, dimensions.shadowOffset),
                ),
              ],
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors,
              ),
            ),
            child: dimensions.isCompact
                ? _buildCompactLayout(dimensions)
                : _buildStandardLayout(dimensions),
          ),
        );
      },
    );
  }

  /// Layout standard (tablet et desktop)
  Widget _buildStandardLayout(_CardDimensions dim) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: Colors.white, size: dim.iconSize),
            _buildBadge(dim),
          ],
        ),
        const Spacer(),
        Text(
          title,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: dim.titleSize,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        isLoading
            ? _buildLoadingValue(dim)
            : Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: dim.valueSize,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
      ],
    );
  }

  /// Layout compact (mobile)
  Widget _buildCompactLayout(_CardDimensions dim) {
    return Row(
      children: [
        // Icône à gauche
        Container(
          padding: EdgeInsets.all(dim.iconPadding),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(dim.borderRadius * 0.5),
          ),
          child: Icon(icon, color: Colors.white, size: dim.iconSize),
        ),
        SizedBox(width: dim.padding * 0.75),
        // Contenu au milieu
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: dim.titleSize,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              isLoading
                  ? _buildLoadingValue(dim)
                  : Text(
                      value,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: dim.valueSize,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
            ],
          ),
        ),
        // Badge à droite
        _buildBadge(dim),
      ],
    );
  }

  /// Widget de chargement pour la valeur
  Widget _buildLoadingValue(_CardDimensions dim) {
    return Container(
      width: dim.valueSize * 4,
      height: dim.valueSize,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: const _ShimmerEffect(),
      ),
    );
  }

  Widget _buildBadge(_CardDimensions dim) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dim.badgePaddingH,
        vertical: dim.badgePaddingV,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        badgeText,
        style: TextStyle(
          color: Colors.white,
          fontSize: dim.badgeSize,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  _CardDimensions _getResponsiveDimensions(double screenWidth, double cardWidth) {
    // Mobile
    if (screenWidth < Breakpoints.mobile) {
      return _CardDimensions(
        padding: 16,
        iconSize: 24,
        iconPadding: 8,
        titleSize: 13,
        valueSize: 18,
        badgeSize: 11,
        badgePaddingH: 8,
        badgePaddingV: 3,
        borderRadius: 16,
        shadowBlur: 8,
        shadowOffset: 3,
        isCompact: true,
      );
    }
    // Tablet
    if (screenWidth < Breakpoints.tablet) {
      return _CardDimensions(
        padding: 20,
        iconSize: 28,
        iconPadding: 10,
        titleSize: 14,
        valueSize: 20,
        badgeSize: 12,
        badgePaddingH: 10,
        badgePaddingV: 4,
        borderRadius: 18,
        shadowBlur: 10,
        shadowOffset: 4,
        isCompact: cardWidth < 200,
      );
    }
    // Desktop
    if (screenWidth < Breakpoints.desktop) {
      return _CardDimensions(
        padding: 22,
        iconSize: 30,
        iconPadding: 12,
        titleSize: 15,
        valueSize: 22,
        badgeSize: 13,
        badgePaddingH: 11,
        badgePaddingV: 4,
        borderRadius: 20,
        shadowBlur: 10,
        shadowOffset: 4,
        isCompact: false,
      );
    }
    // Desktop Large
    return _CardDimensions(
      padding: 24,
      iconSize: 32,
      iconPadding: 12,
      titleSize: 16,
      valueSize: 24,
      badgeSize: 14,
      badgePaddingH: 12,
      badgePaddingV: 4,
      borderRadius: 20,
      shadowBlur: 10,
      shadowOffset: 4,
      isCompact: false,
    );
  }
}

class _CardDimensions {
  final double padding;
  final double iconSize;
  final double iconPadding;
  final double titleSize;
  final double valueSize;
  final double badgeSize;
  final double badgePaddingH;
  final double badgePaddingV;
  final double borderRadius;
  final double shadowBlur;
  final double shadowOffset;
  final bool isCompact;

  const _CardDimensions({
    required this.padding,
    required this.iconSize,
    required this.iconPadding,
    required this.titleSize,
    required this.valueSize,
    required this.badgeSize,
    required this.badgePaddingH,
    required this.badgePaddingV,
    required this.borderRadius,
    required this.shadowBlur,
    required this.shadowOffset,
    required this.isCompact,
  });
}

/// Effet shimmer pour le chargement
class _ShimmerEffect extends StatefulWidget {
  const _ShimmerEffect();

  @override
  State<_ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<_ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: -1, end: 2).animate(
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
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value, 0),
              colors: [
                Colors.white.withValues(alpha: 0.0),
                Colors.white.withValues(alpha: 0.3),
                Colors.white.withValues(alpha: 0.0),
              ],
            ),
          ),
        );
      },
    );
  }
}