import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Ajout pour Supabase
import 'package:oikos/features/community/presentation/widgets/community_challenges_card_widget.dart';
import 'package:oikos/features/home/domain/entities/stats_cards_entitie.dart';
import 'package:oikos/core/common/presentation/widgets/header.dart';
import 'package:oikos/features/home/presentation/widgets/quick_access_widget.dart';
import 'package:oikos/features/home/presentation/widgets/stats_caroussel_widget.dart';
import 'package:oikos/features/streak/presentation/widgets/streak_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _entrepriseId;
  String? _myCommunityCode;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Récupération des infos nécessaires pour les défis
  Future<void> _loadUserData() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        final data = await Supabase.instance.client
            .from('utilisateur')
            .select('entreprise_id, code_communaute')
            .eq('id', user.id)
            .single();

        if (mounted) {
          setState(() {
            _entrepriseId = data['entreprise_id'];
            _myCommunityCode = data['code_communaute'];
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint("Erreur chargement Home: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Header(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  StreakWidget(),
                  const SizedBox(height: 32),
                  
                  StatsCarousselWidget(
                    allStatsCards: [
                      StatsCardsEntitie.mock1(),
                      StatsCardsEntitie.mock2(),
                      StatsCardsEntitie.mock3(),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  const QuickAccessWidget(),
                  const SizedBox(height: 32),

                  // APPEL AU WIDGET AVEC LES VARIABLES RÉCUPÉRÉES
                  if (_isLoading)
                    const CircularProgressIndicator()
                  else if (_entrepriseId != null && _myCommunityCode != null)
                    CommunityChallengesCardWidget(
                      entrepriseId: _entrepriseId!,
                      myCommunityCode: _myCommunityCode!,
                    )
                  else
                    const Text("Rejoignez une communauté pour voir les défis"),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}