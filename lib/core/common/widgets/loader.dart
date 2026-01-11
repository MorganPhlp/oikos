import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});


  //TODO: Améliorer le loader si besoin
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}