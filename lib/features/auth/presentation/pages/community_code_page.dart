import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart'; // N'oublie pas le package !
import 'package:oikos/core/theme/app_colors.dart';
import 'package:oikos/core/theme/app_typography.dart';
import '../widgets/confirm_community_modal.dart';


// Mock Data
// TODO : Remplacer par un appel API réel
const Map<String, Map<String, String>> communityCodes = {
  'PAR123': {'name': 'Paris La Défense', 'icon': '🗼'},
  'LYO456': {'name': 'Lyon Part-Dieu', 'icon': '🦁'},
  // ... autres codes
};


class CommunityCodePage extends StatefulWidget {
  static MaterialPageRoute<dynamic> route({required String email, required String password, required String pseudo}) => MaterialPageRoute(
    builder: (context) => CommunityCodePage(
        email: email,
        password: password,
        pseudo: pseudo,
    ),
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

  // Logique pour extraire le nom de l'entreprise de l'email
  String get _companyName {
    final parts = widget.email.split('@');
    if (parts.length > 1) {
      final domain = parts[1].split('.')[0];
      // Met la première lettre en majuscule
      return domain[0].toUpperCase() + domain.substring(1);
    }
    return "Entreprise";
  }

  void _validateCode(String code) {
    setState(() => _errorText = null);

    final upperCode = code.toUpperCase();
    final community = communityCodes[upperCode];

    if (community != null) {
      // Code valide -> Ouvrir Modal
      showDialog(
        context: context,
        builder: (context) => ConfirmCommunityModal(
          communityName: community['name']!,
          communityIcon: community['icon']!,
          onConfirm: () {
            // TODO: Logique finale (ex: enregistrer user et aller à l'accueil)
            Navigator.pop(context); // Ferme la modale
          },
          onCancel: () {
            Navigator.pop(context); // Ferme la modale
            _pinController.clear(); // Reset le champ
          },
        ),
      );
    } else {
      setState(() => _errorText = "Code invalide. Vérifiez auprès de votre administrateur.");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Style par défaut des cases du PIN
    final defaultPinTheme = PinTheme(
      width: 45,
      height: 55,
      textStyle: const TextStyle(fontSize: 20, color: AppColors.lightTextPrimary, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.lightInputBorderFocused.withValues(alpha: 0.3), width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.lightInputBorderFocused, width: 2),
    );

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Logo
              Image.asset('assets/logos/oikos_logo.png', height: 60),
              const SizedBox(height: 20),

              // Carte Entreprise (Facultatif, selon la maquette)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.gradientGreenStart.withValues(alpha: 0.3),
                      AppColors.gradientGreenEnd.withValues(alpha: 0.3)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Entreprise détectée", style: TextStyle(color: AppColors.lightTextPrimary.withValues(alpha: 0.6), fontSize: 12)),
                        Text(_companyName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    )
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Icône Sparkles Centrée et après logo entreprise
              Container(
                width: 80, height: 80,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.gradientGreenStart, AppColors.gradientGreenEnd],
                  ),
                  boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12, offset: Offset(0, 4))],
                ),
                child: const Icon(Icons.auto_awesome, size: 40, color: AppColors.lightTextPrimary), // TODO : Remplacer par logo de l'entreprise
              ),

              const SizedBox(height: 24),

              Text("Rejoignez votre communauté", style: AppTypography.h2, textAlign: TextAlign.center),
              const SizedBox(height: 10),
              Text(
                "Saisissez le code fourni par votre administrateur pour rejoindre votre équipe",
                textAlign: TextAlign.center,
                style: AppTypography.body.copyWith(color: AppColors.lightTextPrimary.withValues(alpha: 0.7)),
              ),

              const SizedBox(height: 30),

              Text("Code communauté", style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.lightTextPrimary)),
              const SizedBox(height: 12),

              // INPUT PIN
              Pinput(
                controller: _pinController,
                length: 6,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                textCapitalization: TextCapitalization.characters,
                onCompleted: _validateCode,
                onChanged: (_) => setState(() => _errorText = null),
              ),

              if (_errorText != null) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    border: Border.all(color: Colors.red.shade200),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red.shade500, size: 20),
                      const SizedBox(width: 8),
                      Expanded(child: Text(_errorText!, style: TextStyle(color: Colors.red.shade700))),
                    ],
                  ),
                )
              ],

              const SizedBox(height: 30),

              // Info Card Bas de page
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.gradientGreenStart.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppColors.lightIconPrimary),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        "Vous n'avez pas de code ? Contactez l'administrateur de votre entreprise.",
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}