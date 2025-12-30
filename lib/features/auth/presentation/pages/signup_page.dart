import 'package:flutter/material.dart';
import 'package:oikos/core/theme/app_colors.dart';
import 'package:oikos/core/theme/app_typography.dart';
import 'package:oikos/features/auth/presentation/pages/pseudo_page.dart';
import 'package:oikos/features/auth/presentation/widgets/auth_field.dart';
import 'package:oikos/features/auth/presentation/widgets/auth_primary_button.dart';
import 'package:oikos/features/auth/utils/auth_validators.dart';

class SignUpPage extends StatefulWidget {
  static MaterialPageRoute<dynamic> route() => MaterialPageRoute(
    builder: (context) => const SignUpPage(),
  );

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

  void _submit(){
    setState(() => _cguError = null);

    bool formValid = _formKey.currentState!.validate(); // Déclenche les validateurs des champs

    if(!_acceptedCGU){
      setState(() => _cguError = "Merci d'accepter les CGU pour continuer");
      return;
    }

    if(formValid){
      Navigator.push(context, PseudoPage.route(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      ));
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
                      'Bienvenue parmi nous !',
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
                      prefixIcon: Icons.mail_outlined,
                      validator: AuthValidators.validateProfessionalEmail,
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
                    },
                    validator: AuthValidators.validatePassword,
                  ),
                ),
                const SizedBox(height: 25),

                // CGU Checkbox

                Row(
                  children: [
                    Checkbox(
                      value: _acceptedCGU,
                      activeColor: AppColors.lightIconPrimary,
                      onChanged: (value) {
                        setState(() {
                          _acceptedCGU = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: Wrap(
                        children: [
                          Text(
                            "J'accepte les ",
                            style: AppTypography.body.copyWith(
                              color: AppColors.lightTextPrimary.withValues(alpha: 0.7),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              // TODO : Ouvrir les CGU
                            },
                            child: Text(
                              "CGU",
                              style: AppTypography.body.copyWith(
                                color: AppColors.lightPrimary.withValues(alpha: 0.7),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          Text(
                            " et la ",
                            style: AppTypography.body.copyWith(
                              color: AppColors.lightTextPrimary.withValues(alpha: 0.7),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              // TODO : Ouvrir la politique de confidentialité
                            },
                            child: Text(
                              "politique de confidentialité",
                              style: AppTypography.body.copyWith(
                                color: AppColors.lightPrimary.withValues(alpha: 0.7),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      )
                    ),
                  ],
                ),

                // Erreur CGU
                if (_cguError != null)
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      border: Border.all(color: Colors.red.shade200),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(_cguError!, style: TextStyle(color: Colors.red.shade600)),
                  ),

                const SizedBox(height: 40),
                AuthPrimaryButton(
                  text: "C'est parti !",
                  onPressed: _submit,
                ),
            ],
            ),
          ),
        ),
      ),
    );
  }
}
