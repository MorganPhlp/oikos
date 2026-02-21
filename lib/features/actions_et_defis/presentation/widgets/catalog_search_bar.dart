import 'package:flutter/material.dart';

class CatalogueSearchBar extends StatelessWidget {
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onFilterTap;
  final bool hasActiveFilters;

  const CatalogueSearchBar({
    super.key,
    required this.onSearchChanged,
    required this.onFilterTap,
    required this.hasActiveFilters,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(child: _SearchInput(onChanged: onSearchChanged)),
          const SizedBox(width: 10),
          _FilterButton(isActive: hasActiveFilters, onTap: onFilterTap),
        ],
      ),
    );
  }
}

class _SearchInput extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const _SearchInput({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Rechercher une action...',
          border: InputBorder.none,
          icon: Icon(Icons.search, color: theme.colorScheme.primary),
        ),
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final bool isActive;
  final VoidCallback onTap;
  const _FilterButton({required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isActive ? colorScheme.primary : colorScheme.surface,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isActive ? Colors.transparent : colorScheme.outline,
          ),
        ),
        child: Icon(
          Icons.filter_list,
          color: isActive
              ? colorScheme.onPrimary
              : colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
