import 'package:flutter/material.dart';
import 'package:oikos/features/actions/domain/entities/action_entity.dart';

extension ActionIcon on ActionEntity {
  IconData get icon {
    final name = iconName;
    const iconMap = <String, IconData>{
      'directions_walk': Icons.directions_walk,
      'pedal_bike': Icons.pedal_bike,
      'electric_bike': Icons.electric_bike,
      'videocam': Icons.videocam,
      'water': Icons.water_drop,
      'spa': Icons.spa,
      'sentiment_very_satisfied': Icons.sentiment_very_satisfied,
      'delete_sweep': Icons.delete_sweep,
      'power_settings_new': Icons.power_settings_new,
      'local_bar': Icons.local_bar,
      'shower': Icons.shower,
      'cloud': Icons.cloud,
      'checkroom': Icons.checkroom,
      'wb_sunny': Icons.wb_sunny,
      'router': Icons.router,
      'receipt_long': Icons.receipt_long,
      'shopping_basket': Icons.shopping_basket,
      'savings': Icons.savings,
      'markunread_mailbox': Icons.markunread_mailbox,
    };
    return iconMap[name] ?? Icons.eco;
  }
}
