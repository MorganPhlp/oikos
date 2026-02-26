import 'package:flutter/material.dart';
import 'package:oikos/core/theme/app_theme.dart';
import 'package:oikos/core/theme/breakpoints.dart';

/// Root scaffold for the admin section.
///
/// Uses [AdminColors] from the parent [AppTheme] — no additional theme injection needed.
/// All child widgets can call [AdminColors.of(context)] directly.
class AdminScaffold extends StatelessWidget {
  final Widget body;
  final Widget logo;
  final List<NavigationDestination> destinations;
  final int currentIndex;
  final ValueChanged<int> onNavigationIndexChange;
  final VoidCallback? onLogout;

  const AdminScaffold({
    super.key,
    required this.body,
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
        final screenType = Breakpoints.getScreenType(constraints.maxWidth);

        if (screenType == ScreenType.desktop ||
            screenType == ScreenType.tablet) {
          return _buildWideLayout(
            context,
            extended: screenType == ScreenType.desktop,
          );
        }

        return _buildMobileLayout(context);
      },
    );
  }

  // ============================================================================
  // DESKTOP / TABLET LAYOUT
  // ============================================================================

  Widget _buildWideLayout(BuildContext context, {required bool extended}) {
    final colors = AdminColors.of(context);
    return Scaffold(
      backgroundColor: colors.pageBackground,
      body: Row(
        children: [
          // Sidebar
          Container(
            color: colors.sidebarBackground,
            child: _buildSidebar(context, extended: extended),
          ),
          // Séparateur
          Container(width: 1, color: colors.border),
          // Corps principal
          Expanded(child: _buildBody(context)),
        ],
      ),
    );
  }

  // ============================================================================
  // MOBILE LAYOUT
  // ============================================================================

  Widget _buildMobileLayout(BuildContext context) {
    final colors = AdminColors.of(context);
    return Scaffold(
      backgroundColor: colors.pageBackground,
      appBar: _buildMobileAppBar(context),
      body: body,
      bottomNavigationBar: _buildMobileNav(context),
    );
  }

  // ============================================================================
  // SIDEBAR (Desktop / Tablet)
  // ============================================================================

  Widget _buildSidebar(BuildContext context, {required bool extended}) {
    final colors = AdminColors.of(context);
    return NavigationRail(
      extended: extended,
      selectedIndex: currentIndex,
      onDestinationSelected: onNavigationIndexChange,
      backgroundColor: colors.sidebarBackground,
      labelType: extended
          ? NavigationRailLabelType.none
          : NavigationRailLabelType.all,
      indicatorColor: AppTheme.actionGreenLight,
      selectedIconTheme: const IconThemeData(color: AppTheme.actionGreen),
      selectedLabelTextStyle: const TextStyle(
        color: AppTheme.actionGreen,
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      unselectedIconTheme: IconThemeData(color: colors.mutedForeground),
      unselectedLabelTextStyle: TextStyle(
        color: colors.mutedForeground,
        fontSize: 12,
      ),
      leading: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 100,
            width: extended ? 200 : 72,
            padding: const EdgeInsets.symmetric(
              vertical: AppTheme.spacingMd,
              horizontal: AppTheme.spacingSm,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                logo,
                if (extended) ...[
                  const SizedBox(width: AppTheme.spacingSm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/logos/oikos_logo.png'),
                        Text(
                          'admin dashboard',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: colors.mutedForeground),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppTheme.spacingMd),
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
            const SizedBox(height: AppTheme.spacingLg),
            _LogoutButton(extended: extended, onLogout: onLogout),
            const SizedBox(height: AppTheme.spacingLg),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // BODY (Desktop / Tablet)
  // ============================================================================

  Widget _buildBody(BuildContext context) {
    final colors = AdminColors.of(context);
    return ColoredBox(
      color: colors.pageBackground,
      child: SafeArea(child: body),
    );
  }

  // ============================================================================
  // MOBILE APP BAR
  // ============================================================================

  PreferredSizeWidget _buildMobileAppBar(BuildContext context) {
    final colors = AdminColors.of(context);
    return AppBar(
      backgroundColor: colors.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 1,
      shadowColor: colors.border,
      titleSpacing: AppTheme.spacingMd,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
        child: Row(
          spacing: AppTheme.spacingSm,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 32),
              child: logo,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset('assets/logos/oikos_logo.png', height: 32),
                Text(
                  'admin',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: colors.mutedForeground,
                  ),
                ),
              ],
            ),
            const SizedBox.shrink(),
          ],
        ),
      ),
      actions: [
        IconButton(
          onPressed: onLogout,
          icon: Icon(Icons.logout_rounded, color: colors.mutedForeground),
          tooltip: 'Déconnexion',
        ),
        const SizedBox(width: AppTheme.spacingXs),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: colors.border),
      ),
    );
  }

  // ============================================================================
  // MOBILE BOTTOM NAV
  // ============================================================================

  Widget _buildMobileNav(BuildContext context) {
    final colors = AdminColors.of(context);
    return Container(
      decoration: BoxDecoration(
        color: colors.background,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: NavigationBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        indicatorColor: AppTheme.actionGreen,
        selectedIndex: currentIndex,
        onDestinationSelected: onNavigationIndexChange,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
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
      color: AdminColors.of(context).border,
    );
  }
}

class _LogoutButton extends StatelessWidget {
  final bool extended;
  final VoidCallback? onLogout;

  const _LogoutButton({required this.extended, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final color = AdminColors.of(context).mutedForeground;
    if (extended) {
      return TextButton.icon(
        onPressed: onLogout,
        icon: Icon(Icons.logout_rounded, size: 18, color: color),
        label: Text(
          'Déconnexion',
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingMd,
            vertical: AppTheme.spacingSm,
          ),
        ),
      );
    }
    return IconButton(
      onPressed: onLogout,
      icon: Icon(Icons.logout_rounded, color: color),
      tooltip: 'Déconnexion',
    );
  }
}
