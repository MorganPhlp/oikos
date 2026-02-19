import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:oikos/core/common/presentation/cubits/app_user/app_user_cubit.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 20);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 20),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.8),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          BlocBuilder<AppUserCubit, AppUserState>(
            builder: (context, state) {
              String? avatarPath;
              if (state is AppUserLoggedIn) {
                avatarPath = state.user.avatar;
              }

              avatarPath ??= 'assets/avatars/avatar_1.png'; // Avatar par défaut

              return _CircleAvatarButton(
                avatarPath: avatarPath,
                onTap: () => context.pushNamed('profile'),
              );
            },
          ),
          const Spacer(),
          Image.asset(
            "assets/logos/oikos_logo.png",
            height: 32,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 12),
          Container(
            width: 1,
            height: 24,
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
          const SizedBox(width: 12),
          Icon(LucideIcons.leaf, color: colorScheme.primary),
          const Spacer(),
          const _ScoreBadge(
            score: "1250",
          ), // TODO: Récupérer le score réel de l'utilisateur
          const SizedBox(width: 8),
          const _CircleIconButton(
            icon: LucideIcons.bell,
            hasNotification: true,
          ),
        ],
      ),
    );
  }
}

class _CircleAvatarButton extends StatelessWidget {
  final String avatarPath;
  final VoidCallback onTap;

  const _CircleAvatarButton({required this.avatarPath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: colorScheme.surface.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
          child: ClipOval(
            child: Image.asset(
              avatarPath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Icon(
                LucideIcons.user,
                size: 20,
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final bool hasNotification;
  final VoidCallback? onTap;

  const _CircleIconButton({
    required this.icon,
    this.hasNotification = false,
    this.onTap, // TODO: Passer en required une fois que les boutons font quelque chose
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colorScheme.surface.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(icon, size: 20, color: colorScheme.onSurface),
            ),
          ),
        ),
        if (hasNotification)
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: colorScheme.error,
                shape: BoxShape.circle,
                border: Border.all(color: colorScheme.surface, width: 2),
              ),
              child: Center(
                child: Text(
                  "3",
                  style: TextStyle(
                    color: colorScheme.onError,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ScoreBadge extends StatelessWidget {
  final String score;
  const _ScoreBadge({required this.score});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.zap, size: 16, color: colorScheme.primary),
          const SizedBox(width: 6),
          Text(
            score,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
