import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../domain/entities/action_entity.dart';
import '../widgets/challenge_card.dart';
import '../../../../../core/theme/app_colors.dart';

class MyActionsTab extends StatefulWidget {
  final List<ActionEntity> challenges;
  // 👇 MODIFICATION : On retire 'dynamic proof' de la signature
  final Function(String actionId) onValidate;
  final Function(String actionId) onDelete;

  const MyActionsTab({
    super.key,
    required this.challenges,
    required this.onValidate,
    required this.onDelete,
  });

  @override
  State<MyActionsTab> createState() => _MyActionsTabState();
}

class _MyActionsTabState extends State<MyActionsTab> {
  String selectedFilter = 'journalier';
  final Map<String, int> _progressMap = {};
  final Set<String> _justValidatedIds = {};

  @override
  Widget build(BuildContext context) {
    // 1. DÉFINITION DES OBJECTIFS
    int getTarget(String freq) {
      switch (freq) {
        case 'journalier': return 7;
        case 'hebdomadaire': return 4;
        case 'mensuel': return 3;
        case 'unique': return 1;
        default: return 1;
      }
    }

    // 2. FILTRAGE
    final filteredList = widget.challenges.where((action) {
      final currentProgress = _progressMap[action.id] ?? 0;
      final target = getTarget(action.frequency);
      final isCompleted = currentProgress >= target;

      if (selectedFilter == 'lifestyle') {
        return isCompleted;
      }
      return action.frequency == selectedFilter && !isCompleted;
    }).toList();

    // Calculs Barre Globale
    int totalActions = filteredList.length;
    int actionsDoneToday = filteredList.where((a) => _justValidatedIds.contains(a.id)).length;
    double globalProgress = (selectedFilter == 'lifestyle')
        ? 1.0
        : (totalActions == 0 ? 0 : actionsDoneToday / totalActions);

    return Column(
      children: [
        // BARRE GLOBALE
        Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedFilter == 'lifestyle' ? "Mes habitudes acquises 🌿" : "Ma progression (${_getFilterTitle(selectedFilter)})",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.lightTextPrimary),
                  ),
                  Icon(selectedFilter == 'lifestyle' ? Icons.favorite : Icons.emoji_events, color: selectedFilter == 'lifestyle' ? Colors.redAccent : Colors.orange[300]),
                ],
              ),
              const SizedBox(height: 10),
              if (selectedFilter != 'lifestyle')
                Text("$actionsDoneToday/$totalActions actions avancées aujourd'hui", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: globalProgress,
                  backgroundColor: Colors.grey[100],
                  color: selectedFilter == 'lifestyle' ? AppColors.lightPrimary : Colors.orange,
                  minHeight: 8,
                ),
              ),
            ],
          ),
        ),

        // FILTRES
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              _buildTabFilter("Quotidien", "journalier"),
              const SizedBox(width: 10),
              _buildTabFilter("Hebdo", "hebdomadaire"),
              const SizedBox(width: 10),
              _buildTabFilter("Mensuel", "mensuel"),
              const SizedBox(width: 10),
              _buildTabFilter("Unique", "unique"),
              const SizedBox(width: 10),
              _buildTabFilter("Mode de vie 🏆", "lifestyle", isSpecial: true),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // LISTE
        Expanded(
          child: filteredList.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              final action = filteredList[index];
              final current = _progressMap[action.id] ?? 0;
              final target = getTarget(action.frequency);
              final isJustValidated = _justValidatedIds.contains(action.id);
              final isLifestyle = selectedFilter == 'lifestyle';

              return Column(
                children: [
                  ChallengeCard(
                    action: action,
                    isCompleted: isLifestyle || isJustValidated,

                    // 👇 MODIFICATION ICI : Validation directe sans photo
                    onValidate: () {
                      if (isLifestyle) return;

                      setState(() {
                        // 1. Visuel
                        _justValidatedIds.add(action.id);

                        // 2. Progression
                        int newVal = current + 1;
                        if (newVal > target) newVal = target;
                        _progressMap[action.id] = newVal;

                        // 3. Trophée ?
                        if (newVal == target) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("🎉 INCROYABLE ! Cette action est devenue un Mode de Vie !"),
                                backgroundColor: Colors.purple,
                              )
                          );
                        }
                      });

                      // 4. Appel Simple (Juste l'ID)
                      widget.onValidate(action.id);
                    },

                    onDelete: () => _confirmDelete(context, action.id),
                  ),

                  if (!isLifestyle)
                    Padding(
                      padding: const EdgeInsets.only(left: 60, right: 10, bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Progression : $current / $target ${_getUnit(action.frequency)}", style: TextStyle(fontSize: 11, color: AppColors.lightPrimary, fontWeight: FontWeight.bold)),
                              Text("${(current/target*100).toInt()}%", style: const TextStyle(fontSize: 10, color: Colors.grey)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: current / target,
                              backgroundColor: Colors.grey[200],
                              color: AppColors.lightPrimary.withOpacity(0.6),
                              minHeight: 4,
                            ),
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

  // ... (Garde les widgets helpers _buildTabFilter, _buildEmptyState, _confirmDelete, _getFilterTitle, _getUnit comme avant)
  Widget _buildTabFilter(String label, String value, {bool isSpecial = false}) {
    final isSelected = selectedFilter == value;
    final activeColor = isSpecial ? Colors.purple : const Color(0xFF76B82A);
    final inactiveBorder = isSpecial ? Colors.purple.withOpacity(0.3) : Colors.grey.shade300;
    final textColor = isSpecial && !isSelected ? Colors.purple : (isSelected ? Colors.white : Colors.grey);

    return GestureDetector(
      onTap: () => setState(() => selectedFilter = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: isSelected ? Colors.transparent : inactiveBorder),
          boxShadow: isSelected ? [BoxShadow(color: activeColor.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))] : null,
        ),
        child: Text(label, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 13)),
      ),
    );
  }

  Widget _buildEmptyState() {
    // ... (Garde ton code existant ici)
    bool isLifestyle = selectedFilter == 'lifestyle';
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
              isLifestyle ? LucideIcons.trophy : Icons.inventory_2_outlined,
              size: 60,
              color: Colors.grey[300]
          ),
          const SizedBox(height: 15),
          Text(
            isLifestyle
                ? "Pas encore de trophées."
                : "Aucun défi ${_getFilterTitle(selectedFilter).toLowerCase()}",
            style: TextStyle(color: Colors.grey[500], fontSize: 16),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, String actionId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Arrêter ce défi ?"),
        content: const Text("Tu pourras le reprendre plus tard."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
          TextButton(onPressed: () { Navigator.pop(context); widget.onDelete(actionId); }, child: const Text("Arrêter", style: TextStyle(color: Colors.red))),
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