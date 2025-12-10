import 'package:flutter/material.dart';
import 'package:oikos/core/theme/app_colors.dart';
import 'package:oikos/core/theme/app_typography.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width; // Récupère la largeur de l'écran
    final screenHeight = MediaQuery.of(context).size.height; // Récupère la hauteur de l'écran

    return Scaffold(
      //backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Stack(
          children: [
            // 1. Logo Viveris en haut à droite
            Positioned(
              top: 20, // top - 20px
              right: 20, // right - 20px
              child: Image(
                image: AssetImage('lib/core/assets/logos/viveris_logo.png'),
                height: 28,
                fit: BoxFit.contain, // Conserve les proportions de l'image
              ),
            ),

            // 2. Contenu Principal (Flux vertical)
            SizedBox(
              width: double.infinity, // Prend toute la largeur disponible
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20), // Padding horizontal de 20px
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20 + 49), // Espace pour descendre le logo

                    // Logo Oîkos
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 368, // Largeur maximale de 368px
                      ),
                      child: Image(
                        image: AssetImage('lib/core/assets/logos/oikos_logo.png'),
                        width: screenWidth * 0.8, // 80% de la largeur de l'écran
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: 35),

                    Text(
                      "Prendre soin de notre maison, \nla Terre.",
                      textAlign: TextAlign.center,
                      style: AppTypography.body.copyWith(
                        color: AppColors.lightTextPrimary,
                        height: 1.625, // leading-relaxed approx
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
