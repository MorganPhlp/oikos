import 'package:flutter/material.dart';
import 'package:oikos/core/theme/breakpoints.dart';

class AdminScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  final Widget logo; 
  final List<NavigationDestination> destinations;
  final int currentIndex;
  final ValueChanged<int> onNavigationIndexChange;
  final VoidCallback? onLogout; // Ajout pour gérer la déconnexion

  const AdminScaffold({
    super.key,
    required this.body,
    required this.title,
    required this.destinations,
    required this.currentIndex,
    required this.onNavigationIndexChange,
    required this.logo,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final screenType = Breakpoints.getScreenType(width);

        // --- DESKTOP & TABLETTE (Sidebar / Rail) ---
        if (screenType == ScreenType.desktop || screenType == ScreenType.tablet) {
          final isDesktop = screenType == ScreenType.desktop;
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Row(
              children: [
                _buildSidebar(context, extended: isDesktop),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(child: _buildBody()),
              ],
            ),
          );
        }

        // --- MOBILE ---
        return Scaffold(
          body: body,
          bottomNavigationBar: NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: onNavigationIndexChange,
            destinations: destinations,
          ),
        );
      },
    );
  }

  Widget _buildSidebar(BuildContext context, {required bool extended}) {
    return NavigationRail(
      extended: extended,
      selectedIndex: currentIndex,
      onDestinationSelected: onNavigationIndexChange,
      labelType: extended ? NavigationRailLabelType.none : NavigationRailLabelType.all,
      leading: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 100,
        width: extended ? 180 : 60,
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            logo,
            if (extended) ...[
              const SizedBox(width: 12),
              Text(title, style: Theme.of(context).textTheme.headlineMedium),
            ],
          ],
        ),
      ),
      destinations: destinations.map((d) {
        return NavigationRailDestination(
          icon: d.icon,
          selectedIcon: d.selectedIcon ?? d.icon,
          label: Text(d.label),
        );
      }).toList(),
      // Bouton de déconnexion en bas du rail
      trailing: Expanded(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: IconButton(
              onPressed: onLogout,
              icon: const Icon(Icons.logout),
              tooltip: 'Déconnexion',
            ),
          ),
        ),
      ),
    );
  }

 

  Widget _buildBody() {
    return Container(
      color: Colors.grey.withValues(alpha:0.05), // Optionnel: fond léger pour le dashboard
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: body,
        ),
      ),
    );
  }
}