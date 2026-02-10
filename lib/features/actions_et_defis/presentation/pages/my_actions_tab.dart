import 'package:flutter/material.dart';
import '../../domain/entities/action_entity.dart';
import '../widgets/challenge_card.dart';

class MyActionsTab extends StatefulWidget {
  final List<ActionEntity> challenges;
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
  // On met 'journalier' par défaut pour correspondre à tes données SQL
  String selectedFilter = 'journalier';

  // Pour l'instant, on stocke les IDs validés en mémoire pour l'effet visuel
  final Set<String> completedActionIds = {};

  @override
  Widget build(BuildContext context) {
    // 1. ON FILTRE LA LISTE SELON L'ONGLET CHOISI
    // On ne garde que les actions dont la fréquence correspond au filtre
    final filteredList = widget.challenges.where((action) {
      return action.frequency == selectedFilter;
    }).toList();

    // Calculs pour la barre de progression (basé sur le filtre actuel)
    int total = filteredList.length;
    int done = filteredList.where((a) => completedActionIds.contains(a.id)).length;
    double progress = total == 0 ? 0 : done / total;

    return Column(
      children: [
        // ---------------------------------------------
        // 1. BARRE DE PROGRESSION (DYNAMIQUE)
        // ---------------------------------------------
        Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      "Ma progression (${_getFilterTitle(selectedFilter)})",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                  ),
                  Icon(Icons.emoji_events, color: Colors.orange[300]),
                ],
              ),
              const SizedBox(height: 10),
              Text("$done/$total actions réalisées", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              const SizedBox(height: 8),

              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[100],
                  color: const Color(0xFF76B82A),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                progress == 1.0 ? "Champion ! Tout est validé 🏆" : "Allez, encore un effort ! 🌱",
                style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey),
              ),
            ],
          ),
        ),

        // ---------------------------------------------
        // 2. FILTRES FRÉQUENCE (SCROLLABLE)
        // ---------------------------------------------
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
            ],
          ),
        ),
        const SizedBox(height: 20),

        // ---------------------------------------------
        // 3. LISTE FILTRÉE
        // ---------------------------------------------
        Expanded(
          child: filteredList.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              final action = filteredList[index];
              final isDone = completedActionIds.contains(action.id);

              return ChallengeCard(
                action: action,
                isCompleted: isDone,
                onValidate: () {
                  setState(() {
                    completedActionIds.add(action.id);
                  });
                  widget.onValidate(action.id);
                },
                // supprimer un defi
                onDelete: () {
                  // Petite alerte de confirmation
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Voulez vous Arrêter ce défi ?"),
                      content: const Text("Tu pourras le reprendre plus tard depuis le catalogue. Tes points passés sont conservés."),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Annuler"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Ferme l'alerte
                            widget.onDelete(action.id); // Supprime
                          },
                          child: const Text("Arrêter", style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTabFilter(String label, String value) {
    final isSelected = selectedFilter == value;
    return GestureDetector(
      onTap: () => setState(() => selectedFilter = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF76B82A) : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: isSelected ? Colors.transparent : Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 50, color: Colors.grey[300]),
          const SizedBox(height: 10),
          Text(
            "Aucun défi ${_getFilterTitle(selectedFilter).toLowerCase()}",
            style: TextStyle(color: Colors.grey[500]),
          ),
          TextButton(
            onPressed: () {
              // Petit hack pour dire à l'utilisateur d'aller chercher des défis
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Va dans l'onglet Catalogue pour en ajouter !"))
              );
            },
            child: const Text("En ajouter depuis le catalogue", style: TextStyle(color: Color(0xFF76B82A))),
          )
        ],
      ),
    );
  }

  String _getFilterTitle(String filter) {
    switch (filter) {
      case 'journalier': return "Quotidien";
      case 'hebdomadaire': return "Hebdo";
      case 'mensuel': return "Mensuel";
      case 'unique': return "Unique";
      default: return "";
    }
  }
}