// Entité représentant une action communautaire
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