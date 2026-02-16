import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:oikos/core/theme/app_typography.dart';
import 'package:oikos/features/auth/presentation/widgets/auth_primary_button.dart';

class UserStatusModal extends StatefulWidget {
  final bool currentStatus;
  final ValueChanged<bool> onStatusChanged;

  const UserStatusModal({
    super.key,
    required this.currentStatus,
    required this.onStatusChanged,
  });

  @override
  State<UserStatusModal> createState() => _UserStatusModalState();
}

class _UserStatusModalState extends State<UserStatusModal> {
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _isActive = widget.currentStatus;
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
            'Mon statut',
            style: AppTypography.h2.copyWith(
              color: colorScheme.primary,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 24),

          // Option ACTIF
          _buildStatusOption(
            title: 'Actif',
            description: 'Je participe aux défis et mes points comptent pour mon équipe.',
            icon: LucideIcons.zap,
            isSelected: _isActive,
            activeColor: const Color(0xFF4CAF50), // Vert succès
            onTap: () => setState(() => _isActive = true),
            colorScheme: colorScheme,
          ),

          const SizedBox(height: 16),

          // Option ABSENT
          _buildStatusOption(
            title: 'Absent / En pause',
            description: 'Je ne participe pas pour le moment. Mon absence ne pénalisera pas mon équipe.',
            icon: LucideIcons.pauseCircle,
            isSelected: !_isActive,
            activeColor: const Color(0xFFE8B44A), // Jaune/Orange pause
            onTap: () => setState(() => _isActive = false),
            colorScheme: colorScheme,
          ),

          const SizedBox(height: 32),

          AuthPrimaryButton(
            text: 'Enregistrer',
            onPressed: () {
              widget.onStatusChanged(_isActive);
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildStatusOption({
    required String title,
    required String description,
    required IconData icon,
    required bool isSelected,
    required Color activeColor,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? activeColor : colorScheme.outline.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? activeColor : colorScheme.surface.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : colorScheme.onSurface.withValues(alpha: 0.5),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTypography.body.copyWith(
                      fontSize: 12,
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Icon(LucideIcons.check, color: activeColor),
              ),
          ],
        ),
      ),
    );
  }
}