import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/theme/admin_theme.dart';
import 'package:oikos/features/admin/presentation/bloc/users_bloc.dart';
import 'package:oikos/features/admin/presentation/bloc/users_event.dart';
import 'package:oikos/features/admin/presentation/bloc/users_state.dart';

// ─────────────────────────────────────────────────────────────────────────────
// BARRE DESKTOP (inline)
// ─────────────────────────────────────────────────────────────────────────────

/// Filtres affichés en ligne sur desktop.
class UsersFilterBar extends StatelessWidget {
  final UsersLoaded state;

  const UsersFilterBar({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 3, child: _SearchField(state: state)),
        const SizedBox(width: AdminTheme.spacingMd),
        Expanded(flex: 2, child: _CommunityDropdown(state: state)),
        const SizedBox(width: AdminTheme.spacingMd),
        _SortToggle(state: state),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// RÉSUMÉ MOBILE (chips)
// ─────────────────────────────────────────────────────────────────────────────

/// Affiche les filtres actifs sous forme de chips sur mobile.
class UsersFilterSummary extends StatelessWidget {
  final UsersLoaded state;

  const UsersFilterSummary({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final hasActiveFilters = state.searchQuery.isNotEmpty ||
        state.selectedCommunityCode != null;

    return Wrap(
      spacing: AdminTheme.spacingSm,
      runSpacing: AdminTheme.spacingXs,
      children: [
        _FilterChip(
          label: state.sortOrder == UsersSortOrder.pseudoAsc
              ? 'Pseudo A→Z'
              : 'Pseudo Z→A',
          icon: Icons.sort_by_alpha_rounded,
        ),
        if (state.selectedCommunityCode != null)
          _FilterChip(
            label: 'Communauté filtrée',
            icon: Icons.group_rounded,
          ),
        if (hasActiveFilters)
          TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: AdminTheme.errorForeground,
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            icon: const Icon(Icons.clear_rounded, size: 14),
            label: const Text('Réinitialiser',
                style: TextStyle(fontSize: 12)),
            onPressed: () {
              context.read<UsersBloc>()
                ..add(UsersSearchChanged(query: ''))
                ..add(UsersCommunityFilterChanged());
            },
          ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _FilterChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AdminTheme.actionGreenLight,
        borderRadius: BorderRadius.circular(AdminTheme.radiusXxl),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AdminTheme.actionGreen),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AdminTheme.actionGreen,
              fontWeight: AdminTheme.fontWeightMedium,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BOTTOM SHEET MOBILE
// ─────────────────────────────────────────────────────────────────────────────

/// Ouvre le bottom sheet de filtres sur mobile.
void showUsersFilterSheet(BuildContext context, UsersLoaded state) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider.value(
      value: context.read<UsersBloc>(),
      child: _UsersFilterSheet(state: state),
    ),
  );
}

class _UsersFilterSheet extends StatelessWidget {
  final UsersLoaded state;

  const _UsersFilterSheet({required this.state});

  @override
  Widget build(BuildContext context) {
    final colors = AdminColors.of(context);
    return Container(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AdminTheme.radiusXxl),
        ),
      ),
      padding: const EdgeInsets.all(AdminTheme.spacingLg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colors.muted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AdminTheme.spacingLg),
          Text('Filtres & Tri',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AdminTheme.spacingLg),
          Text('Recherche',
              style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: AdminTheme.spacingSm),
          _SearchField(state: state),
          const SizedBox(height: AdminTheme.spacingLg),
          Text('Communauté',
              style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: AdminTheme.spacingSm),
          _CommunityDropdown(state: state),
          const SizedBox(height: AdminTheme.spacingLg),
          Text('Tri par pseudo',
              style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: AdminTheme.spacingSm),
          _SortButtons(state: state),
          const SizedBox(height: AdminTheme.spacingLg),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AdminTheme.actionGreen,
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Appliquer',style:TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(height: AdminTheme.spacingMd),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// COMPOSANTS PARTAGÉS
// ─────────────────────────────────────────────────────────────────────────────

class _SearchField extends StatefulWidget {
  final UsersLoaded state;

  const _SearchField({required this.state});

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.state.searchQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AdminColors.of(context);
    return TextField(
      controller: _controller,
      onChanged: (v) =>
          context.read<UsersBloc>().add(UsersSearchChanged(query: v)),
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        hintText: 'Rechercher par pseudo ou email…',
        prefixIcon: const Icon(Icons.search_rounded, size: 18),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear_rounded, size: 16),
                onPressed: () {
                  _controller.clear();
                  context
                      .read<UsersBloc>()
                      .add(UsersSearchChanged(query: ''));
                },
              )
            : null,
        filled: true,
        fillColor: colors.inputBackground,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AdminTheme.spacingMd,
          vertical: AdminTheme.spacingSm,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AdminTheme.radiusMd),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AdminTheme.radiusMd),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _CommunityDropdown extends StatelessWidget {
  final UsersLoaded state;

  const _CommunityDropdown({required this.state});

  @override
  Widget build(BuildContext context) {
    final colors = AdminColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AdminTheme.spacingMd),
      decoration: BoxDecoration(
        color: colors.inputBackground,
        borderRadius: BorderRadius.circular(AdminTheme.radiusMd),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value: state.selectedCommunityCode,
          isExpanded: true,
          dropdownColor: colors.card,
          style: Theme.of(context).textTheme.bodyMedium,
          hint: Text(
            'Toutes les communautés',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.mutedForeground,
                ),
          ),
          items: [
            DropdownMenuItem<String?>(
              value: null,
              child: Text(
                'Toutes les communautés',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            ...state.data.communities.map(
              (c) => DropdownMenuItem<String?>(
                value: c.code,
                child: Text(c.name,
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
            ),
          ],
          onChanged: (code) => context
              .read<UsersBloc>()
              .add(UsersCommunityFilterChanged(communityCode: code)),
        ),
      ),
    );
  }
}

class _SortToggle extends StatelessWidget {
  final UsersLoaded state;

  const _SortToggle({required this.state});

  @override
  Widget build(BuildContext context) {
    final isAsc = state.sortOrder == UsersSortOrder.pseudoAsc;
    return Tooltip(
      message: isAsc
          ? 'Pseudo A→Z — cliquer pour Z→A'
          : 'Pseudo Z→A — cliquer pour A→Z',
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: AdminTheme.actionGreen,
          side: const BorderSide(color: AdminTheme.actionGreen),
          padding: const EdgeInsets.symmetric(
            horizontal: AdminTheme.spacingMd,
            vertical: AdminTheme.spacingSm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AdminTheme.radiusMd),
          ),
        ),
        icon: Icon(
          isAsc
              ? Icons.arrow_upward_rounded
              : Icons.arrow_downward_rounded,
          size: 16,
        ),
        label: Text(isAsc ? 'A → Z' : 'Z → A'),
        onPressed: () => context.read<UsersBloc>().add(
              UsersSortOrderChanged(
                sortOrder: isAsc
                    ? UsersSortOrder.pseudoDesc
                    : UsersSortOrder.pseudoAsc,
              ),
            ),
      ),
    );
  }
}

