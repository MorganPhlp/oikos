import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/theme/app_typography.dart';
import 'package:oikos/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:oikos/features/auth/presentation/widgets/auth_secondary_button.dart';
import 'package:oikos/features/auth/utils/auth_validators.dart';

import '../widgets/auth_field.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/forgot_password_modal.dart';

class SignInPage extends StatefulWidget {
  static MaterialPageRoute<dynamic> route() =>
      MaterialPageRoute(builder: (context) => const SignInPage());

  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  // Variable pour stocker l'erreur renvoyée par le backend (ex: "Identifiants incorrects")
  String? _backendError;

  @override
  void initState(){
    super.initState();
    // Réinitialiser les champs et l'état
    context.read<AuthBloc>().add(AuthResetState());

    // On écoute les changements pour effacer l'erreur dès que l'utilisateur tape quelque chose
    _emailController.addListener(_clearBackendError);
    _passwordController.addListener(_clearBackendError);
  }

  void _clearBackendError() {
    if (_backendError != null) {
      setState(() {
        _backendError = null;
      });
    }
  }

  void _submit() {
    // On efface l'erreur précédente avant de soumettre
    setState(() => _backendError = null);

    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthSignIn(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: colorScheme.onSurface,
            size: 32,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              Navigator.popUntil(context, (route) => route.isFirst);
            } else if (state is AuthFailure) {
              // 1. On capture l'erreur du backend
              setState(() {
                _backendError = "Email ou mot de passe incorrect"; // Ou utilisez state.message si vous préférez
              });
              // 2. On force la validation pour afficher l'erreur sous le champ
              _formKey.currentState?.validate();
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                // Comme sur votre page d'inscription, on valide à l'interaction
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo Oîkos
                    Center(
                      child: Image.asset(
                        'assets/logos/oikos_logo.png',
                        height: 60,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Titre
                    Center(
                      child: Text(
                        'Content de te revoir !',
                        style: AppTypography.h2.copyWith(color: colorScheme.onSurface),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Sous-titre
                    Center(
                      child: Text(
                        'Entre ton email pro pour retrouver tes collègues.',
                        style: AppTypography.body.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Email Label
                    Text(
                      'Email professionnel',
                      style: AppTypography.body.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Center(
                      child: AuthField(
                        hintText: 'prenom.nom@entreprise.fr',
                        controller: _emailController,
                        prefixIcon: Icons.mail_outlined,
                        validator: (value) {
                          // Validation standard de l'email
                          return AuthValidators.validateEmail(value);
                        },
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Mot de Passe Label
                    Text(
                      'Mot de passe',
                      style: AppTypography.body.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.left,
                    ),

                    const SizedBox(height: 8),

                    Center(
                      child: AuthField(
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
                        // C'est ici qu'on injecte l'erreur backend
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Mot de passe requis';
                          }
                          // Si le backend a renvoyé une erreur, on l'affiche ici
                          if (_backendError != null) {
                            return _backendError;
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 60),

                    AuthPrimaryButton(
                      text: "Se connecter",
                      onPressed: _submit,
                      isLoading: state is AuthLoading,
                    ),

                    AuthSecondaryButton(
                      text: "Mot de passe oublié ?",
                      onPressed: _showForgotPasswordModal,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}