import 'package:flutter/material.dart';
import 'package:oikos/core/theme/app_colors.dart';
import 'package:oikos/core/theme/app_typography.dart';
import 'package:oikos/features/auth/presentation/widgets/auth_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _acceptedCGU = false;
  String? _cguError;

  // TODO : Implémenter la logique de validation et de soumission du formulaire
  /*
    void _submit(){
      setState(() => _cguError = null);

      bool formValid = _formKey.currentState!.validate();

      if(!_acceptedCGU){
        setState(() => _cguError = "Merci d'accepter les CGU pour continuer");
        return;
      }

      if(formValid){
        // TODO : Logique d'inscription
      }
    }
   */

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width; // Récupère la largeur de l'écran
    final screenHeight = MediaQuery.of(context).size.height; // Récupère la hauteur de l'écran

    return Scaffold(
      // AppBar avec bouton de retour
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: AppColors.lightIconPrimary, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      // Corps de la page
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Logo Oîkos
                Image.asset('lib/core/assets/logos/oikos_logo.png', height: 60),
                const SizedBox(height: 20),

                // Titre
                Text(
                  'Bienvenue parmi nous !',
                  style: AppTypography.h2,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 10),

                // Sous-titre
                Text(
                  'Entre ton email pro pour retrouver tes collègues.',
                  style: AppTypography.body.copyWith(
                    color: AppColors.lightTextPrimary.withValues(alpha: 0.7), // Opacité 70%
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                // Formulaire
                AuthField(
                  hintText: 'prenom.nom@entreprise.fr',
                  controller: _emailController,
                  prefixIcon: Icons.mail_outlined
                ),
                const SizedBox(height: 15),
                AuthField(
                  hintText: '••••••••',
                  controller: _passwordController,
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                  isObscured: !_isPasswordVisible,
                  onToggleVisibility: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  }
                ),
                const SizedBox(height: 15),

                // TODO : Continuer
              ]
            ),
          ),
        ),
      ),
    );
  }
}
