import 'package:flutter/material.dart';
import 'package:oikos/core/theme/app_typography.dart';
import 'package:oikos/features/auth/presentation/widgets/auth_primary_button.dart';

class AvatarModal extends StatefulWidget {
  final String currentAvatar;
  final ValueChanged<String> onAvatarSelected;

  const AvatarModal({
    super.key,
    required this.currentAvatar,
    required this.onAvatarSelected,
  });

  @override
  State<AvatarModal> createState() => _AvatarModalState();
}

class _AvatarModalState extends State<AvatarModal> {
  late String _selectedAvatar;

  // Liste des avatars disponibles
  final List<String> _avatarsAssets = [
    'assets/avatars/avatar_1.png',
    'assets/avatars/avatar_2.png',
    'assets/avatars/avatar_3.png',
    'assets/avatars/avatar_4.png',
    'assets/avatars/avatar_5.png',
    'assets/avatars/avatar_6.png',
    'assets/avatars/avatar_7.png',
    'assets/avatars/avatar_8.png',
    'assets/avatars/avatar_9.png',
    'assets/avatars/avatar_10.png',
    'assets/avatars/avatar_11.png',
    'assets/avatars/avatar_12.png',
    'assets/avatars/avatar_13.png',
    'assets/avatars/avatar_14.png',
    'assets/avatars/avatar_15.png',
    'assets/avatars/avatar_16.png',
  ];

  @override
  void initState() {
    super.initState();
    _selectedAvatar = widget.currentAvatar;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Indicateur de drag
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Text(
            'Choisis ton avatar',
            style: AppTypography.h2.copyWith(
              color: colorScheme.primary,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 24),

          // Grille d'avatars
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            itemCount: _avatarsAssets.length,
            itemBuilder: (context, index) {
              final assetPath = _avatarsAssets[index];
              final isSelected = assetPath == _selectedAvatar;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedAvatar = assetPath;
                  });
                },
                child: Container(
                  // Le container extérieur gère la bordure et l'ombre
                  // Il s'adapte automatiquement à la taille de la case de la grille
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.outline.withValues(alpha: 0.2),
                      width: isSelected ? 3 : 1.5,
                    ),
                    boxShadow: [
                      if (isSelected)
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4), // Espace entre bordure et image
                    child: Container(
                      // Le container intérieur affiche l'image en couvrant tout l'espace
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(assetPath),
                          fit: BoxFit.cover, // C'est ceci qui assure que l'image remplit le rond
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          // Bouton Valider
          AuthPrimaryButton(
            text: 'Valider',
            onPressed: () {
              widget.onAvatarSelected(_selectedAvatar);
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}