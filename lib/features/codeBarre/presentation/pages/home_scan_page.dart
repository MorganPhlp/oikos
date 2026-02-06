import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:oikos/core/theme/app_colors.dart';

class HomeScanPage extends StatelessWidget {
  const HomeScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 60),
            // Une icône ou une image illustrative
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: Lottie.asset(
                'assets/animations/scan_animation.json', // <--- 2. VOTRE FICHIER JSON
                fit: BoxFit.contain,
                // Optionnel : contrôleurs pour répéter l'anim
                repeat: true,
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Scan un aliment',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            const Text(
              'Scan le code-barre de ton produit pour découvrir son impact carbone et son impact nutritionnel.',
              style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
              textAlign: TextAlign.center,
            ),
            const Spacer(),

            // Le bouton qui ouvre VRAIMENT la caméra
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.push('/scan'); // On navigue vers la page caméra existante
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gradientGreenEnd,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Lance le scan',
                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}