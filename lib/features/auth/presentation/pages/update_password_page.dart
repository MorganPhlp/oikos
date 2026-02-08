import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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

  bool _isObscured1 = true;
  bool _isObscured2 = true;

  late final StreamSubscription<AuthState> _authSubscription;

  @override
  void initState() {
    super.initState();
    _checkInitialSession();

    _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((
      data,
    ) {
      if (data.session != null && mounted) {
        setState(() {
          _isSessionValid = true;
          _isCheckingSession = false;
        });
      }
    });

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
      setState(
        () => _message = "Erreur : Impossible de modifier le mot de passe.",
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // Le scaffold prend la couleur de fond par défaut du thème
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 450),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            margin: const EdgeInsets.all(20), // Marge pour petits écrans
            decoration: BoxDecoration(
              // Couleur de la "carte" : Surface (Blanc en Light, Gris sombre en Dark)
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              // Ombre légère, surtout utile en mode Light
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
              // Bordure subtile en mode Dark pour détacher la carte du fond
              border: Theme.of(context).brightness == Brightness.dark
                  ? Border.all(
                      color: colorScheme.outline.withValues(alpha: 0.2),
                    )
                  : null,
            ),
            child: _buildContent(context),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // 1. CAS : SUCCÈS
    if (_isSuccess) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check, color: colorScheme.primary, size: 40),
          ),
          const SizedBox(height: 24),
          Text(
            "C'est tout bon !",
            style: AppTypography.h2.copyWith(color: colorScheme.primary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            _message!,
            textAlign: TextAlign.center,
            style: AppTypography.body.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 30),
          Text(
            "Vous pouvez fermer cette page et retourner sur l'application.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      );
    }

    // 2. CAS : CHARGEMENT INITIAL
    if (_isCheckingSession && !_isSessionValid) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: colorScheme.primary),
          const SizedBox(height: 24),
          Text(
            "Vérification du lien...",
            style: AppTypography.body.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      );
    }

    // 3. CAS : LIEN INVALIDE
    if (!_isSessionValid) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.link_off, color: colorScheme.error, size: 50),
          const SizedBox(height: 20),
          Text(
            "Lien expiré",
            style: AppTypography.h2.copyWith(color: colorScheme.error),
          ),
          const SizedBox(height: 12),
          Text(
            "Ce lien de réinitialisation n'est plus valide ou a déjà été utilisé.",
            textAlign: TextAlign.center,
            style: AppTypography.body.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton(
            onPressed: () {
              // Action
            },
            child: const Text("Refaire une demande sur l'app"),
          ),
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
              // Fallback texte si l'image foire
              errorBuilder: (c, o, s) => Text(
                "Oîkos",
                style: AppTypography.h1.copyWith(color: colorScheme.primary),
              ),
            ),
          ),
          const SizedBox(height: 40),

          Text(
            "Nouveau mot de passe",
            style: AppTypography.h2.copyWith(
              fontSize: 24,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "Choisissez un mot de passe sécurisé pour protéger votre compte.",
            style: AppTypography.body.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),

          // Champ 1
          Text(
            "Mot de passe",
            style: AppTypography.body.copyWith(color: colorScheme.onSurface),
          ),
          const SizedBox(height: 8),
          AuthField(
            controller: _passwordController,
            hintText: "6 caractères minimum",
            prefixIcon: Icons.lock_outline,
            isPassword: true,
            isObscured: _isObscured1,
            onToggleVisibility: () {
              setState(() {
                _isObscured1 = !_isObscured1;
              });
            },
            validator: (val) {
              if (val == null || val.length < 6){
                return "Le mot de passe est trop court";
              }
              return null;
            },
          ),

          const SizedBox(height: 20),

          // Champ 2
          Text(
            "Confirmer le mot de passe",
            style: AppTypography.body.copyWith(color: colorScheme.onSurface),
          ),
          const SizedBox(height: 8),
          AuthField(
            controller: _confirmPasswordController,
            hintText: "Répétez le mot de passe",
            prefixIcon: Icons.lock_outline,
            isPassword: true,
            isObscured: _isObscured2,
            onToggleVisibility: () {
              setState(() {
                _isObscured2 = !_isObscured2;
              });
            },
            validator: (val) {
              if (val != _passwordController.text){
                return "Les mots de passe ne correspondent pas";
              }
              return null;
            },
          ),

          const SizedBox(height: 30),

          if (_message != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: colorScheme.onErrorContainer,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _message!,
                      style: TextStyle(color: colorScheme.onErrorContainer),
                    ),
                  ),
                ],
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
