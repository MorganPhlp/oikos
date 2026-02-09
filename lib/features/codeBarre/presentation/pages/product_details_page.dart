import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oikos/core/common/presentation/widgets/gradient_button.dart';
import 'package:oikos/features/codeBarre/domain/entities/aliment_entity.dart';
import 'package:oikos/features/codeBarre/presentation/widgets/eco_score_legend_dialog.dart';

class ProductDetailsPage extends StatelessWidget {
  final AlimentEntity aliment;

  const ProductDetailsPage({super.key, required this.aliment});

  @override
  Widget build(BuildContext context) {
    final ecoScore = aliment.ecoScore?.toUpperCase() ?? '?';
    final nutriScore = aliment.nutriScore?.toUpperCase() ?? '?';

    // On vérifie si le score est connu (ni '?' ni 'UNKNOWN')
    final bool isEcoScoreKnown = ecoScore != '?' && ecoScore != 'UNKNOWN';
    // On vérifie si le score est connu (ni '?' ni 'UNKNOWN')
    final bool isNutriScoreKnown = nutriScore != '?' && nutriScore != 'UNKNOWN';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          "Résultat du scan",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // --- 1. IMAGE ---
                    Center(
                      child: Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: aliment.imageUrl != null
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            aliment.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                                Icons.fastfood,
                                size: 50,
                                color: Colors.grey),
                          ),
                        )
                            : const Icon(Icons.image_not_supported,
                            size: 50, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // --- 2. TITRE ---
                    Text(
                      aliment.nom,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    if (aliment.marque != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        aliment.marque!,
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 32),

                    // --- 3. ECO-SCORE (STACK) ---
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: _getScoreColor(ecoScore).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color:
                                _getScoreColor(ecoScore).withOpacity(0.3)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.eco,
                                  size: 40, color: _getScoreColor(ecoScore)),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Eco-Score",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54)),
                                  Text(
                                    isEcoScoreKnown ? "Classe $ecoScore" : "Inconnu",//Permet d'afficher "Inconnu" au lieu de UNKNOWN
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w900,
                                      color: _getScoreColor(ecoScore),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Bouton info
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: Icon(Icons.info_outline,
                                color: _getScoreColor(ecoScore).withOpacity(0.8)),
                            onPressed: () => showDialog(
                              context: context,
                              // 👇 On utilise le nouveau widget ici
                              builder: (ctx) => const EcoScoreLegendDialog(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // --- 4. NUTRI-SCORE ---
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Nutri-Score",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getScoreColor(nutriScore),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isNutriScoreKnown ? "Classe $nutriScore" : "Inconnu",//Permet d'afficher "Inconnu" au lieu de UNKNOWN,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Plus de détails sur l'impact environnemental bientôt disponibles.",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            // --- 5. BOUTON ---
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: GradientButton(
                label: 'Lancer un nouveau scan',
                onPressed: () {
                  context.pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(String score) {
    switch (score) {
      case 'A': return const Color(0xFF1E8F4E);
      case 'B': return const Color(0xFF2E7D32);
      case 'C': return const Color(0xFFE6C700);
      case 'D': return Colors.orange;
      case 'E': return Colors.red;
      default: return Colors.grey;
    }
  }
}