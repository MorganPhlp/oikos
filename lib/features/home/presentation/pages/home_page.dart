import 'package:flutter/material.dart';
import 'package:oikos/features/defisCommunautaires/presentation/widgets/defis_communautaires_card_widget.dart';
import 'package:oikos/features/home/domain/entities/stats_cards_entitie.dart';
import 'package:oikos/core/common/widgets/header.dart';
import 'package:oikos/features/home/presentation/widgets/quick_access_widget.dart';
import 'package:oikos/features/home/presentation/widgets/stats_caroussel_widget.dart';
import 'package:oikos/features/streak/presentation/widgets/streak_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child:Column(
          children:[
            const Header(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(children: [
                const SizedBox(height:24),

                StreakWidget( 
                  endSeasonDate:  DateTime.now().add(const Duration(days: 15)), 
                  timeLeftBeforeLosingStreak: DateTime.now().add(const Duration(seconds: 10)),
                ),
                
                const SizedBox(height:32),
                // TODO : remplacer par les vraies stats cards (depuis supabase)
                StatsCarousselWidget(allStatsCards: [StatsCardsEntitie.mock1(), StatsCardsEntitie.mock2(), StatsCardsEntitie.mock3()]),
                const SizedBox(height: 32),
                const QuickAccessWidget(),
                const SizedBox(height: 32),
                const DefisCommunautairesCardWidget(),
                const SizedBox(height: 100),
              ],)
              ),
            
          ]
        )
      )
    );
  }
}