class AuthValidators {
  static const List<String> professionalDomains = [ // TODO : A aller chercher depuis BD plus tard
    'oikos.fr',
    'viveris.fr',
    'company.com',
    'enterprise.fr'
  ];

  static String? validateProfessionalEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Oups ! Il manque ton email 😊';
    }

    final parts = value.split('@');
    if (parts.length != 2) return 'Format d\'email invalide';

    final domain = parts[1];
    // Vérifie si le domaine fait partie de la liste
    // Note: simplifiée par rapport au React, on vérifie si ça finit par le domaine
    bool isPro = professionalDomains.any((d) => domain.contains(d));

    if (!isPro) {
      return 'On a besoin de ton email pro pour tes collègues 🤝';
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
}