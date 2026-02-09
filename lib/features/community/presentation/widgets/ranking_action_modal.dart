import 'package:flutter/material.dart';

class RankingActionModal extends StatelessWidget {
  final String name;          // Ex: "Lucas Bernard" ou "Viveris Lyon"
  final String avatarUrl;     // Chemin de l'asset ou URL
  final bool isCommunity;     // true = Communauté, false = Utilisateur
  final VoidCallback onSeeProfile; // Action quand on clique sur "Voir le profil"
  final VoidCallback onDuel;       // Action quand on clique sur "Lancer un duel"

  const RankingActionModal({
    Key? key,
    required this.name,
    required this.avatarUrl,
    required this.isCommunity,
    required this.onSeeProfile,
    required this.onDuel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Couleurs basées sur tes screens (à adapter si tu as un fichier de thème global)
    final Color primaryGreen = const Color(0xFF7CB342); // Vert bouton duel
    final Color lightGreenBg = const Color(0xFFF1F8E9); // Vert très clair bouton profil
    final Color textDark = const Color(0xFF2E3A26);     // Texte foncé

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24), // Arrondi prononcé comme sur le screen
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min, // La modale s'adapte à la taille du contenu
          children: [
            // --- 1. AVATAR ---
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // Le fond vert derrière la tête
                color: isCommunity ? Colors.green.shade200 : const Color(0xFFAED581),
              ),
              child: CircleAvatar(
                radius: 32,
                backgroundColor: Colors.transparent,
                // On gère ici si c'est une image locale (Asset) ou réseau (Network)
                // Pour l'instant je mets Asset, change par NetworkImage si besoin
                backgroundImage: AssetImage(avatarUrl), 
              ),
            ),
            const SizedBox(height: 12),

            // --- 2. NOM & TYPE ---
            Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isCommunity ? Icons.groups_outlined : Icons.person_outline,
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  isCommunity ? "Communauté" : "Utilisateur",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // --- 3. BOUTON VOIR PROFIL (Vert Clair) ---
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: onSeeProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: lightGreenBg,
                  foregroundColor: textDark, // Couleur du texte/icone
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Voir le profil",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // --- 4. BOUTON DUEL (Vert Foncé) ---
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: onDuel,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.flash_on, size: 20), // Assure-toi d'avoir une icône d'épée ou utilise Icons.flash_on
                    SizedBox(width: 8),
                    Text(
                      "Lancer un duel",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- 5. BOUTON ANNULER ---
            InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Annuler",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}