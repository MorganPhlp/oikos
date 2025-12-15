import 'package:freezed_annotation/freezed_annotation.dart';

enum TypeWidget {
  @JsonValue('SLIDER')
  slider,
  @JsonValue('NOMBRE')
  nombre,
  @JsonValue('CHOIX_UNIQUE')
  choixUnique,   // Pour les Radio Buttons
  @JsonValue('CHOIX_MULTIPLE')
  choixMultiple, // Pour les Checkboxes
  @JsonValue('BOOLEEN')
  booleen,       // Pour les Switchs (Oui/Non)
  @JsonValue('COMPTEUR')
  compteur,      // Pour les + / -
}