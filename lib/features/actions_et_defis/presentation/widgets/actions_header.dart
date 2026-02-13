import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class ActionsHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final int userPoints;

  const ActionsHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.userPoints = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // 👇 LE DÉGRADÉ VERT ARRONDIE
      padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 25),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.gradientGreenStart, AppColors.gradientGreenEnd],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 1. GAUCHE : PROFIL (Avatar Blanc sur fond vert)
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2), // Cercle translucide
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: AppColors.lightTextPrimary, size: 24),
            ),
          ),

          // 2. CENTRE : TITRES (En blanc)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  subtitle.toUpperCase(),
                  style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70, // Blanc cassé
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w600
                  )
              ),
              Text(
                  title,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white // Blanc pur
                  )
              ),
            ],
          ),

          // 3. DROITE : POINTS + NOTIF
          Row(
            children: [
              // Badge Points (Fond blanc semi-transparent)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.bolt, color: Colors.yellowAccent, size: 18),
                    const SizedBox(width: 4),
                    Text(
                        "$userPoints",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 14
                        )
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Cloche Notif (Bouton blanc translucide)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.notifications_none, color: Colors.white, size: 24),
              ),
            ],
          )
        ],
      ),
    );
  }
}