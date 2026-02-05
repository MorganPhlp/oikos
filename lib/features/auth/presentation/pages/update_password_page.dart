import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:oikos/core/theme/app_colors.dart';
import 'package:oikos/core/theme/app_typography.dart';
import 'package:oikos/features/auth/presentation/widgets/auth_field.dart';
import 'package:oikos/features/auth/presentation/widgets/auth_primary_button.dart';

class UpdatePasswordPage extends StatefulWidget {
  const UpdatePasswordPage({super.key});

  @override
  State<UpdatePasswordPage> createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _isSessionValid = false;
  bool _isCheckingSession = true;
  String? _message;
  bool _isSuccess = false;

  // Gestion de la visibilité des mots de passe (caché par défaut)
  bool _isObscured1 = true;
  bool _isObscured2 = true;

  late final StreamSubscription<AuthState> _authSubscription;

  @override
  void initState() {
    super.initState();
    _checkInitialSession();

    // Écoute des changements (pour le lien magique)
    _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (data.session != null && mounted) {
        setState(() {
          _isSessionValid = true;
          _isCheckingSession = false;
        });
      }
    });

    // Timeout de sécurité (5s)
    Timer(const Duration(seconds: 5), () {
      if (mounted && _isCheckingSession) {
        setState(() => _isCheckingSession = false);
      }
    });
  }

  void _checkInitialSession() {
    final initialSession = Supabase.instance.client.auth.currentSession;
    if (initialSession != null) {
      _isSessionValid = true;
      _isCheckingSession = false;
    }
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _updatePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: _passwordController.text.trim()),
      );

      setState(() {
        _isSuccess = true;
        _message = "Votre mot de passe a été mis à jour avec succès !";
      });
    } catch (e) {
      setState(() => _message = "Erreur : Impossible de modifier le mot de passe.");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 450),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              // Petite ombre légère pour le style carte
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: _buildContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    // 1. CAS : SUCCÈS
    if (_isSuccess) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.lightPrimary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: AppColors.lightPrimary, size: 40),
          ),
          const SizedBox(height: 24),
          Text(
            "C'est tout bon !",
            style: AppTypography.h2.copyWith(color: AppColors.lightPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            _message!,
            textAlign: TextAlign.center,
            style: AppTypography.body.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 30),
          const Text(
            "Vous pouvez fermer cette page et retourner sur l'application.",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      );
    }

    // 2. CAS : CHARGEMENT INITIAL
    if (_isCheckingSession && !_isSessionValid) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: AppColors.lightPrimary),
          const SizedBox(height: 24),
          Text(
            "Vérification du lien...",
            style: AppTypography.body.copyWith(color: Colors.grey),
          ),
        ],
      );
    }

    // 3. CAS : LIEN INVALIDE
    if (!_isSessionValid) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.link_off, color: Colors.redAccent, size: 50),
          const SizedBox(height: 20),
          Text(
            "Lien expiré",
            style: AppTypography.h2.copyWith(color: Colors.redAccent),
          ),
          const SizedBox(height: 12),
          Text(
            "Ce lien de réinitialisation n'est plus valide ou a déjà été utilisé.",
            textAlign: TextAlign.center,
            style: AppTypography.body.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 20),
          OutlinedButton(
            onPressed: () {
              // Redirection optionnelle vers la racine ou intro
              // context.go('/');
            },
            child: const Text("Refaire une demande sur l'app"),
          )
        ],
      );
    }

    // 4. CAS : FORMULAIRE
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Image.asset(
              'assets/logos/oikos_logo.png',
              height: 50,
              errorBuilder: (c, o, s) => Text("Oîkos", style: AppTypography.h1.copyWith(color: AppColors.lightPrimary)),
            ),
          ),
          const SizedBox(height: 40),

          Text(
            "Nouveau mot de passe",
            style: AppTypography.h2.copyWith(fontSize: 24),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "Choisissez un mot de passe sécurisé pour protéger votre compte.",
            style: AppTypography.body.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),

          // Champ 1 : Mot de passe
          Text("Mot de passe", style: AppTypography.body),
          const SizedBox(height: 8),
          AuthField(
            controller: _passwordController,
            hintText: "6 caractères minimum",
            prefixIcon: Icons.lock_outline,
            // Configuration identique à SignInPage
            isPassword: true,
            isObscured: _isObscured1,
            onToggleVisibility: () {
              setState(() {
                _isObscured1 = !_isObscured1;
              });
            },
            validator: (val) {
              if (val == null || val.length < 6) return "Le mot de passe est trop court";
              return null;
            },
          ),

          const SizedBox(height: 20),

          // Champ 2 : Confirmation
          Text("Confirmer le mot de passe", style: AppTypography.body),
          const SizedBox(height: 8),
          AuthField(
            controller: _confirmPasswordController,
            hintText: "Répétez le mot de passe",
            prefixIcon: Icons.lock_outline,
            // Configuration identique à SignInPage
            isPassword: true,
            isObscured: _isObscured2,
            onToggleVisibility: () {
              setState(() {
                _isObscured2 = !_isObscured2;
              });
            },
            validator: (val) {
              if (val != _passwordController.text) return "Les mots de passe ne correspondent pas";
              return null;
            },
          ),

          const SizedBox(height: 30),

          if (_message != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Text(
                _message!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
          ],

          AuthPrimaryButton(
            text: "Modifier mon mot de passe",
            onPressed: _updatePassword,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }
}