class _SortButtons extends StatelessWidget {
  final UsersLoaded state;

  const _SortButtons({required this.state});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SortButton(
            label: 'A → Z',
            isSelected: state.sortOrder == UsersSortOrder.pseudoAsc,
            onTap: () => context.read<UsersBloc>().add(
                  UsersSortOrderChanged(sortOrder: UsersSortOrder.pseudoAsc),
                ),
          ),
        ),
        const SizedBox(width: AdminTheme.spacingSm),
        Expanded(
          child: _SortButton(
            label: 'Z → A',
            isSelected: state.sortOrder == UsersSortOrder.pseudoDesc,
            onTap: () => context.read<UsersBloc>().add(
                  UsersSortOrderChanged(sortOrder: UsersSortOrder.pseudoDesc),
                ),
          ),
        ),
      ],
    );
  }
}

class _SortButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SortButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: AdminTheme.spacingMd),
        decoration: BoxDecoration(
          color: isSelected ? AdminTheme.actionGreenLight : Colors.transparent,
          borderRadius: BorderRadius.circular(AdminTheme.radiusMd),
          border: Border.all(
            color: isSelected
                ? AdminTheme.actionGreen
                : AdminColors.of(context).border,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? AdminTheme.actionGreen
                    : AdminColors.of(context).mutedForeground,
              ),
        ),
      ),
    );
  }
}
