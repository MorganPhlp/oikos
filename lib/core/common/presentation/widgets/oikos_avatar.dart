import 'package:flutter/material.dart';
import 'package:oikos/core/theme/app_colors.dart';

class OikosAvatar extends StatelessWidget {
  final String? avatarUrl;
  final double radius;
  final String? label; // Pour les initiales si l'image charge pas

  const OikosAvatar({
    super.key,
    this.avatarUrl,
    this.radius = 20,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Si l'URL est vide ou nulle, on utilise l'avatar par défaut des assets
    // Assurez-vous que ce fichier existe bien dans votre dossier assets !
    final String validUrl = (avatarUrl == null || avatarUrl!.trim().isEmpty)
        ? 'assets/avatars/avatar_1.png'
        : avatarUrl!;

    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark ? AppColors.darkInput : AppColors.lightInput,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightInputBorder,
          width: 1,
        ),
      ),
      child: ClipOval(
        child: _buildImage(validUrl, theme),
      ),
    );
  }

  Widget _buildImage(String path, ThemeData theme) {
    // 1. Cas Réseau (Supabase, etc.)
    if (path.startsWith('http') || path.startsWith('https')) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildFallback(theme),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      );
    }

    // 2. Cas Asset Local
    return Image.asset(
      path,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        // Si même l'asset échoue (ex: chemin invalide), on affiche le fallback
        return _buildFallback(theme);
      },
    );
  }

  // Fallback : Initiales ou Icône utilisateur
  Widget _buildFallback(ThemeData theme) {
    if (label != null && label!.isNotEmpty) {
      return Center(
        child: Text(
          label![0].toUpperCase(),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.hintColor,
          ),
        ),
      );
    }
    return Center(
      child: Icon(
        Icons.person,
        color: theme.hintColor.withValues(alpha: 0.5),
        size: radius,
      ),
    );
  }
}