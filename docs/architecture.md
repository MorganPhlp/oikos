# Architecture consolidée

Oikos conserve son architecture par fonctionnalités et Bloc/Cubit. Les use cases existants restent dans `domain/usecases` ou `domain/use_cases` ; leur renommage global n’est pas requis pour une évolution locale.

```text
Widgets / routes → Bloc, Cubit ou contrôleur local → interfaces / use cases du domaine
                                                    ↑
                              repositories data → Supabase, HTTP, Publicodes
```

`init_dependencies.dart` compose les dépendances avec GetIt. Un seul client Supabase dessert le mobile et l’administration. `UserEntity` et `AppUserCubit` représentent la même session : rôle, entreprise, progression du bilan et mises à jour temps réel. `AuthRepository.sessionChanges` traduit les événements du SDK ; les widgets ne manipulent plus Supabase Auth. `auth_redirect.dart` définit les redirections UX, la base impose les autorisations.

Les modèles admin et communautaires immuables sans dépendance SDK sont partagés dans leurs domaines. Certains gardent des factories JSON pour limiter une duplication de types sans règle métier ; une séparation DTO/entité reste possible si leurs contrats divergent. Les entités d’actions portent un nom d’icône ; l’extension de présentation le traduit en `IconData`. Les filtres d’actions ne dépendent plus de leur modale.

Les écrans communautaires passent par `CommunityRepository`. Les workflows à privilèges (duel aléatoire, récompense collective, anonymisation) sont atomiques dans PostgreSQL. Les lectures de classements exposent uniquement les champs de profil utiles, pas les emails des autres membres.

## Calcul carbone

`SimulationRepository` est implémenté par deux adaptateurs : interop JavaScript sur Web et isolate avec runtime JS sur mobile. Ils exécutent le même bundle Publicodes généré par `scripts/build-publicodes.mjs`, avec les mêmes règles embarquées. Le contrat JSON distingue un résultat d’une erreur ; un timeout ou une règle invalide ne produit plus artificiellement zéro. Chaque questionnaire réinitialise puis restaure sa situation. Les détails sont enregistrés avant le marqueur de bilan terminé ; un total invalide ou une catégorie absente bloque la clôture.

## Thème partagé

`AppColors` porte les palettes et couleurs sémantiques. `AppTheme` produit les deux `ThemeData` et rassemble espacements/rayons. `AdminColors` adapte ces tokens pour les surfaces administrateur ; `ActionCardTheme` et `OikosButtonTheme` couvrent les composants métier des deux parcours. `AppTypography` utilise Outfit embarquée. `Breakpoints` et `AppSizes` sont communs aux layouts adaptatifs. Le choix clair/sombre est piloté par un `ThemeCubit` à la racine.

Des dimensions locales et des couleurs d’illustration subsistent lorsqu’elles n’expriment pas un token partagé. Les nouvelles surfaces doivent employer le thème et non copier une palette.

## Données et confidentialité

Les accès individuels sont limités au propriétaire ; l’administration accède à son entreprise. Un compte anonymisé perd immédiatement l’accès aux données privées, même avec un JWT encore valide. Les classements sont projetés par fonctions privées limitées au tenant. Les indicateurs admin reposent sur les bilans/actions réels ; la rétention reste affichée comme non mesurée.

La pause volontaire (`est_actif`) et la révocation (`est_compte_valide`/`etat_compte`) sont distinctes : la pause retire du classement sans empêcher la connexion. Les récompenses sont calculées en base, avec verrous pour empêcher le rejeu concurrent.

## Sources de travail

Les conventions ont été confrontées aux recommandations [Flutter Architecture](https://docs.flutter.dev/app-architecture) et [Supabase local development](https://supabase.com/docs/guides/local-development). La police vient du dépôt officiel [Google Fonts / Outfit](https://github.com/google/fonts/tree/main/ofl/outfit), licence OFL incluse.
