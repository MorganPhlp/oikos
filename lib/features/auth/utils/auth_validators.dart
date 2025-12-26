class AuthValidators {
  static const List<String> professionalDomains = [ // TODO : A aller chercher depuis BD plus tard
    'oikos.fr',
    'viveris.fr',
    'company.com',
    'enterprise.fr'
  ];

  // Mock Data
  // TODO : Remplacer par un appel API réel
  static const Map<String, Map<String, String>> communityCodes = {
    'PAR123': {'name': 'Paris La Défense', 'icon': '🗼'},
    'LYO456': {'name': 'Lyon Part-Dieu', 'icon': '🦁'},
    // ... autres codes
  };

  static String? validateProfessionalEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Oups ! Il manque ton email 😊';
    }

    final parts = value.split('@');
    if (parts.length != 2) return 'Format d\'email invalide';

    final domain = parts[1];
    // Vérifie si le domaine fait partie de la liste
    bool isPro = professionalDomains.any((d) => domain.contains(d));

    if (!isPro) {
      return 'On a besoin de ton email pro et non perso 😉';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le mot de passe est requis';
    }
    if (value.length < 6) {
      return 'Le mot de passe est trop court';
    }
    return null;
  }

  static String? validateCommunityCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le code de communauté est requis';
    }
    if (value.length != 6) {
      return 'Le code de communauté doit contenir 6 caractères';
    }
    final regex = RegExp(r'^[A-Za-z0-9]{6}$');
    if (!regex.hasMatch(value)) {
      return 'Le code de communauté doit être alphanumérique';
    }
    if(!communityCodes.containsKey(value.toUpperCase())) {
      return 'Code de communauté invalide';
    }
    return null;
  }
}