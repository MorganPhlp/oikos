import 'package:flutter/material.dart';
import 'package:oikos/core/theme/app_colors.dart';
import 'package:oikos/core/theme/app_typography.dart';
import 'package:oikos/features/auth/presentation/widgets/auth_secondary_button.dart';

import '../widgets/auth_field.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/forgot_password_modal.dart';

class SignInPage extends StatefulWidget {
  static MaterialPageRoute<dynamic> route() => MaterialPageRoute(
    builder: (context) => const SignInPage(),
  );

  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  // TODO : Implémenter la logique de validation et de soumission du formulaire

  void _submit(){
    bool formValid = _formKey.currentState!.validate();

    if(formValid){
      // TODO : Logique de connexion
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showForgotPasswordModal() {
    showDialog(
      context: context,
      builder: (context) => ForgotPasswordModal(email: _emailController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar avec bouton de retour
      appBar: AppBar(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo Oîkos
                Center(
                  child:
                  Image.asset('lib/core/assets/logos/oikos_logo.png', height: 60),
                ),
                const SizedBox(height: 20),

                // Titre
                Center(
                  child:
                  Text(
                    'Content de te revoir !',
                    style: AppTypography.h2,
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 10),

                // Sous-titre
                Center(
                  child:
                  Text(
                      'Entre ton email pro pour retrouver tes collègues.',
                      style: AppTypography.body.copyWith(
                        color: AppColors.lightTextPrimary.withValues(alpha: 0.7), // Opacité 70%
                      ),
                      textAlign: TextAlign.center
                  ),
                ),

                const SizedBox(height: 40),

                // Formulaire
                // Email Champ

                Text(
                  'Email professionnel',
                  style: AppTypography.body.copyWith(
                    color: AppColors.lightTextPrimary.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 8),

                Center(
                  child:
                  AuthField(
                      hintText: 'prenom.nom@entreprise.fr',
                      controller: _emailController,
                      prefixIcon: Icons.mail_outlined
                      // TODO : Ajouter validation email
                  ),
                ),

                const SizedBox(height: 30),

                // Mot de Passe Champ

                Text(
                  'Mot de passe',
                  style: AppTypography.body.copyWith(
                    color: AppColors.lightTextPrimary.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.left,
                ),

                const SizedBox(height: 8),

                Center(
                  child:
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
                    // TODO : Ajouter validation mot de passe
                  ),
                ),

                const SizedBox(height: 60),

                AuthPrimaryButton(
                  text: "Se connecter",
                  onPressed: () {
                    //_submit
                  },
                ),

                AuthSecondaryButton(
                  text: "Mot de passe oublié ?",
                  onPressed: _showForgotPasswordModal,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
