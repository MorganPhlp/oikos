import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:oikos/features/home/domain/entities/stats_cards_entitie.dart';

class StatsCarousselWidget extends StatefulWidget {
  final List<StatsCardsEntitie> allStatsCards;

  const StatsCarousselWidget({super.key, required this.allStatsCards});

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
    Theme.of(context);

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
            clipBehavior: Clip.none,
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
          children: List.generate(
            widget.allStatsCards.length,
            (index) => _buildDot(index),
          ),
        ),
      ],
    );
  }

  Widget _buildDot(int index) {
    bool isActive = _currentPage == index;
    ThemeData theme = Theme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 20 : 8,
      decoration: BoxDecoration(
        color: isActive
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurface.withValues(alpha: 0.1),
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

    return Material(
      // 1. Le Material doit être transparent ou porter la couleur du fond
      color: theme.colorScheme.surface,
      shape: const CircleBorder(),
      elevation: 2, // L'élévation gère l'ombre plus proprement que BoxShadow
      shadowColor: theme.colorScheme.onSurface.withValues(alpha: 0.2),
      clipBehavior:
          Clip.antiAlias, // Important : coupe le ripple pour qu'il reste rond
      child: InkWell(
        onTap: onTap,
        // 2. On peut personnaliser la couleur de l'onde
        splashColor: theme.colorScheme.primary.withValues(alpha: 0.1),
        highlightColor: theme.colorScheme.primary.withValues(alpha: 0.05),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: 16, color: theme.colorScheme.primary),
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
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.2),
            blurRadius: 35,
            offset: const Offset(0, 5),
          ),
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
                    card.value.toStringAsFixed(
                      card.value.truncateToDouble() == card.value ? 0 : 1,
                    ),
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
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
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
      ),
    );
  }
}
