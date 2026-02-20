import 'package:flutter/material.dart';
import 'package:oikos/core/theme/action_card_theme.dart';

/// Données de filtre transmises entre la page et la modale.
class FilterData {
  String? frequency;
  String? category;
  Set<String> tags;
  String sortBy;

  FilterData({
    this.frequency,
    this.category,
    Set<String>? tags,
    this.sortBy = 'default',
  }) : tags = tags ?? {};

  FilterData copy() => FilterData(
    frequency: frequency,
    category: category,
    tags: Set<String>.from(tags),
    sortBy: sortBy,
  );
}

class FilterSortModal extends StatefulWidget {
  final FilterData currentFilters;
  final List<String> allCategories;
  final List<String> allTags;
  final ValueChanged<FilterData> onApply;

  const FilterSortModal({
    super.key,
    required this.currentFilters,
    required this.allCategories,
    required this.allTags,
    required this.onApply,
  });

  @override
  State<FilterSortModal> createState() => _FilterSortModalState();

  static const frequencyMap = {
    'journalier': 'Quotidien',
    'hebdomadaire': 'Hebdomadaire',
    'mensuel': 'Mensuelle',
    'unique': 'Bonus',
  };
}

class _FilterSortModalState extends State<FilterSortModal> {
  late FilterData _tmp;

  @override
  void initState() {
    super.initState();
    _tmp = widget.currentFilters.copy();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // Title row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(Icons.filter_list, color: colorScheme.primary, size: 22),
                const SizedBox(width: 10),
                Text(
                  'Filtres & Tri',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => setState(() {
                    _tmp = FilterData();
                  }),
                  child: Text(
                    'Réinitialiser',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Tri (chips) ──
                  _buildSortSection(theme, colorScheme),
                  const SizedBox(height: 12),

                  // ── Fréquence (collapsible + checkboxes) ──
                  _buildCollapsibleSection(
                    theme: theme,
                    colorScheme: colorScheme,
                    title: 'Fréquence',
                    icon: Icons.schedule,
                    selectedCount: _tmp.frequency != null ? 1 : 0,
                    children: FilterSortModal.frequencyMap.entries.map((e) {
                      return CheckboxListTile(
                        dense: true,
                        visualDensity: VisualDensity.compact,
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: colorScheme.primary,
                        title: Text(
                          e.value,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: _tmp.frequency == e.key
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        value: _tmp.frequency == e.key,
                        onChanged: (checked) => setState(() {
                          _tmp.frequency = (checked == true) ? e.key : null;
                        }),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),

                  // ── Catégorie (collapsible + checkboxes) ──
                  _buildCollapsibleSection(
                    theme: theme,
                    colorScheme: colorScheme,
                    title: 'Catégorie',
                    icon: Icons.category_outlined,
                    selectedCount: _tmp.category != null ? 1 : 0,
                    children: widget.allCategories.map((cat) {
                      final catColor = theme
                          .extension<ActionCardTheme>()!
                          .getCategoryColor(cat);
                      return CheckboxListTile(
                        dense: true,
                        visualDensity: VisualDensity.compact,
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: catColor,
                        title: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: catColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                cat,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: _tmp.category == cat
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                        value: _tmp.category == cat,
                        onChanged: (checked) => setState(() {
                          _tmp.category = (checked == true) ? cat : null;
                        }),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),

                  // ── Sous-catégories (collapsible + checkboxes) ──
                  if (widget.allTags.isNotEmpty)
                    _buildCollapsibleSection(
                      theme: theme,
                      colorScheme: colorScheme,
                      title: 'Sous-catégories',
                      icon: Icons.label_outline,
                      selectedCount: _tmp.tags.length,
                      children: widget.allTags.map((tag) {
                        final sel = _tmp.tags.contains(tag);
                        return CheckboxListTile(
                          dense: true,
                          visualDensity: VisualDensity.compact,
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                          activeColor: colorScheme.tertiary,
                          title: Text(
                            tag,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: sel
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          value: sel,
                          onChanged: (checked) => setState(() {
                            if (checked == true) {
                              _tmp.tags.add(tag);
                            } else {
                              _tmp.tags.remove(tag);
                            }
                          }),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Bottom apply button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: () {
                    widget.onApply(_tmp);
                    Navigator.pop(context);
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Appliquer les filtres',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Sort chips section ─────────────────────────────────────────────────────

  Widget _buildSortSection(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trier par',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface.withValues(alpha: 0.65),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _sortChip(colorScheme, 'Par défaut', 'default'),
            _sortChip(colorScheme, 'Impact ↓', 'points_desc'),
            _sortChip(colorScheme, 'Impact ↑', 'points_asc'),
            _sortChip(colorScheme, 'Difficulté', 'difficulty'),
          ],
        ),
      ],
    );
  }

  Widget _sortChip(ColorScheme colorScheme, String label, String value) {
    final isSelected = _tmp.sortBy == value;

    return GestureDetector(
      onTap: () => setState(() => _tmp.sortBy = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withValues(alpha: 0.12)
              : colorScheme.onSurface.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outline.withValues(alpha: 0.25),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              Icon(Icons.check, size: 14, color: colorScheme.primary),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: isSelected ? colorScheme.primary : colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Collapsible filter section ─────────────────────────────────────────────

  Widget _buildCollapsibleSection({
    required ThemeData theme,
    required ColorScheme colorScheme,
    required String title,
    required IconData icon,
    required int selectedCount,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.15)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          childrenPadding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          leading: Icon(icon, size: 20, color: colorScheme.primary),
          title: Row(
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              if (selectedCount > 0) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$selectedCount',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
          children: children,
        ),
      ),
    );
  }
}
