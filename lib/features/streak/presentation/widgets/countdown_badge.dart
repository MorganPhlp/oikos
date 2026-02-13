import 'dart:async';

import 'package:flutter/material.dart';

class CountdownBadge extends StatefulWidget {
  final DateTime targetDate;
  final String prefix;
  final TextStyle style;
  final Widget icon;
  final Color backgroundColor;
  final Color borderColor;
  final VoidCallback? onFinished;

  const CountdownBadge({
    required this.targetDate,
    required this.prefix,
    required this.style,
    required this.icon,
    this.backgroundColor = Colors.transparent,
    this.borderColor = Colors.transparent,
    this.onFinished,
  });

  @override
  State<CountdownBadge> createState() => _CountdownBadgeState();
}

class _CountdownBadgeState extends State<CountdownBadge> {
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
  void didUpdateWidget(CountdownBadge oldWidget) {
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