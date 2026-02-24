import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../domain/entities/action_entity.dart';
import '../widgets/challenge_card.dart';

class MyActionsTab extends StatefulWidget {
  final List<ActionEntity> challenges;
  final Function(String actionId) onValidate;
  final Function(String actionId) onDelete;
  final Function(String actionId, bool isLifestyle) onSetLifestyle;

  // Action pour terminer les bonus
  final Function(String actionId) onCompleteBonus;

  const MyActionsTab({
    super.key,
    required this.challenges,
    required this.onValidate,
    required this.onDelete,
    required this.onSetLifestyle,
    required this.onCompleteBonus,
  });

  @override
  State<MyActionsTab> createState() => _MyActionsTabState();
}

class _MyActionsTabState extends State<MyActionsTab> {
  String selectedFilter = 'journalier';
  final Set<String> _justValidatedIds = {};

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Harmonise les noms de fréquence de la base de données
    String normalizeFrequency(String dbFreq) {
      String f = dbFreq.toLowerCase().trim();
      if (f.contains('quotidien') || f.contains('jour')) return 'journalier';
      if (f.contains('hebdo') || f.contains('semaine')) return 'hebdomadaire';
      if (f.contains('mensuel') || f.contains('mois')) return 'mensuel';
      if (f.contains('unique') || f.contains('bonus') || f.contains('shot')) return 'unique';
      return f;
    }

    // Définit le nombre de répétitions nécessaires par type
    int getTarget(String freq) {
      switch (freq) {
        case 'journalier': return 7;
        case 'hebdomadaire': return 4;
        case 'mensuel': return 3;
        case 'unique': return 1;
        default: return 1;
      }
    }

    // Filtre la liste selon l'onglet choisi
    final filteredList = widget.challenges.where((action) {
      final normalizedFreq = normalizeFrequency(action.frequency);
      if (selectedFilter == 'lifestyle') return action.isLifestyle;
      return normalizedFreq == selectedFilter && !action.isLifestyle;
    }).toList();

    int totalActions = filteredList.length;
    int actionsDoneToday = filteredList.where((a) => a.progress > 0 || _justValidatedIds.contains(a.id)).length;
    double globalProgress = (selectedFilter == 'lifestyle') ? 1.0 : (totalActions == 0 ? 0 : actionsDoneToday / totalActions);

