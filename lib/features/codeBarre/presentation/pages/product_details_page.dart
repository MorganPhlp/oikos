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
    final theme = Theme.of(context);//theme global de l'appli
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // Récupération des scores (ou '?' si inconnu)
    final ecoScore = aliment.ecoScore?.toUpperCase() ?? '?';
    final nutriScore = aliment.nutriScore?.toUpperCase() ?? '?';
    final bool isEcoScoreKnown = ecoScore != '?' && ecoScore != 'UNKNOWN' && ecoScore != 'NOT-APPLICABLE';

    return BlocProvider(
      create: (_) => serviceLocator<AlternativeProductCubit>()..loadAlternative(aliment),
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
            onPressed: () => context.pop(),
          ),
          title: Text(
            "Résultat du scan",
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
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
                      // --- IMAGE DU PRODUIT ---
                      Center(
                        child: Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest,
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
                              errorBuilder: (_, __, ___) => Icon(
                                  Icons.fastfood,
                                  size: 50,
                                  color: colorScheme.onSurfaceVariant),
                            ),
                          )
                              : Icon(Icons.image_not_supported,
                              size: 50, color: colorScheme.onSurfaceVariant),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // --- TITRE ET MARQUE ---
                      Text(
                        aliment.nom,
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (aliment.marque != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          aliment.marque!,
                          style: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      const SizedBox(height: 32),

                      // --- GRANDE CARTE ECO-SCORE ---
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
                                    Text("Eco-Score",
                                        style: textTheme.bodyMedium?.copyWith(
                                            color: colorScheme.onSurface.withOpacity(0.7))),
                                    Text(
                                      isEcoScoreKnown ? "Classe $ecoScore" : "Inconnu",
                                      style: textTheme.headlineMedium?.copyWith(
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

                      // --- PETITE CARTE NUTRI-SCORE ---
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Nutri-Score",
                                style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.onSurface)),
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

                      // --- ZONE DE SUGGESTION D'ALIMENT MEILLEUR ---
                      BlocBuilder<AlternativeProductCubit, AlternativeProductState>(
                        builder: (context, state) {
                          if (state is AlternativeProductLoading) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: colorScheme.primary,
                                ),
                              ),
                            );
                          }

                          if (state is AlternativeProductSuccess) {
                            return _buildAlternativeCard(context, state.alternative);
                          }

                          // Si pas d'alternative ou erreur, on ne montre rien
                          return const SizedBox.shrink();
                        },
                      ),

                      const SizedBox(height: 24),
                      Text(
                        "Données issues d'Open Food Facts.",
                        style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.outline, // Gris subtil
                            fontStyle: FontStyle.italic),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              // --- BOUTON BAS DE PAGE POUR RELANCER LE SCAN ---
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: GradientButton(
                  label: 'Lance un nouveau scan',
                  onPressed: () {
                    //On retourne a la page de scan
                    context.push('/scan/camera');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET POUR LA SUGGESTION ---
  Widget _buildAlternativeCard(BuildContext context, AlimentEntity alternative) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final cardBgColor = isDark ? Colors.green.shade900.withOpacity(0.3) : Colors.green.shade50;
    final cardBorderColor = isDark ? Colors.green.shade700 : Colors.green.shade200;
    final iconColor = isDark ? Colors.green.shade300 : Colors.green.shade700;
    final titleColor = isDark ? Colors.green.shade200 : Colors.green.shade800;

    final altEcoScore = alternative.ecoScore?.toUpperCase() ?? '?';
    final bool isAltEcoScoreKnown = ['A', 'B', 'C', 'D', 'E'].contains(altEcoScore);



    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBgColor, // Fond vert très clair pour attirer l'oeil
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.eco, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Text(
                "Alternative plus écologique",
                style: TextStyle(
                  color: titleColor,
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
              context.push('/scan/details', extra: alternative);
            },
            child: Row(
              children: [
                // Image miniature
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    height: 60,
                    width: 60,
                    color: colorScheme.surface,
                    child: alternative.imageUrl != null
                        ? Image.network(
                      alternative.imageUrl!,
                      fit: BoxFit.cover,
                      // AJOUT DE LA SÉCURITÉ pour l'affichage
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.image_not_supported, color: colorScheme.onSurfaceVariant);
                      },
                    )
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
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      if (alternative.marque != null)
                        Text(
                          alternative.marque!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
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
                    isAltEcoScoreKnown ? altEcoScore : "?",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.arrow_forward_ios, size: 16, color: colorScheme.onSurfaceVariant),
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