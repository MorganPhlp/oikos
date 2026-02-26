import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/common/domain/entities/utilisateurs.dart';
import 'package:oikos/core/theme/app_theme.dart';
import 'package:oikos/core/theme/breakpoints.dart';
import 'package:oikos/core/utils/show_snackbar.dart';
import 'package:oikos/features/admin/data/models/core/company.dart';
import 'package:oikos/features/admin/presentation/bloc/users_bloc.dart';
import 'package:oikos/features/admin/presentation/bloc/users_event.dart';
import 'package:oikos/features/admin/presentation/bloc/users_state.dart';
import 'package:oikos/features/admin/presentation/widget/users_page/user_mobile_card.dart';
import 'package:oikos/features/admin/presentation/widget/users_page/users_desktop_table.dart';
import 'package:oikos/features/admin/presentation/widget/users_page/users_filter_bar.dart';

class UsersPage extends StatefulWidget {
  final Utilisateurs user;
  final Company company;

  const UsersPage({super.key, required this.user, required this.company});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  void initState() {
    super.initState();
    context.read<UsersBloc>().add(
      UsersDataFetched(companyId: widget.company.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UsersBloc, UsersState>(
      listener: (context, state) {
        if (state is UsersLoaded && state.successMessage != null) {
          showSnackBar(context, state.successMessage!);
        }
      },
      builder: (context, state) {
        if (state is UsersLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is UsersError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  color: AppTheme.errorForeground,
                  size: 48,
                ),
                const SizedBox(height: AppTheme.spacingMd),
                Text(
                  state.message,
                  style: const TextStyle(color: AppTheme.errorForeground),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.spacingMd),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.actionGreen,
                  ),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Réessayer'),
                  onPressed: () => context.read<UsersBloc>().add(
                    UsersDataFetched(companyId: widget.company.id),
                  ),
                ),
              ],
            ),
          );
        }

        if (state is UsersLoaded) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = Breakpoints.isMobile(constraints.maxWidth);
              return _UsersContent(state: state, isMobile: isMobile);
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CONTENU PRINCIPAL
// ─────────────────────────────────────────────────────────────────────────────

class _UsersContent extends StatelessWidget {
  final UsersLoaded state;
  final bool isMobile;

  const _UsersContent({required this.state, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context),
              const SizedBox(height: AppTheme.spacingLg),
              _buildStatsRow(context),
              const SizedBox(height: AppTheme.spacingLg),
              _buildBody(context),
              const SizedBox(height: AppTheme.spacingLg),
            ],
          ),
        ),
        // Overlay de chargement pendant l'anonymisation
        if (state.isAnonymizing)
          Container(
            color: Colors.black.withValues(alpha: 0.3),
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  // ── En-tête avec filtres ───────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    final colors = AdminColors.of(context);
    return Container(
      decoration: colors.cardDecoration,
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.people_rounded,
                color: AppTheme.actionGreen,
                size: 28,
              ),
              const SizedBox(width: AppTheme.spacingSm),
              Text(
                'Utilisateurs',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const Spacer(),
              if (isMobile)
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.actionGreen,
                    side: const BorderSide(color: AppTheme.actionGreen),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    ),
                  ),
                  icon: const Icon(Icons.tune_rounded, size: 16),
                  label: const Text('Filtres'),
                  onPressed: () => showUsersFilterSheet(context, state),
                ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMd),
          // Desktop → filtres inline ; Mobile → résumé des filtres actifs
          if (!isMobile)
            UsersFilterBar(state: state)
          else
            UsersFilterSummary(state: state),
        ],
      ),
    );
  }

  // ── KPI cards ─────────────────────────────────────────────────────────────

  Widget _buildStatsRow(BuildContext context) {
    final totalActifs = state.data.users
        .where((u) => u.etatCompte == EtatCompte.actif)
        .length;

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.people_rounded,
            label: 'Utilisateurs actifs',
            value: '$totalActifs',
          ),
        ),
        const SizedBox(width: AppTheme.spacingMd),
        Expanded(
          child: _StatCard(
            icon: Icons.filter_list_rounded,
            label: 'Résultats filtrés',
            value: '${state.filteredUsers.length}',
          ),
        ),
        const SizedBox(width: AppTheme.spacingMd),
        Expanded(
          child: _StatCard(
            icon: Icons.group_work_rounded,
            label: 'Communautés',
            value: '${state.data.communities.length}',
          ),
        ),
      ],
    );
  }

  // ── Corps (tableau ou cartes) ──────────────────────────────────────────────

  Widget _buildBody(BuildContext context) {
    if (state.filteredUsers.isEmpty) {
      return _EmptyState();
    }

    if (isMobile) {
      return Column(
        children: state.filteredUsers.map((user) {
          final communityName = state.data.communities
              .where((c) => c.code == user.codeCommunaute)
              .firstOrNull
              ?.name;
         

          return Padding(
            padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
            child: UserMobileCard(
              user: user,
              communityName: communityName,
            ),
          );
        }).toList(),
      );
    }

    return UsersDesktopTable(
      users: state.filteredUsers,
      communities: state.data.communities,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// WIDGETS SECONDAIRES
// ─────────────────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AdminColors.of(context);
    return Container(
      decoration: colors.cardDecoration,
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingSm),
            decoration: BoxDecoration(
              color: AppTheme.actionGreenLight,
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
            child: Icon(icon, size: 20, color: AppTheme.actionGreen),
          ),
          const SizedBox(width: AppTheme.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colors.mutedForeground,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = AdminColors.of(context);
    return Container(
      decoration: colors.cardDecoration,
      padding: const EdgeInsets.all(AppTheme.spacingXxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64,
            color: colors.mutedForeground,
          ),
          const SizedBox(height: AppTheme.spacingMd),
          Text(
            'Aucun utilisateur trouvé',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Text(
            'Essayez de modifier vos filtres de recherche.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: colors.mutedForeground),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
