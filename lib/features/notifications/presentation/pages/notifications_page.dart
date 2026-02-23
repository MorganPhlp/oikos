import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: const Center(child: Text('Aucune notification pour le moment.')),
    );
  }
}
