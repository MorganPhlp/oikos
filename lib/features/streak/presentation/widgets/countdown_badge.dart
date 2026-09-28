import 'dart:async';
import 'package:flutter/material.dart';

class CountdownBadge extends StatefulWidget {
  final DateTime? targetDate; // Rendu nullable pour gérer l'infini
  final String prefix;
  final TextStyle style;
  final Widget icon;
  final Color backgroundColor;
  final Color borderColor;
  final VoidCallback? onFinished;

  const CountdownBadge({
    super.key,
    this.targetDate,
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
      _startTimer(); // On relance le timer si la date change
    }
  }

  void _startTimer() {
    _timer?.cancel();
    // On ne lance le timer que si on a une date cible
    if (widget.targetDate != null) {
      _timer = Timer.periodic(
        const Duration(seconds: 1),
        (_) => _calculateDuration(),
      );
    }
  }

  void _calculateDuration() {
    if (widget.targetDate == null) {
      if (mounted) setState(() => _duration = Duration.zero);
      return;
    }

    final now = DateTime.now();
    final diff = widget.targetDate!.difference(now);

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
    // CAS INFINI : Si pas de date cible
    if (widget.targetDate == null) return "∞";

    if (_duration.inSeconds <= 0) return "Terminé";

    final days = _duration.inDays;
    final hours = _duration.inHours.remainder(24);
    final minutes = _duration.inMinutes.remainder(60);
    final seconds = _duration.inSeconds.remainder(60);

    List<String> parts = [];

    if (days > 0) {
      parts.add("${days}j");
      if (hours > 0) parts.add("${hours}h");
    } else if (hours > 0) {
      parts.add("${hours}h");
      if (minutes > 0) parts.add("${minutes}min");
    } else {
      if (minutes > 0) parts.add("${minutes}min");
      parts.add("${seconds}s");
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
        borderRadius: BorderRadius.circular(12),
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
