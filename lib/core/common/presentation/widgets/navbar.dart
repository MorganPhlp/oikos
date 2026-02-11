import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class OikosNavBar extends StatefulWidget {
  const OikosNavBar({super.key});

  @override
  State<OikosNavBar> createState() => _OikosNavBarState();
}

class _OikosNavBarState extends State<OikosNavBar> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return NavigationBar(
      backgroundColor: theme.colorScheme.surface,
      selectedIndex: currentPageIndex,
      indicatorColor: theme.colorScheme.tertiary.withValues(alpha: 0.1),
      onDestinationSelected: (int index) {
        setState(() {
          currentPageIndex = index;
        });

        switch (index) {
          case 0:
            context.go('/home');
            break;
          case 1: /* context.go('/catalogue'); */
            break;
          case 2: /* context.go('/actions'); */
            break;
          case 3:
            context.go('/scan_intro');
            break;
          case 4:
            context.go('/community');
            break;
        }
      },
      destinations: [
        NavigationDestination(
          icon: BouncingIcon(
            index: 0,
            currentIndex: currentPageIndex,
            child: Image.asset(
              'assets/logos/oikos_home.png',
              width: 26,
              height: 26,
              color: Colors.grey,
            ),
          ),
          selectedIcon: BouncingIcon(
            index: 0,
            currentIndex: currentPageIndex,
            child: Image.asset(
              'assets/logos/oikos_home.png',
              width: 26,
              height: 26,
              color: Colors.orange,
            ),
          ),
          label: 'Home',
        ),
        NavigationDestination(
          icon: BouncingIcon(
            index: 1,
            currentIndex: currentPageIndex,
            child: const Icon(Icons.menu_book, color: Colors.grey),
          ),
          selectedIcon: BouncingIcon(
            index: 1,
            currentIndex: currentPageIndex,
            child: const Icon(Icons.menu_book, color: Colors.orange),
          ),
          label: 'Catalogue',
        ),
        NavigationDestination(
          icon: BouncingIcon(
            index: 2,
            currentIndex: currentPageIndex,
            child: const Icon(Icons.star, color: Colors.grey),
          ),
          selectedIcon: BouncingIcon(
            index: 2,
            currentIndex: currentPageIndex,
            child: const Icon(Icons.star, color: Colors.orange),
          ),
          label: 'Actions',
        ),
        NavigationDestination(
          icon: BouncingIcon(
            index: 3,
            currentIndex: currentPageIndex,
            child: const Icon(Icons.qr_code_2, color: Colors.grey),
          ),
          selectedIcon: BouncingIcon(
            index: 3,
            currentIndex: currentPageIndex,
            child: const Icon(Icons.qr_code_2, color: Colors.orange),
          ),
          label: 'Scan',
        ),
        NavigationDestination(
          icon: BouncingIcon(
            index: 4,
            currentIndex: currentPageIndex,
            child: const Icon(LucideIcons.trophy, color: Colors.grey),
          ),
          selectedIcon: BouncingIcon(
            index: 4,
            currentIndex: currentPageIndex,
            child: const Icon(LucideIcons.trophy, color: Colors.orange),
          ),
          label: 'Classement',
        ),
      ],
    );
  }
}

/// Widget qui gère l'animation
class BouncingIcon extends StatefulWidget {
  final int index;
  final int currentIndex;
  final Widget child;

  const BouncingIcon({
    super.key,
    required this.index,
    required this.currentIndex,
    required this.child,
  });

  @override
  State<BouncingIcon> createState() => _BouncingIconState();
}

class _BouncingIconState extends State<BouncingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100), // Aller rapide
      reverseDuration: const Duration(milliseconds: 150), // Retour souple
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(covariant BouncingIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Déclenche l'animation uniquement quand l'onglet devient actif
    if (widget.currentIndex == widget.index &&
        oldWidget.currentIndex != widget.index) {
      _controller.forward().then((_) => _controller.reverse());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _scaleAnimation, child: widget.child);
  }
}
