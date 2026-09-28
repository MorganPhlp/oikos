import 'dart:convert';

/// Decode the same explicit success/error contract on Web and mobile.
dynamic decodePublicodesResponse(String response) {
  final result = jsonDecode(response) as Map<String, dynamic>;
  if (result['error'] != null) {
    throw StateError('Calcul Publicodes impossible : ${result['error']}');
  }
  if (!result.containsKey('data')) {
    throw const FormatException('Réponse Publicodes incomplète');
  }
  return result['data'];
}

const publicodesCategories = [
  'alimentation',
  'logement',
  'transport',
  'divers',
  'services sociétaux',
];
