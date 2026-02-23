/// Entité représentant une action communautaire
/// [id] : identifiant unique
/// [title] : titre de l'action
/// [subtitle] : sous-titre de l'action
/// [xpGain] : XP rapportés par la réalisation de l'action
/// [iconKey] : icône associée
class CommunityAction {
  final String id;
  final String title;
  final String subtitle;
  final int xpGain;
  final String iconKey;

  CommunityAction({
    required this.id, 
    required this.title, 
    required this.subtitle, 
    required this.xpGain, 
    required this.iconKey
  });
}