    return Column(
      children: [
        // Carte de progression en haut de page
        Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colors.outline, width: 1),
            boxShadow: isDarkMode ? null : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedFilter == 'lifestyle' ? "Mes habitudes acquises" : "Ma progression (${_getFilterTitle(selectedFilter)})",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: colors.onSurface),
                  ),
                  Icon(selectedFilter == 'lifestyle' ? Icons.favorite : Icons.emoji_events, color: selectedFilter == 'lifestyle' ? colors.error : colors.tertiary),
                ],
              ),
              const SizedBox(height: 10),
              if (selectedFilter != 'lifestyle')
                Text("$actionsDoneToday/$totalActions actions avancées (total)", style: TextStyle(color: colors.onSurface.withOpacity(0.6), fontSize: 12)),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(value: globalProgress.clamp(0.0, 1.0), backgroundColor: colors.onSurface.withOpacity(0.1), color: selectedFilter == 'lifestyle' ? colors.primary : colors.tertiary, minHeight: 8),
              ),
            ],
          ),
        ),

        // Menu des filtres (Quotidien, Hebdo, etc.)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              _buildTabFilter("Quotidien", "journalier", colors, isDarkMode),
              const SizedBox(width: 10),
              _buildTabFilter("Hebdo", "hebdomadaire", colors, isDarkMode),
              const SizedBox(width: 10),
              _buildTabFilter("Mensuel", "mensuel", colors, isDarkMode),
              const SizedBox(width: 10),
              _buildTabFilter("Bonus", "unique", colors, isDarkMode),
              const SizedBox(width: 10),
              _buildTabFilter("Mode de vie", "lifestyle", colors, isDarkMode, isSpecial: true),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Liste des cartes
        Expanded(
          child: filteredList.isEmpty
              ? _buildEmptyState(colors)
              : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              final action = filteredList[index];
              final int currentProgress = _justValidatedIds.contains(action.id) ? action.progress + 1 : action.progress;
              final String normalizedFreq = normalizeFrequency(action.frequency);
              final target = getTarget(normalizedFreq);
              final isLifestyle = action.isLifestyle;
              final isJustValidated = _justValidatedIds.contains(action.id);
              final isBonus = normalizedFreq == 'unique';

              return Column(
                children: [
                  ChallengeCard(
                    action: action,
                    isCompleted: isLifestyle || isJustValidated,
                    onValidate: () {
                      if (isLifestyle) return;

                      // Si l'objectif est atteint
                      if (action.progress + 1 >= target) {
                        if (isBonus) {
                          // Terminer l'action bonus
                          widget.onValidate(action.id);
                          widget.onCompleteBonus(action.id);
                        } else {
                          // Demander si l'utilisateur veut en faire une habitude
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext dialogContext) => AlertDialog(
                              backgroundColor: colors.surface,
                              title: Text("Objectif atteint !", style: TextStyle(color: colors.onSurface, fontWeight: FontWeight.bold)),
                              content: Text("Félicitations ! Veux-tu adopter cette action définitivement ?", style: TextStyle(color: colors.onSurface.withOpacity(0.8))),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(dialogContext);
                                    widget.onValidate(action.id);
                                    widget.onDelete(action.id);
                                  },
                                  child: Text("Non, m'arrêter là", style: TextStyle(color: colors.error)),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: colors.primary),
                                  onPressed: () {
                                    Navigator.pop(dialogContext);
                                    widget.onValidate(action.id);
                                    widget.onSetLifestyle(action.id, true);
                                  },
                                  child: Text("Oui, je l'adopte !", style: TextStyle(color: colors.onPrimary)),
                                ),
                              ],
                            ),
                          );
                        }
                      } else {
                        widget.onValidate(action.id);
                      }
                    },
                    onDelete: () => _confirmDelete(context, action.id, colors),
                  ),

                  // Bouton de retrait en mode lifestyle
                  if (isLifestyle)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 20.0),
                      child: TextButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              backgroundColor: colors.surface,
                              title: Text("Retirer des habitudes ?", style: TextStyle(color: colors.onSurface)),
                              content: Text("L'action retournera dans le catalogue.", style: TextStyle(color: colors.onSurface.withOpacity(0.8))),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context), child: Text("Annuler", style: TextStyle(color: colors.onSurface))),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    widget.onDelete(action.id);
                                  },
                                  child: Text("Confirmer", style: TextStyle(color: colors.error)),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: Icon(Icons.remove_circle_outline, size: 18, color: colors.error),
                        label: Text("Retirer ce mode de vie", style: TextStyle(color: colors.error)),
                      ),
                    ),

                  // Barre de progression sous chaque carte
                  if (!isLifestyle)
                    Padding(
                      padding: const EdgeInsets.only(left: 60, right: 10, bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Progression : $currentProgress / $target ${_getUnit(normalizeFrequency(action.frequency))}", style: TextStyle(fontSize: 11, color: colors.primary, fontWeight: FontWeight.bold)),
                              Text("${(currentProgress / target * 100).toInt().clamp(0, 100)}%", style: TextStyle(fontSize: 10, color: colors.onSurface.withOpacity(0.6))),
                            ],
                          ),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(value: (currentProgress / target).clamp(0.0, 1.0), backgroundColor: colors.onSurface.withOpacity(0.1), color: colors.primary.withOpacity(0.6), minHeight: 4),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  // --- Boutons des onglets ---
  Widget _buildTabFilter(String label, String value, ColorScheme colors, bool isDarkMode, {bool isSpecial = false}) {
    final isSelected = selectedFilter == value;
    final activeColor = isSpecial ? colors.tertiary : colors.primary;

    return GestureDetector(
      onTap: () => setState(() => selectedFilter = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : colors.surface,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: isSelected ? Colors.transparent : colors.outline),
          boxShadow: (isSelected && !isDarkMode) ? [BoxShadow(color: activeColor.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))] : null,
        ),
        child: Text(label, style: TextStyle(color: isSelected ? colors.onPrimary : colors.onSurface, fontWeight: FontWeight.bold, fontSize: 13)),
      ),
    );
  }

  // État vide
  Widget _buildEmptyState(ColorScheme colors) {
    bool isLifestyle = selectedFilter == 'lifestyle';
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(isLifestyle ? LucideIcons.trophy : Icons.inventory_2_outlined, size: 60, color: colors.onSurface.withOpacity(0.2)),
          const SizedBox(height: 15),
          Text(isLifestyle ? "Pas encore de trophées." : "Aucun défi ${_getFilterTitle(selectedFilter).toLowerCase()}", style: TextStyle(color: colors.onSurface.withOpacity(0.5), fontSize: 16)),
        ],
      ),
    );
  }

  // Fenêtre de confirmation d'arrêt
  void _confirmDelete(BuildContext context, String actionId, ColorScheme colors) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.surface,
        title: Text("Arrêter ce défi ?", style: TextStyle(color: colors.onSurface)),
        content: Text("Il sera de nouveau disponible dans le catalogue.", style: TextStyle(color: colors.onSurface.withOpacity(0.7))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Annuler", style: TextStyle(color: colors.onSurface))),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onDelete(actionId);
            },
            child: Text("Arrêter", style: TextStyle(color: colors.error)),
          ),
        ],
      ),
    );
  }

  String _getFilterTitle(String filter) {
    switch (filter) {
      case 'journalier': return "Quotidien";
      case 'hebdomadaire': return "Hebdo";
      case 'mensuel': return "Mensuel";
      case 'unique': return "Bonus";
      case 'lifestyle': return "Mode de vie";
      default: return "";
    }
  }

  String _getUnit(String freq) {
    switch (freq) {
      case 'journalier': return "jours";
      case 'hebdomadaire': return "semaines";
      case 'mensuel': return "mois";
      default: return "fois";
    }
  }
}