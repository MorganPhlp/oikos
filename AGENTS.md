# Travailler sur Oikos

Lire `README.md`, `docs/architecture.md` et `docs/integration-report.md` avant une évolution transversale. L’application Flutter contient les parcours membres et `/admin/*` dans un même exécutable.

## Préserver le travail

- Examiner `git status` et les deux versions d’un conflit avant de modifier. Préserver les changements locaux indépendants. Ne pas choisir globalement ours/theirs, ne pas nettoyer les sauvegardes de l’utilisateur.
- Une correction doit préserver les parcours mobile, administrateur, bilan, actions, communautés, notifications, scan et streak. Ne pas remplacer des données absentes par des statistiques inventées.
- Ne pas modifier `.claude/settings.local.json` pour une tâche applicative.

## Architecture

- Organisation par feature : `domain` (entités, interfaces et use cases), `data` (SDK, sérialisation et repositories), `presentation` (widgets et Bloc/Cubit).
- Le domaine ne dépend ni de Flutter, ni de Supabase, ni de `data` ou `presentation`. Les icônes et couleurs Flutter restent dans la présentation/le thème.
- Aucun accès réseau/DB dans les widgets. Utiliser les interfaces du domaine injectées par `init_dependencies.dart`. Ajouter un use case lorsqu’il porte une règle ou un workflow, pas un wrapper systématique à une ligne.
- `UserEntity`, `AppUserCubit`, `AuthRepository` et l’unique `SupabaseClient` sont canoniques. Ne pas recréer un utilisateur admin concurrent ni un second client « externe/local ».
- Fermer subscriptions, controllers et ressources ; vérifier `mounted` après les attentes. Une réponse tardive ne doit pas restaurer une session déconnectée.
- Exécuter `node scripts/check-architecture.mjs` pour vérifier les frontières.

## Thème

- Source partagée dans `lib/core/theme` : `AppColors`, `AppTypography`, `AppTheme`, `Breakpoints` et `AppSizes`.
- Consommer `Theme.of(context).colorScheme` et les extensions `AdminColors`, `ActionCardTheme`, `OikosButtonTheme`. `AdminColors` est un adaptateur du thème commun.
- Ajouter une couleur métier dans les tokens avant usage ; éviter de copier une palette par plateforme. Tester les modes clair/sombre et une largeur mobile pour les composants partagés.
- Outfit est embarquée avec sa licence dans `assets/fonts`. Ne pas réintroduire de chargement de police distant implicite.

## Supabase et configuration

- Lire aussi `supabase/AGENTS.md`. Les droits réels sont garantis par PostgreSQL/RLS, jamais uniquement par le routeur.
- `config/local*.json` est généré et ignoré. Seules URL et clé publique anon/publishable vont dans Flutter. Aucune clé service_role/secret, mot de passe réel ou session dans le code, les fixtures ou les logs.
- Utiliser `scripts/local.ps1` pour la base `oikos-integration`. Un reset concerne uniquement cette base locale de démonstration.
- Une demande locale n’autorise pas `db push`, `--linked`, une suppression distante, une publication ou une rotation de secrets en production.

## Vérification avant livraison

1. `flutter pub get` ; après modification Freezed/JSON : `dart run build_runner build --delete-conflicting-outputs`.
2. `dart format lib test` ; `flutter analyze` ; `flutter test`.
3. `node scripts/check-architecture.mjs` ; `npm audit` si dépendances Node touchées.
   Publicodes : `node scripts/build-publicodes.mjs` puis `node scripts/publicodes.test.mjs`. Ne jamais remplacer une erreur de calcul par zéro ; Web et mobile partagent le même bundle.
4. SQL modifié : `pwsh -File scripts/local.ps1 -Action reset`, puis `-Action test` et `supabase db lint --local --level warning`.
5. Parcours/thème/config modifiés : build Web et Android pertinent, puis vérifier login, rôle, navigation et état vide/erreur. Rapport explicite si un outil ou un appareil manque.

Dans Codex, préférer les outils Dart MCP pour analyse, format et tests. Ne pas masquer les diagnostics ni déclarer « prêt production » sur le seul résultat d’un build. Documenter les décisions métier, les commandes et les limites vérifiées.
