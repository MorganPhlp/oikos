import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oikos/core/common/presentation/widgets/gradient_button.dart';
import 'package:oikos/features/codeBarre/domain/entities/aliment_entity.dart';
import 'package:oikos/features/codeBarre/presentation/cubit/alternative_product_cubit.dart';
import 'package:oikos/features/codeBarre/presentation/cubit/alternative_product_state.dart';
import 'package:oikos/features/codeBarre/presentation/widgets/eco_score_legend_dialog.dart';
import 'package:oikos/init_dependencies.dart'; // Pour serviceLocator

class ProductDetailsPage extends StatelessWidget {
  final AlimentEntity aliment;

  const ProductDetailsPage({super.key, required this.aliment});

  @override
  Widget build(BuildContext context) {
    // Récupération des scores (ou '?' si inconnu)
    final ecoScore = aliment.ecoScore?.toUpperCase() ?? '?';
    final nutriScore = aliment.nutriScore?.toUpperCase() ?? '?';
    final bool isEcoScoreKnown = ecoScore != '?' && ecoScore != 'UNKNOWN' && ecoScore != 'NOT-APPLICABLE';

    // 1. On enveloppe la page dans le BlocProvider pour activer la logique
    return BlocProvider(
      create: (_) => serviceLocator<AlternativeProductCubit>()..loadAlternative(aliment),
      child: Scaffold(
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
                      // --- 1. IMAGE DU PRODUIT ---
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

                      // --- 2. TITRE ET MARQUE ---
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

                      // --- 3. GRANDE CARTE ECO-SCORE ---
                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: _getScoreColor(ecoScore).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: _getScoreColor(ecoScore).withOpacity(0.3)),
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
                                            fontSize: 14, color: Colors.black54)),
                                    Text(
                                      isEcoScoreKnown ? "Classe $ecoScore" : "Inconnu",
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
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              icon: Icon(Icons.info_outline,
                                  color: _getScoreColor(ecoScore).withOpacity(0.8)),
                              onPressed: () => showDialog(
                                context: context,
                                builder: (ctx) => const EcoScoreLegendDialog(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // --- 4. PETITE CARTE NUTRI-SCORE ---
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
                                nutriScore != '?' && nutriScore != 'UNKNOWN'
                                    ? nutriScore
                                    : '?',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // --- 5. ZONE ALTERNATIVE ---
                      BlocBuilder<AlternativeProductCubit, AlternativeProductState>(
                        builder: (context, state) {
                          if (state is AlternativeProductLoading) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(strokeWidth: 2),// peut etre  a retirer
                              ),
                            );
                          }

                          if (state is AlternativeProductSuccess) {
                            return _buildAlternativeCard(context, state.alternative);
                          }

                          // Si pas d'alternative ou erreur, on ne montre rien (c'est plus propre)
                          return const SizedBox.shrink();
                        },
                      ),

                      const SizedBox(height: 24),
                      const Text(
                        "Données issues d'Open Food Facts.",
                        style: TextStyle(
                            color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              // --- 6. BOUTON BAS DE PAGE ---
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: GradientButton(
                  label: 'Lance un nouveau scan',
                  onPressed: () {
                    context.pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET POUR L'ALTERNATIVE ---
  Widget _buildAlternativeCard(BuildContext context, AlimentEntity alternative) {
    final altEcoScore = aliment.ecoScore?.toUpperCase() ?? '?';
    final bool isAltEcoScoreKnown = altEcoScore != '?' && altEcoScore != 'UNKNOWN' && altEcoScore != 'NOT-APPLICABLE';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50, // Fond vert très clair pour attirer l'oeil
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.eco, color: Colors.green.shade700, size: 20),
              const SizedBox(width: 8),
              Text(
                "Alternative plus écologique",
                style: TextStyle(
                  color: Colors.green.shade800,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () {
              // Navigation récursive : on ouvre la même page mais avec le nouveau produit !
              context.push('/product_details', extra: alternative);
            },
            child: Row(
              children: [
                // Image miniature
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    height: 60,
                    width: 60,
                    color: Colors.white,
                    child: alternative.imageUrl != null
                        ? Image.network(alternative.imageUrl!, fit: BoxFit.cover)
                        : const Icon(Icons.image, color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 12),
                // Textes
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alternative.nom,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                      if (alternative.marque != null)
                        Text(
                          alternative.marque!,
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                        ),
                    ],
                  ),
                ),
                // Badge Eco-Score
                Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _getScoreColor(altEcoScore),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    isAltEcoScoreKnown ? "Classe $altEcoScore" : "Inconnu",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper Couleurs
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