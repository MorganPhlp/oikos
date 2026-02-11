import 'package:flutter/material.dart';

// Widget pour le modal d'action sur le classement
class RankingActionModal extends StatelessWidget {
  final String name;
  final String avatarUrl;
  final bool isCommunity;     // true = Communauté, false = Utilisateur
  final VoidCallback onSeeProfile; // Action quand on clique sur "Voir le profil"
  final VoidCallback onDuel;       // Action quand on clique sur "Lancer un défi"

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
    // Couleurs
    final Color primaryGreen = const Color(0xFF7CB342); // Bouton défi
    final Color lightGreenBg = const Color(0xFFF1F8E9); // Bouton profil
    final Color textDark = const Color(0xFF2E3A26);     // Texte foncé

    ImageProvider? imageProvider;
    
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      if (avatarUrl!.startsWith('http') || avatarUrl!.startsWith('https')) {
        // URL Internet (Supabase)
        imageProvider = NetworkImage(avatarUrl!);
      } else {
        // Fichier Local (Asset)
        String cleanPath = avatarUrl!.replaceAll('file:///', '').replaceAll('C:/src/projet/oikos/', '');
        imageProvider = AssetImage(cleanPath);
      }
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCommunity ? Colors.green.shade200 : const Color(0xFFAED581),
              ),
              child: CircleAvatar(
                radius: 32,
                backgroundColor: Colors.white,
                backgroundImage: imageProvider, 
                // Si pas d'image, on affiche l'initiale
                child: imageProvider == null
                    ? Text(
                        name.isNotEmpty ? name[0].toUpperCase() : "?",
                        style: TextStyle(
                          fontSize: 24, 
                          fontWeight: FontWeight.bold, 
                          color: textDark
                        ),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 12),

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

            // Bouton "Voir le profil"
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: onSeeProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: lightGreenBg,
                  foregroundColor: textDark,
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

            // Bouton "Lancer un défi"
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
                    Icon(Icons.flash_on, size: 20),
                    SizedBox(width: 8),
                    Text(
                      "Lancer un défi",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Bouton "Annuler"
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