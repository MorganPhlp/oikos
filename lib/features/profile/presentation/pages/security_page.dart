import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:oikos/core/common/presentation/cubits/app_user/app_user_cubit.dart';
import 'package:oikos/core/theme/app_typography.dart';
import 'package:oikos/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:oikos/features/auth/presentation/widgets/auth_field.dart';
import 'package:oikos/features/auth/presentation/widgets/auth_primary_button.dart';
import 'package:oikos/features/auth/utils/auth_validators.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  // Contrôleurs pour l'email
  final _emailFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  // Contrôleurs pour le mot de passe
  final _passwordFormKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    // Pré-remplir l'email actuel si possible
    final state = context.read<AppUserCubit>().state;
    if (state is AppUserLoggedIn) {
      _emailController.text = state.user.email;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _updateEmail() {
    if (_emailFormKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthUpdateCredentials(email: _emailController.text.trim()),
      );
    }
  }

  void _updatePassword() {
    if (_passwordFormKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthUpdateCredentials(password: _newPasswordController.text.trim()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: colorScheme.error,
            ),
          );
        } else if (state is AuthCredentialsUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: const Color(0xFF4CAF50), // Vert succès
            ),
          );
          // Si on a mis à jour le mot de passe, on vide les champs
          _newPasswordController.clear();
          _confirmPasswordController.clear();
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(LucideIcons.chevronLeft, color: colorScheme.onSurface),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Email & Sécurité',
            style: AppTypography.h2.copyWith(color: colorScheme.onSurface, fontSize: 20),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- SECTION EMAIL ---
              Text(
                'Modifier mon adresse email',
                style: AppTypography.h2.copyWith(color: colorScheme.primary),
              ),
              const SizedBox(height: 8),
              Text(
                'Si tu modifies ton email, tu devras confirmer la nouvelle adresse.',
                style: AppTypography.body.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Form(
                  key: _emailFormKey,
                  child: Column(
                    children: [
                      AuthField(
                        hintText: 'Nouvel email pro',
                        controller: _emailController,
                        prefixIcon: LucideIcons.mail,
                        validator: AuthValidators.validateEmail,
                      ),
                      const SizedBox(height: 16),
                      AuthPrimaryButton(
                        text: 'Mettre à jour mon email',
                        onPressed: _updateEmail,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // --- SECTION MOT DE PASSE ---
              Text(
                'Modifier mon mot de passe',
                style: AppTypography.h2.copyWith(color: colorScheme.primary),
              ),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Form(
                  key: _passwordFormKey,
                  child: Column(
                    children: [
                      AuthField(
                        hintText: 'Nouveau mot de passe',
                        controller: _newPasswordController,
                        prefixIcon: LucideIcons.lock,
                        isPassword: true,
                        isObscured: !_isPasswordVisible,
                        onToggleVisibility: () {
                          setState(() => _isPasswordVisible = !_isPasswordVisible);
                        },
                        validator: AuthValidators.passwordErrorText,
                      ),
                      const SizedBox(height: 16),
                      AuthField(
                        hintText: 'Confirmer le mot de passe',
                        controller: _confirmPasswordController,
                        prefixIcon: LucideIcons.lock,
                        isPassword: true,
                        isObscured: !_isConfirmPasswordVisible,
                        onToggleVisibility: () {
                          setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible);
                        },
                        validator: (value) {
                          if (value != _newPasswordController.text) {
                            return 'Les mots de passe ne correspondent pas';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      AuthPrimaryButton(
                        text: 'Mettre à jour mon mot de passe',
                        onPressed: _updatePassword,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}