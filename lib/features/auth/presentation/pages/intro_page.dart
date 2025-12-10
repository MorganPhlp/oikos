import 'package:flutter/material.dart';
import 'package:oikos/core/theme/app_colors.dart';
import 'package:oikos/core/theme/app_typography.dart';
import 'package:oikos/features/auth/presentation/widgets/auth_field.dart';
import 'package:oikos/features/auth/presentation/widgets/auth_primary_button.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width; // Récupère la largeur de l'écran
    final screenHeight = MediaQuery.of(context).size.height; // Récupère la hauteur de l'écran

    return Scaffold(
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

              // 3. Les boutons en bas
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    AuthPrimaryButton(
                      text: "Commencer l'aventure",
                    ),

                    // TODO : Ajouter un bouton secondaire "Me reconnecter" qui redirige vers la page de connexion
                  ],
                ),
              ),
            ],
          ),
      ),
    );
  }
}
