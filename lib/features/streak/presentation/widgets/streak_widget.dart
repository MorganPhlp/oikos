import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:oikos/init_dependencies.dart';
import 'package:oikos/core/common/presentation/cubits/app_user/app_user_cubit.dart';
import 'package:oikos/features/streak/presentation/bloc/streak_bloc.dart';
import 'package:oikos/features/streak/presentation/bloc/streak_event.dart';
import 'package:oikos/features/streak/presentation/bloc/streak_state.dart';

class StreakWidget extends StatelessWidget {
  const StreakWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userState = context.read<AppUserCubit>().state;
    String userId = "";
    if (userState is AppUserLoggedIn) {
      userId = userState.user.id;
    }

    return BlocProvider(
      create: (context) =>
          serviceLocator.get<StreakBloc>()..add(WatchStreakEvent(userId)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(18),
        ),
        child: BlocBuilder<StreakBloc, StreakState>(
          builder: (context, state) {
            final logoUrl = state.streak.logoUrl;
            final bool hasLogo = logoUrl != null && logoUrl.isNotEmpty;
            print(
              'endDate: ${state.streak.saisonFin}',
            ); // Debug : Affiche la date de fin de saison dans la console
            return Column(
              children: [
                if (hasLogo)
                  Image.network(
                    logoUrl,
                    height: 140,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox.shrink(),
                  )
                else
                  const SizedBox(height: 140),
                const SizedBox(height: 16),

                // Badge Saison
                _CountdownBadge(
                  targetDate: state.streak.saisonFin ?? DateTime(2025, 12, 31),
                  prefix: "avant fin de saison",
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  icon: const Text("⏳", style: TextStyle(fontSize: 16)),
                  backgroundColor: theme.primaryColor.withValues(alpha: 0.1),
                  borderColor: theme.primaryColor.withValues(alpha: 0.3),
                  // TODO : quand timer finit appel au bloc verifier et update UI
                  onFinished: () {},
                ),

                const SizedBox(height: 6),
                const _DecorativeSeparator(), // Constante : Rebuild = 0
                const SizedBox(height: 6),

                // Badge Streak
                _CountdownBadge(
                  targetDate: state.streak.lastUpdated.add(
                    const Duration(days: 14),
                  ),
                  prefix: "",
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  icon: Icon(
                    LucideIcons.clock,
                    size: 16,
                    color: theme.colorScheme.tertiary,
                  ),
                  backgroundColor: theme.colorScheme.tertiary.withValues(
                    alpha: 0.05,
                  ),
                  borderColor: theme.colorScheme.tertiary.withValues(
                    alpha: 0.2,
                  ),
                  // TODO : quand timer finit appel au bloc verifier et update UI
                  onFinished: () {},
                ),

                const SizedBox(height: 12),
                const Text(
                  "pour réaliser ton action quotidienne et collective",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.black45),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _DecorativeSeparator extends StatelessWidget {
  const _DecorativeSeparator();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;

    return Container(
      constraints: const BoxConstraints(maxWidth: 200),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                gradient: LinearGradient(
                  colors: [Colors.transparent, color.withValues(alpha: 0.3)],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Le petit point central
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                gradient: LinearGradient(
                  colors: [color.withValues(alpha: 0.3), Colors.transparent],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CountdownBadge extends StatefulWidget {
  final DateTime targetDate;
  final String prefix;
  final TextStyle style;
  final Widget icon;
  final Color backgroundColor;
  final Color borderColor;
  final VoidCallback? onFinished;

  const _CountdownBadge({
    required this.targetDate,
    required this.prefix,
    required this.style,
    required this.icon,
    this.backgroundColor = Colors.transparent,
    this.borderColor = Colors.transparent,
    this.onFinished,
  });

  @override
  State<_CountdownBadge> createState() => _CountdownBadgeState();
}

class _CountdownBadgeState extends State<_CountdownBadge> {
  late Timer _timer;
  late Duration _duration;

  @override
  void initState() {
    super.initState();
    _calculateDuration();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _calculateDuration(),
    );
  }

  @override
  void didUpdateWidget(_CountdownBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si la date cible a changé entre deux builds du parent
    if (oldWidget.targetDate != widget.targetDate) {
      _calculateDuration();
    }
  }

  void _calculateDuration() {
    final now = DateTime.now();
    final diff = widget.targetDate.difference(now);

    if (diff.inSeconds <= 0) {
      // On vérifie si le timer a été initialisé avant d'accéder à .isActive
      // Dans initState, au premier appel, il ne l'est pas encore.
      widget.onFinished?.call();
    }

    if (mounted) {
      setState(() {
        _duration = diff.inSeconds > 0 ? diff : Duration.zero;
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatTime() {
    if (_duration.inSeconds <= 0) return "Terminé";
    if (_duration.inDays > 0) return "J-${_duration.inDays} ${widget.prefix}";
    if (_duration.inHours > 0) return "Il te reste ${_duration.inHours}h";
    if (_duration.inMinutes > 0) return "Il te reste ${_duration.inMinutes}min";
    return "Il te reste ${_duration.inSeconds}s";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: widget.borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.icon,
          const SizedBox(width: 8),
          Text(_formatTime(), style: widget.style),
        ],
      ),
    );
  }
}
