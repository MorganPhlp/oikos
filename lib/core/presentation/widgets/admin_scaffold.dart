import 'package:flutter/material.dart';
import 'package:oikos/core/theme/admin_theme.dart';
import 'package:oikos/core/theme/breakpoints.dart';

class AdminScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  final Widget logo;
  final List<NavigationDestination> destinations;
  final int currentIndex;
  final ValueChanged<int> onNavigationIndexChange;
  final VoidCallback? onLogout;

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
        if (screenType == ScreenType.desktop ||
            screenType == ScreenType.tablet) {
          final isDesktop = screenType == ScreenType.desktop;
          return Scaffold(
            backgroundColor: AdminTheme.pageBackground,
            body: Row(
              children: [
                Container(
                  color: AdminTheme.background,
                  child: _buildSidebar(context, extended: isDesktop),
                ),
                Container(width: 1, color: AdminTheme.border),
                Expanded(child: _buildBody()),
              ],
            ),
          );
        }

        // --- MOBILE ---
        return Scaffold(
          backgroundColor: AdminTheme.pageBackground,
          appBar: _buildMobileAppBar(context),
          body: body,
          bottomNavigationBar: _buildMobileNav(),
        );
      },
    );
  }

  // ============================================================================
  // SIDEBAR (Desktop / Tablet)
  // ============================================================================

  Widget _buildSidebar(BuildContext context, {required bool extended}) {
    return NavigationRail(
      extended: extended,
      selectedIndex: currentIndex,
      onDestinationSelected: onNavigationIndexChange,
      backgroundColor: AdminTheme.background,
      labelType: extended
          ? NavigationRailLabelType.none
          : NavigationRailLabelType.all,
      indicatorColor: AdminTheme.actionGreenLight,
      selectedIconTheme: const IconThemeData(color: AdminTheme.actionGreen),
      selectedLabelTextStyle: const TextStyle(
        color: AdminTheme.actionGreen,
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      unselectedIconTheme: IconThemeData(color: AdminTheme.mutedForeground),
      unselectedLabelTextStyle: TextStyle(
        color: AdminTheme.mutedForeground,
        fontSize: 12,
      ),
      leading: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 100,
            width: extended ? 200 : 72,
            padding: const EdgeInsets.symmetric(
              vertical: AdminTheme.spacingMd,
              horizontal: AdminTheme.spacingSm,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                logo,
                if (extended) ...[
                  const SizedBox(width: AdminTheme.spacingSm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AdminTheme.foreground,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'admin dashboard',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AdminTheme.mutedForeground),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AdminTheme.spacingMd),
          _SidebarDivider(extended: extended),
        ],
      ),
      destinations: destinations.map((d) {
        return NavigationRailDestination(
          icon: d.icon,
          selectedIcon: d.selectedIcon ?? d.icon,
          label: Text(d.label),
        );
      }).toList(),
      trailing: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _SidebarDivider(extended: extended),
            const SizedBox(height: AdminTheme.spacingLg),
            _LogoutButton(extended: extended, onLogout: onLogout),
            const SizedBox(height: AdminTheme.spacingLg),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // BODY
  // ============================================================================

  Widget _buildBody() {
    return Container(
      color: AdminTheme.pageBackground,
      child: SafeArea(child: body),
    );
  }

  // ============================================================================
  // MOBILE APP BAR
  // ============================================================================

  PreferredSizeWidget _buildMobileAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AdminTheme.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 1,
      shadowColor: AdminTheme.border,
      titleSpacing: AdminTheme.spacingMd,
      title: Row(
        spacing: AdminTheme.spacingSm,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ConstrainedBox(constraints:   BoxConstraints(maxHeight: 32), child: logo),
          Flexible(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: AdminTheme.foreground,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            'Admin',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: AdminTheme.foreground,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: onLogout,
          icon: Icon(Icons.logout_rounded, color: AdminTheme.mutedForeground),
          tooltip: 'Déconnexion',
        ),
        const SizedBox(width: AdminTheme.spacingXs),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: AdminTheme.border),
      ),
    );
  }

  // ============================================================================
  // MOBILE NAV
  // ============================================================================

  Widget _buildMobileNav() {
    return Container(
      decoration: BoxDecoration(
        color: AdminTheme.background,
        border: Border(top: BorderSide(color: AdminTheme.border, width: 1)),
      ),
      child: NavigationBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        indicatorColor: AdminTheme.actionGreenLight,
        selectedIndex: currentIndex,
        onDestinationSelected: onNavigationIndexChange,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: destinations,
      ),
    );
  }
}

// ============================================================================
// PRIVATE WIDGETS
// ============================================================================

class _SidebarDivider extends StatelessWidget {
  final bool extended;
  const _SidebarDivider({required this.extended});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      width: extended ? 168 : 40,
      color: AdminTheme.border,
    );
  }
}

class _LogoutButton extends StatelessWidget {
  final bool extended;
  final VoidCallback? onLogout;

  const _LogoutButton({required this.extended, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    if (extended) {
      return TextButton.icon(
        onPressed: onLogout,
        icon: Icon(
          Icons.logout_rounded,
          size: 18,
          color: AdminTheme.mutedForeground,
        ),
        label: Text(
          'Déconnexion',
          style: TextStyle(
            color: AdminTheme.mutedForeground,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AdminTheme.spacingMd,
            vertical: AdminTheme.spacingSm,
          ),
        ),
      );
    }

    return IconButton(
      onPressed: onLogout,
      icon: Icon(Icons.logout_rounded, color: AdminTheme.mutedForeground),
      tooltip: 'Déconnexion',
    );
  }
}
