import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oikos/features/bilanCarbone/presentation/bloc/bilan_bloc.dart';
import 'package:oikos/features/bilanCarbone/presentation/pages/bilan_page.dart';
import 'package:oikos/features/bilanCarbone/presentation/pages/choix_categories_page.dart';
import 'package:oikos/features/bilanCarbone/presentation/pages/choix_objectifs.dart';
import 'package:oikos/features/bilanCarbone/presentation/pages/resultats_page.dart';
import 'package:oikos/init_dependencies.dart';

class BilanFlow extends StatelessWidget {
  const BilanFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // On injecte le Bloc ici, il sera disponible pour TOUT ce qui est dans ce Navigator
      create: (context) => serviceLocator<BilanBloc>()..add(DemarrerBilanEvent()),
      child: Navigator(
        initialRoute: 'questions',
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) {
              switch (settings.name) {
                case 'questions':
                  return const BilanPage();
                case 'categories':
                  return const ChoixCategoriesPage();
                case 'objectifs':
                  return const PersonalGoalPage();
                case 'resultats':
                  return const ResultsPage();
                default:
                  return const BilanPage();
              }
            },
          );
        },
      ),
    );
  }
}