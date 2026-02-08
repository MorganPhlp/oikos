import 'package:flutter/material.dart';
import 'package:oikos/core/theme/app_typography.dart';
import 'package:oikos/features/auth/presentation/pages/signin_page.dart';
import 'package:oikos/features/auth/presentation/pages/signup_page.dart';
import 'package:oikos/features/auth/presentation/widgets/auth_primary_button.dart';
import 'package:oikos/features/auth/presentation/widgets/auth_secondary_button.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // On récupère les couleurs du thème actuel
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // Pas de backgroundColor fixé ici, le Scaffold prendra celui du thème (Light/Dark)
      body: SafeArea(
        child: Stack(
          children: [
            // 1. Logo Viveris en haut à droite
            Positioned(
              top: 20,
              right: 20,
              child: Image(
                image: const AssetImage('assets/logos/viveris_logo.png'),
                height: 28,
                fit: BoxFit.contain,
                // Optionnel : Si le logo est noir, on peut l'inverser en blanc pour le mode sombre
                // color: Theme.of(context).brightness == Brightness.dark ? Colors.white : null,
              ),
            ),

            // 2. Contenu Principal
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20 + 49),

                    // Logo Oîkos
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 368),
                      child: Image(
                        image: const AssetImage('assets/logos/oikos_logo.png'),
                        width: screenWidth * 0.8,
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: 25),

                    Text(
                      "Prendre soin de notre maison, \nla Terre.",
                      textAlign: TextAlign.center,
                      style: AppTypography.body.copyWith(
                        // Le texte s'adapte : Noir en Light, Blanc en Dark
                        color: colorScheme.onSurface,
                        height: 1.625,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 3. Les boutons en bas
            Positioned(
              bottom: 30,
              left: 10,
              right: 10,
              child: Column(
                children: [
                  AuthPrimaryButton(
                    text: "Commencer l'aventure",
                    onPressed: () {
                      Navigator.push(context, SignUpPage.route());
                    },
                  ),

                  AuthSecondaryButton(
                    text: "Me reconnecter",
                    onPressed: () {
                      Navigator.push(context, SignInPage.route());
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
