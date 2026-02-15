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
    super.key,
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
  Timer? _timer;
  late Duration _duration;

  @override
  void initState() {
    super.initState();
    _calculateDuration();
    _startTimer();
  }

  @override
  void didUpdateWidget(CountdownBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.targetDate != widget.targetDate) {
      _calculateDuration();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _calculateDuration(),
    );
  }

  void _calculateDuration() {
    final now = DateTime.now();
    final diff = widget.targetDate.difference(now);

    if (diff.isNegative || diff.inSeconds <= 0) {
      if (_timer?.isActive ?? false) {
        _timer?.cancel();
        widget.onFinished?.call();
      }
      if (mounted) setState(() => _duration = Duration.zero);
      return;
    }

    if (mounted) {
      setState(() => _duration = diff);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime() {
    if (_duration.inSeconds <= 0) return "Terminé";

    final days = _duration.inDays;
    final hours = _duration.inHours.remainder(24);
    final minutes = _duration.inMinutes.remainder(60);

    List<String> parts = [];

    // On construit la chaîne dynamiquement
    if (days > 0) parts.add("${days}j");
    if (hours > 0) parts.add("${hours}h");

    // On affiche les minutes si elles existent OU si on est en dessous de l'heure
    if (minutes > 0 || (days == 0 && hours == 0)) {
      parts.add("${minutes}min");
    }

    final timeString = parts.join(' ');
    return widget.prefix.isEmpty ? timeString : "${widget.prefix} $timeString";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(
          12,
        ), // Un peu plus arrondi pour le style
        border: Border.all(color: widget.borderColor, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.icon,
          const SizedBox(width: 10),
          Text(_formatTime(), style: widget.style),
        ],
      ),
    );
  }
}
