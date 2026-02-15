import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/features/streak/presentation/bloc/streak_bloc.dart';
import 'package:oikos/features/streak/presentation/bloc/streak_state.dart';

class StreakStatisticsWidget extends StatefulWidget {
  final void Function()? onFinished;
  const StreakStatisticsWidget({super.key, this.onFinished});

  @override
  State<StreakStatisticsWidget> createState() => _StreakStatisticsWidgetState();
}

class _StreakStatisticsWidgetState extends State<StreakStatisticsWidget> {
  Timer? _timer;
  late Duration _timeLeft;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  void _updateTime() {
    final streak = context.read<StreakBloc>().state.streak;
    final saisonFin = streak.saisonFin;

    if (saisonFin != null) {
      final now = DateTime.now();
      final diff = saisonFin.difference(now);
      if (mounted) {
        setState(() {
          if (diff.isNegative) {
            _timeLeft = Duration.zero;
            _timer?.cancel();
            widget.onFinished?.call();
          } else {
            _timeLeft = diff;
          }
        });
      }
    } else {
      _timeLeft = Duration.zero;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  List<Map<String, String>> _getTimeUnits() {
    final int totalDays = _timeLeft.inDays;

    return [
      {'value': '$totalDays', 'label': 'JOURS'},
      {'value': _pad(_timeLeft.inHours.remainder(24)), 'label': 'HEURES'},
      {'value': _pad(_timeLeft.inMinutes.remainder(60)), 'label': 'MIN'},
      {'value': _pad(_timeLeft.inSeconds.remainder(60)), 'label': 'SEC'},
    ];
  }

  String _pad(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final units = _getTimeUnits();

    return BlocBuilder<StreakBloc, StreakState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.colorScheme.surface.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: units
                    .map(
                      (u) => _TimeUnit(
                        value: u['value']!,
                        label: u['label']!,
                        theme: theme,
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 12),
              Center(
                child: Chip(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  backgroundColor: theme.colorScheme.primary.withValues(
                    alpha: 0.30,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Colors.transparent),
                  ),
                  label: Text(
                    "Avant prochaine saison",
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TimeUnit extends StatelessWidget {
  final String value;
  final String label;
  final ThemeData theme;

  const _TimeUnit({
    required this.value,
    required this.label,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.1,
          ),
        ),
      ],
    );
  }
}
