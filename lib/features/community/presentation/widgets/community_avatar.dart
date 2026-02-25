import 'package:flutter/material.dart';
import 'package:oikos/core/theme/app_colors.dart';

class CommunityAvatar extends StatelessWidget {
  final String url;
  final String name;
  final Color color;

  const CommunityAvatar({
    super.key,
    required this.url,
    required this.name,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    print("Building CommunityAvatar for $name with URL: $url");
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.lightMuted,
        border: Border.all(color: theme.colorScheme.surface, width: 3),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: ClipOval(
        child: Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: color.withValues(alpha: 0.1),
            alignment: Alignment.center,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : "?",
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
