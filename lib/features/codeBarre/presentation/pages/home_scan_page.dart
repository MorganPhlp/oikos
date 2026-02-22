import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:oikos/core/common/presentation/widgets/gradient_button.dart';
import 'package:oikos/features/codeBarre/domain/entities/aliment_entity.dart';

class HomeScanPage extends StatelessWidget {
  const HomeScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              // Une icône ou une image illustrative
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: Lottie.asset(
                  'assets/animations/scan_animation.json', // l'animation sous format JSON
                  fit: BoxFit.contain,
                  //  pour répéter l'anim
                  repeat: true,
                ),
              ),
              const SizedBox(height: 5),

              const Text(
                'Scanne un aliment',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              const Text(
                'Scanne le code-barres de ton produit pour découvrir son impact carbone et son impact nutritionnel.',
                style: TextStyle(fontSize: 17, color: Colors.grey, height: 1.5),
                textAlign: TextAlign.center,
              ),

              Padding(
                padding: const EdgeInsets.all(7.0),
                child: GradientButton(
                  label: 'Lance le scan',
                  onPressed: () {
                    context.push(
                      '/scan/camera',
                    ); // On navigue vers la page caméra existante
                  },
                ),

              ),
              //POUR TESTER RAPIDEMENT LA PAGE DE DÉTAILS SI ON PEUT PAS UTILISER LA CAMERA
              /*
              ElevatedButton(
                // On le met en rouge pour bien se rappeler de l'enlever avant la mise en production !
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  // Création d'un faux produit (Mock)
                  // Attributs test
                  final mockAliment = AlimentEntity(
                    codeBarre: '1234567890123',
                    nom: 'Produit Test Tablette',
                    marque: 'Viveris Test',
                    ecoScore: 'A',
                    imageUrl: 'https://images.openfoodfacts.org/images/products/301/762/042/2003/front_fr.594.400.jpg',
                    // 'https://images.openfoodfacts.org/images/products/301/762/042/2003/front_fr.594.400.jpg' pour nutella
                  );

                  // Navigation vers la page TEST
                  context.push('/scan/details', extra: mockAliment);
                },
                child: const Text('Mode Debug : Voir un produit'),
              )
              */
            ],
          ),
        ),
      ),
    );
  }
}
