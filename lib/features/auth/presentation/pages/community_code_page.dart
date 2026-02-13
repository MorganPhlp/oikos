import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/core/common/presentation/widgets/loader.dart';
import 'package:oikos/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:oikos/core/theme/app_colors.dart'; // Juste pour les gradients constants
import 'package:oikos/core/theme/app_typography.dart';
import '../widgets/confirm_community_modal.dart';

class CommunityCodePage extends StatefulWidget {
  static MaterialPageRoute<dynamic> route({
    required String email,
    required String password,
    required String pseudo,
  }) => MaterialPageRoute(
    builder: (context) =>
        CommunityCodePage(email: email, password: password, pseudo: pseudo),
  );

  final String email;
  final String password;
  final String pseudo;

  const CommunityCodePage({
    super.key,
    required this.email,
    required this.password,
    required this.pseudo,
  });

  @override
  State<CommunityCodePage> createState() => _CommunityCodePageState();
}

class _CommunityCodePageState extends State<CommunityCodePage> {
  final _pinController = TextEditingController();
  String? _errorText;

  String? _companyName;
  String? _companyLogoUrl;

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthLoadCompanyInfo(email: widget.email));
  }

  void _validateCode(String code) {
    setState(() => _errorText = null);
    final upperCode = code.toUpperCase();
    context.read<AuthBloc>().add(AuthVerifyCommunity(communityCode: upperCode));
  }

  @override
  Widget build(BuildContext context) {
    // Récupération du thème actuel
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Style PIN Adaptatif
    final defaultPinTheme = PinTheme(
      width: 45,
      height: 55,
      textStyle: TextStyle(
        fontSize: 20,
        // Couleur du texte dans les cases (Blanc en Dark, Noir en Light)
        color: colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        // Couleur de fond des cases (récupérée du inputDecorationTheme défini dans AppTheme)
        color: theme.inputDecorationTheme.fillColor,
        border: Border.all(
          // Bordure subtile
          color:
              theme.inputDecorationTheme.enabledBorder?.borderSide.color ??
              colorScheme.outline.withValues(alpha: 0.3),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(
        color: colorScheme.primary,
        width: 2,
      ), // Bordure verte au focus
    );

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          setState(() => _errorText = state.message);
        }

        if (state is AuthCompanyInfoLoaded) {
          setState(() {
            _companyName = state.companyName;
            _companyLogoUrl = state.logoUrl;
          });
        }

        if (state is AuthCommunityVerified) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) => ConfirmCommunityModal(
              communityName: state.communityName,
              communityIcon: _companyLogoUrl ?? '',
              onConfirm: () {
                Navigator.popUntil(dialogContext, (route) => route.isFirst);
                context.read<AuthBloc>().add(
                  AuthSignUp(
                    email: widget.email,
                    password: widget.password,
                    pseudo: widget.pseudo,
                    communityCode: _pinController.text.toUpperCase(),
                  ),
                );
              },
              onCancel: () {
                Navigator.pop(dialogContext);
                _pinController.clear();
              },
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          // Utilise le fond par défaut du thème (darkBackground ou lightBackground)
          body: Stack(
            children: [
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Logo
                      Image.asset('assets/logos/oikos_logo.png', height: 60),
                      const SizedBox(height: 20),

                      // Carte Entreprise
                      if (_companyName != null)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.gradientGreenStart.withValues(
                                  alpha: 0.2,
                                ), // Transparence pour blending
                                AppColors.gradientGreenEnd.withValues(
                                  alpha: 0.2,
                                ),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: colorScheme.primary.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Entreprise détectée",
                                    style: TextStyle(
                                      color: colorScheme.onSurface.withValues(
                                        alpha: 0.6,
                                      ),
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    _companyName!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 40),

                      // Icône centrale
                      Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.gradientGreenStart,
                              AppColors.gradientGreenEnd,
                            ],
                          ),
                          // Ombre plus discrète en dark mode (optionnel)
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10,
                              color: Colors.black26,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: _companyLogoUrl != null
                            ? ClipOval(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Image.network(
                                    _companyLogoUrl!,
                                    fit: BoxFit.contain,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                              Icons.business,
                                              color: Colors.white,
                                              size: 40,
                                            ),
                                  ),
                                ),
                              )
                            : const Icon(
                                Icons.auto_awesome,
                                color: Colors.white,
                                size: 40,
                              ),
                      ),

                      const SizedBox(height: 24),

                      Text(
                        "Rejoignez votre communauté",
                        style: AppTypography.h2.copyWith(
                          color: colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Saisissez le code fourni par votre administrateur pour rejoindre votre équipe",
                        textAlign: TextAlign.center,
                        style: AppTypography.body.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),

                      const SizedBox(height: 30),

                      Text(
                        "Code communauté",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // INPUT PIN
                      Pinput(
                        controller: _pinController,
                        length: 6,
                        defaultPinTheme: defaultPinTheme,
                        focusedPinTheme: focusedPinTheme,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.characters,
                        onCompleted: _validateCode,
                        onChanged: (_) {
                          if (_errorText != null) {
                            setState(() => _errorText = null);
                          }
                        },
                      ),

                      // Zone d'erreur adaptative
                      if (_errorText != null) ...[
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            // Utilise errorContainer pour un fond rouge adapté (clair ou sombre)
                            color: colorScheme.errorContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                // Texte sur le container d'erreur
                                color: colorScheme.onErrorContainer,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _errorText!,
                                  style: TextStyle(
                                    color: colorScheme.onErrorContainer,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 30),

                      // Info Card Bas de page
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          // Fond subtil basé sur la couleur primaire
                          color: colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "Vous n'avez pas de code ? Contactez l'administrateur de votre entreprise.",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: colorScheme.onSurface.withValues(
                                    alpha: 0.8,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (state is AuthLoading) const Loader(),
            ],
          ),
        );
      },
    );
  }
}
