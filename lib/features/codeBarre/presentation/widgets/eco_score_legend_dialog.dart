import 'package:flutter/material.dart';

class EcoScoreLegendDialog extends StatelessWidget {
  const EcoScoreLegendDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      // Le titre reste fixe en haut
      title: const Row(
        children: [
          Icon(Icons.eco, color: Colors.green),
          SizedBox(width: 10),
          Text("Comprendre l'Eco-Score", style: TextStyle(fontSize: 18)),
        ],
      ),
      contentPadding: const EdgeInsets.fromLTRB(0, 20, 0, 24), // On gère le padding nous-mêmes
      content: SizedBox(
        width: double.maxFinite, // Force la largeur max pour le menu déroulant
        child: SingleChildScrollView(
          child: Column(
            children: [
              // --- 1. SECTION EXPLICATION GÉNÉRALE ---
              const ExpansionTile(
                leading: Icon(Icons.help_outline, color: Colors.blueGrey),
                title: Text(
                  "Comment ça marche ?",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                childrenPadding: EdgeInsets.all(16),
                children: [
                  Text(
                    "En coulisse, l’Éco-score repose sur un score sur 100 points qui résume l’analyse du cycle de vie (ACV) du produit : matières premières, fabrication, transport, utilisation, déchets.\n\n"
                        "À ce score de base s’ajoutent des bonus/malus pour des éléments comme : agriculture biologique, labels (AB, Label Rouge, Fairtrade…), origine et saisonnalité, type d’emballage, présence d’ingrédients liés à la déforestation ou à la surpêche.\n\n"
                        "Le score final sur 100 est ensuite converti en lettre.",

                    style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.4,),
                  ),
                ],
              ),

              const Divider(height: 1), // Ligne de séparation

              // --- 2. LES LETTRES (A à E) ---
              _buildGradeTile(
                letter: "A",
                color: const Color(0xFF1E8F4E),
                title: "Impact très faible",
                description:
                "Le produit est parmi les meilleurs de sa catégorie : matières premières peu polluantes, modes de production plus durables (souvent bio ou avec labels), peu d’émissions de gaz à effet de serre, emballage limité, bonne fin de vie (recyclable, peu de déchets).",
              ),
              _buildGradeTile(
                letter: "B",
                color: const Color(0xFF2E7D32),
                title: "Impact faible",
                description:
                "Le produit reste globalement bon pour l’environnement, mais avec quelques points moins optimisés que A (plus d’énergie utilisée, un peu plus de transport, moins de labels, emballage un peu plus impactant, etc.).",
              ),
              _buildGradeTile(
                letter: "C",
                color: const Color(0xFFE6C700),
                title: "Impact moyen",
                description:
                "On est dans la « moyenne » de ce qui se fait : ni particulièrement vertueux ni particulièrement mauvais, avec un impact significatif sur le climat, les ressources et la pollution, mais comparable à beaucoup de produits similaires.",
              ),
              _buildGradeTile(
                letter: "D",
                color: Colors.orange,
                title: "Impact élevé",
                description:
                "Le produit génère beaucoup d’émissions, consomme plus de ressources, peut venir de systèmes de production intensifs, être fortement transformé et/ou sur-emballé, avec peu de compensations positives (peu ou pas de labels, transports longs, etc.).",
              ),
              _buildGradeTile(
                letter: "E",
                color: Colors.red,
                title: "Impact très élevé",
                description:
                "Le produit fait partie des plus impactants de sa catégorie : forte contribution au changement climatique, pression importante sur les écosystèmes (déforestation, espèces menacées, etc.), emballage et fin de vie peu favorables. À éviter autant que possible.",
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(foregroundColor: Colors.green),
          child: const Text("OK", style: TextStyle(fontWeight: FontWeight.bold)),
        )
      ],
    );
  }

  // Helper pour créer les menus déroulants des lettres
  Widget _buildGradeTile({
    required String letter,
    required Color color,
    required String title,
    required String description,
  }) {
    return ExpansionTile(
      leading: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          letter,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: color, // On met le titre de la couleur du score
        ),
      ),
      childrenPadding: const EdgeInsets.all(16),
      children: [
        Text(
          description,
          style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.3),
        ),
      ],
    );
  }
}