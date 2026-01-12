class AuthValidators {
  // Regex basique pour valider le format d'email
  static bool isValidEmail(String email) {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email);
  }

  // Mot de passe robuste
  static bool isStrongPassword(String password) {
    // Au moins 8 caractères, une majuscule, une minuscule, un chiffre et un caractère spécial
    return RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&_(){}#/-])[A-Za-z\d@$!%*?&_(){}#/-]{8,}$',
    ).hasMatch(password);
  }

  static String? passwordErrorText(String? password) {
    if(password == null || password.isEmpty) {
      return 'Veuillez entrer un mot de passe.';
    }
    if (password.length < 8) {
      return 'Le mot de passe doit contenir au moins 8 caractères.';
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'Le mot de passe doit contenir au moins une lettre majuscule.';
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return 'Le mot de passe doit contenir au moins une lettre minuscule.';
    }
    if (!RegExp(r'\d').hasMatch(password)) {
      return 'Le mot de passe doit contenir au moins un chiffre.';
    }
    if (!RegExp(r'[@$!%*?&_(){}#/-]').hasMatch(password)) {
      return 'Le mot de passe doit contenir au moins un caractère spécial.';
    }
    return null; // Mot de passe valide
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Veuillez entrer une adresse e-mail.';
    }
    if (!isValidEmail(value.trim())) {
      return 'Veuillez entrer une adresse e-mail valide.';
    }
    return null; // Email valide
  }
}
