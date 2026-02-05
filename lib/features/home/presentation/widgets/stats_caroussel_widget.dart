import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:oikos/core/theme/app_colors.dart';
import 'package:oikos/features/home/domain/entities/stats_cards_entitie.dart';

class StatsCarousselWidget extends StatefulWidget {
  final List<StatsCardsEntitie> allStatsCards;

  const StatsCarousselWidget({
    super.key,
    required this.allStatsCards,
    });

  @override
  State<StatsCarousselWidget> createState() => _StatsCarousselWidgetState();
}

class _StatsCarousselWidgetState extends State<StatsCarousselWidget> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9, initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onArrowTap(bool next) {
    int targetPage = next ? _currentPage + 1 : _currentPage - 1;
    
    // pour pas sortir des limites
    if (targetPage >= 0 && targetPage < widget.allStatsCards.length) {
      _pageController.animateToPage(
        targetPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // 1. Titre + Flèches
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _NavArrow(
              icon: LucideIcons.chevronLeft, 
              onTap: () => _onArrowTap(false),
            ),
            const SizedBox(width: 8),
            _NavArrow(
              icon: LucideIcons.chevronRight, 
              onTap: () => _onArrowTap(true),
            ),
          ],
        ),
        const SizedBox(height: 16),

        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (int index) {
              setState(() => _currentPage = index);
            },
            itemCount: widget.allStatsCards.length,
            itemBuilder: (context, index) {
              return _StatCard(card: widget.allStatsCards[index]);
            },
          ),
        ),
        const SizedBox(height: 12),

        // 3. Indicateurs de page (Dots)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.allStatsCards.length, (index) => _buildDot(index)),
        ),
      ],
    );
  }

  Widget _buildDot(int index) {
    bool isActive = _currentPage == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 20 : 8, // S'allonge quand actif
      decoration: BoxDecoration(
        color: isActive ? AppColors.lightPrimary : AppColors.lightBorder,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _NavArrow extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _NavArrow({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white, // Fond blanc pour détacher la flèche
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08), 
              blurRadius: 8, 
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon, 
          size: 16, 
          color: theme.colorScheme.primary, // Icône de la couleur du thème
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final StatsCardsEntitie card;

  const _StatCard({required this.card});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightPrimaryForeground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightPrimary.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkBackground.withValues(alpha: 0.04), 
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(card.icon, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 4),

          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    card.value.toStringAsFixed(card.value.truncateToDouble() == card.value ? 0 : 1),
                    style: TextStyle(
                      color: theme.colorScheme.primary, 
                      fontSize: 26, 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    card.unit, 
                    style: TextStyle(
                      color: theme.colorScheme.primary, 
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Text(
                card.text1,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.lightMutedForeground,
                ),
              ),
          
              if (card.text2 != null) ...[
                const SizedBox(width: 6),
                Text(
                  card.text2!,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ],
          ),
        ],
      )
    );
  }
}