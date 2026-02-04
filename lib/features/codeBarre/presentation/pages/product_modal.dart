import 'package:flutter/material.dart';
import '../../domain/entities/aliment_entity.dart';

/*
* La fiche produit qui s'ouvre quand on trouve un aliment.
*
* */


class ProductModal extends StatelessWidget {
  final AlimentEntity aliment;
  final VoidCallback onAddPressed; // Action quand on clique sur "Ajouter"

  const ProductModal({
    super.key,
    required this.aliment,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Petite barre grise en haut pour le style "BottomSheet"
          Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Image et Nom
          Row(
            children: [
              if (aliment.imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    aliment.imageUrl!,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 60, color: Colors.grey),
                  ),
                ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      aliment.nom,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (aliment.marque != null)
                      Text(aliment.marque!, style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Scores
          _buildScoreRow("Eco-Score", aliment.ecoScore),
          const SizedBox(height: 10),
          _buildScoreRow("Nutri-Score", aliment.nutriScore),

          const Spacer(),

          // Bouton Ajouter
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onAddPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Ajouter cet aliment', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  // --- Helpers privés pour l'affichage des scores ---

  Widget _buildScoreRow(String label, String? score) {
    if (score == null) return const SizedBox.shrink();
    return Row(
      children: [
        Text("$label : ", style: const TextStyle(fontWeight: FontWeight.w600)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: _getScoreColor(score),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(score, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Color _getScoreColor(String score) {
    switch (score.toUpperCase()) {
      case 'A': return Colors.green.shade800;
      case 'B': return Colors.green;
      case 'C': return Colors.yellow.shade800;
      case 'D': return Colors.orange;
      case 'E': return Colors.red;
      default: return Colors.grey;
    }
  }
}