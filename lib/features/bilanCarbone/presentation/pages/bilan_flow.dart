import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/bilan_bloc.dart';
import 'package:oikos/features/bilanCarbone/presentation/pages/bilan_page.dart';
import 'package:oikos/features/bilanCarbone/presentation/pages/choix_categories_page.dart';
import 'package:oikos/features/bilanCarbone/presentation/pages/choix_objectifs.dart';
import 'package:oikos/features/bilanCarbone/presentation/pages/resultats_page.dart';
import 'package:oikos/init_dependencies.dart';

class BilanFlow extends StatefulWidget {
  const BilanFlow({super.key});

  @override
  State<BilanFlow> createState() => _BilanFlowState();
}

class _BilanFlowState extends State<BilanFlow> {
  // 1. On crée une clé pour contrôler le Navigator interne
  final GlobalKey<NavigatorState> _innerNavigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<BilanBloc>()..add(DemarrerBilanEvent()),
      child: PopScope(
        // 2. On empêche la fermeture de l'app SI le navigator interne peut faire "back"
        canPop: false, 
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;

          // 3. On vérifie si le Navigator interne a des pages à dépiler
          final NavigatorState? navigator = _innerNavigatorKey.currentState;
          if (navigator != null && navigator.canPop()) {
            navigator.pop(); // On fait le retour arrière interne
          } else {
            // S'il n'y a plus de pages (on est sur BilanPage), on quitte le Flow
            Navigator.of(context).pop(); 
          }
        },
        child: Navigator(
          key: _innerNavigatorKey, // 4. On assigne la clé ici
          initialRoute: 'questions',
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) {
                switch (settings.name) {
                  case 'questions': return const BilanPage();
                  case 'categories': return const ChoixCategoriesPage();
                  case 'objectifs': return const PersonalGoalPage();
                  case 'resultats': return const ResultsPage();
                  default: return const BilanPage();
                }
              },
            );
          },
        ),
      ),
    );
  }
}