import 'package:flutter/material.dart';

class EcoScoreLegendDialog extends StatelessWidget {
  const EcoScoreLegendDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // Récupération du thème pour l'harmonisation
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return AlertDialog(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: colorScheme.surfaceTint, // Petit effet teinté Material 3

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

      title: Row(
        children: [
          const Icon(Icons.eco, color: Colors.green),
          const SizedBox(width: 10),
          Expanded( // Expanded au cas où le texte est long sur petit écran
            child: Text(
              "Comprendre l'Eco-Score",
              style: textTheme.titleLarge?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface, // Texte qui s'adapte (noir/blanc)
              ),
            ),
          ),
        ],
      ),

      contentPadding: const EdgeInsets.fromLTRB(0, 20, 0, 24),

      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // --- SECTION EXPLICATION GÉNÉRALE ---
              ExpansionTile(
                leading: Icon(Icons.help_outline, color: colorScheme.onSurfaceVariant),

                title: Text(
                  "Comment ça marche ?",
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: colorScheme.onSurface,
                  ),
                ),
                childrenPadding: const EdgeInsets.all(16),
                children: [
                  Text(
                    "En coulisse, l’Éco-score repose sur un score sur 100 points qui résume l’analyse du cycle de vie (ACV) du produit : matières premières, fabrication, transport, utilisation, déchets.\n\n"
                        "À ce score de base s’ajoutent des bonus/malus pour des éléments comme : agriculture biologique, labels (AB, Label Rouge, Fairtrade…), origine et saisonnalité, type d’emballage, présence d’ingrédients liés à la déforestation ou à la surpêche.\n\n"
                        "Le score final sur 100 est ensuite converti en lettre.",
                    style: textTheme.bodyMedium?.copyWith(
                      height: 1.4,
                      color: colorScheme.onSurfaceVariant, // Texte gris lisible
                    ),
                  ),
                ],
              ),

              Divider(height: 1, color: colorScheme.outlineVariant), // Séparateur discret

              // --- LES LETTRES (A à E) ---
              // Note: Les couleurs des scores (Vert, Jaune, Rouge) sont sémantiques
              // et doivent rester fixes, même en mode sombre.
              _buildGradeTile(
                context,
                letter: "A",
                color: const Color(0xFF1E8F4E),
                title: "Impact très faible",
                description: "Le produit est parmi les meilleurs de sa catégorie : matières premières peu polluantes, modes de production plus durables (souvent bio ou avec labels), peu d’émissions de gaz à effet de serre, emballage limité, bonne fin de vie.",
              ),
              _buildGradeTile(
                context,
                letter: "B",
                color: const Color(0xFF2E7D32),
                title: "Impact faible",
                description: "Le produit reste globalement bon pour l’environnement, mais avec quelques points moins optimisés que A (plus d’énergie utilisée, un peu plus de transport, moins de labels, emballage un peu plus impactant, etc.).",
              ),
              _buildGradeTile(
                context,
                letter: "C",
                color: const Color(0xFFE6C700),
                title: "Impact moyen",
                description: "On est dans la « moyenne » de ce qui se fait : ni particulièrement vertueux ni particulièrement mauvais, avec un impact significatif sur le climat, les ressources et la pollution, mais comparable à beaucoup de produits similaires.",
              ),
              _buildGradeTile(
                context,
                letter: "D",
                color: Colors.orange,
                title: "Impact élevé",
                description: "Le produit génère beaucoup d’émissions, consomme plus de ressources, peut venir de systèmes de production intensifs, être fortement transformé et/ou sur-emballé, avec peu de compensations positives.",
              ),
              _buildGradeTile(
                context,
                letter: "E",
                color: Colors.red,
                title: "Impact très élevé",
                description: "Le produit fait partie des plus impactants de sa catégorie : forte contribution au changement climatique, pression importante sur les écosystèmes (déforestation, espèces menacées, etc.), emballage et fin de vie peu favorables.",
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(foregroundColor: colorScheme.primary),
          child: const Text("OK", style: TextStyle(fontWeight: FontWeight.bold)),
        )
      ],
    );
  }

  // Helper mis à jour pour prendre le context
  Widget _buildGradeTile(
      BuildContext context, {
        required String letter,
        required Color color,
        required String title,
        required String description,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
          color: color,
        ),
      ),
      childrenPadding: const EdgeInsets.all(16),
      children: [
        Text(
          description,
          style: theme.textTheme.bodyMedium?.copyWith(
            height: 1.3,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}