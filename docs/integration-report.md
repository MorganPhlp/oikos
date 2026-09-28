# Rapport d’intégration — 28 septembre 2026

## 1. Git et stratégie

État initial : `feature/atheme/admin` à `a5a18be` (un commit local devant son remote), `master` à `24a61fe`, ancêtre commun `4ef8fc30d35c87a3e34efdbde72789fb2d574657`. La divergence représentait 152 commits propres à master et 15 propres à la branche admin. La suppression locale de `.claude/settings.local.json` était préexistante ; elle est conservée hors du commit d’intégration. Le stash préexistant n’a pas été modifié.

La branche `release/integration-production-readiness` (créée initialement sous `codex/integration-production-readiness`, puis renommée à la demande de l’utilisateur) part de la branche admin et fusionne master sans réécriture d’historique. Les principaux conflits concernaient l’utilisateur, la session, Auth, le routeur, l’injection, le thème, les modules bilan/dashboard et les migrations. La consolidation sauvegardée, explicitement autorisée, a conservé des copies des fichiers touchés dans `build/integration-backup` (ignoré par Git). L’intégration initiale était locale, sans push ni changement sur une base hébergée ; la publication Git a ensuite été demandée séparément.

La fusion est enregistrée dans `6b37bc3`, avec parents `a5a18be` et `24a61fe`. Les deux branches sont vérifiées comme ancêtres du résultat. Seule la suppression préexistante de `.claude/settings.local.json` reste hors commit.

Les parcours membres les plus récents viennent de master ; les pages administrateur sont intégrées à leur routeur et à leur session commune. Le schéma distant complet de la branche admin est conservé dans `docs/legacy/admin_remote_schema.sql` comme référence, sans être rejoué comme une migration concurrente.

## 2. Fonctionnalités préservées

| Origine | Fonctionnalités conservées |
| --- | --- |
| master | Inscription/connexion/récupération, bilan Publicodes et résultats, objectifs, accueil, statistiques personnelles, catalogue/actions/habitudes/exclusions, communautés et défis, classement, notifications, streak, scan OpenFoodFacts, présentation PDF |
| branche admin | Vue globale, statistiques par catégorie/période, gestion des communautés et de leurs membres, classement entreprise, gestion des utilisateurs, profil administrateur et entreprise, layouts adaptatifs |

Conservation du code et validation ne sont pas synonymes de recette exhaustive : caméra réelle, iOS et l’ensemble des combinaisons des 32 questions restent à vérifier sur leurs plateformes cibles.

## 3. Architecture

Les deux branches avaient des utilisateurs et Cubits concurrents, des accès Supabase depuis les widgets, des modèles du domaine dépendant de Flutter et des statistiques simulées.

La structure par feature reste `domain` / `data` / `presentation`, avec Bloc/Cubit et GetIt. Le domaine contient les contrats et règles ; data adapte Supabase/HTTP/Publicodes ; la présentation gère les interactions et les états. Un seul `SupabaseClient`, `UserEntity`, `AppUserCubit` et `AuthRepository` sont utilisés. Les changements de session, de rôle et la déconnexion sont propagés ; une réponse asynchrone tardive ne peut plus restaurer une session déconnectée.

Les workflows privilégiés sont validés et exécutés atomiquement en base. Le script `scripts/check-architecture.mjs` protège les frontières d’imports. Il ne prouve pas à lui seul l’absence de toute logique métier dans les widgets. Les conventions futures sont dans les deux `AGENTS.md` et `docs/architecture.md`.

## 4. Thème

`AppColors` et `AppTypography` constituent la source commune. `AppTheme` rassemble `ThemeData`, spacing/radius et extensions. `AdminColors` adapte la palette commune ; `ActionCardTheme` et `OikosButtonTheme` portent les couleurs métier. Les icônes des actions sont résolues dans la présentation. Outfit est embarquée avec sa licence OFL ; aucun téléchargement implicite de police.

Le mode système/clair/sombre est piloté par le Cubit racine et un sélecteur partagé dans les deux profils. Les graphiques admin utilisent les surfaces et textes du thème ; l’évolution carbone affiche correctement des tonnes. La préférence explicite reste en mémoire pour la session ; sa persistance est une amélioration ultérieure.

## 5. Refactoring principal

- Modèles administrateur et communauté déplacés vers leurs domaines lorsqu’ils sont partagés ; certains gardent leur sérialisation JSON afin d’éviter deux types identiques sans besoin métier.
- Suppression du second utilisateur admin/Cubit et de la configuration Supabase intégrée au code.
- Extraction de `CommunityRepository`, du filtre d’actions et des projections de classement ; résolution des URLs d’assets et icônes dans les couches appropriées.
- Auth et changement de mot de passe passent par le repository. L’inscription ne recherche plus les emails d’autres utilisateurs.
- Suppression des statistiques inventées, des fixtures dashboard inutilisées et des palettes de catégories dupliquées.
- Chargement des assets de démonstration unifié ; ancien script streak conservé comme point d’entrée de compatibilité local.
- Fermeture des subscriptions/controllers touchés, contrôles `mounted`, journalisation désactivée en release, timeout de la requête produit OpenFoodFacts.
- Caches Visual Studio/Kotlin et rapports de build retirés du suivi Git, conservés sur disque. Ancien widget de défis simulés et méthode de lecture de bilan inutilisée supprimés après vérification des références.

## 6. Lacunes fonctionnelles traitées

- Données réelles pour les graphiques et indicateurs admin ; « rétention non mesurée » au lieu d’une valeur fictive.
- Bouton des notifications relié à son écran ; actions/catégories/tags écartés consultables et restaurables avec retour d’erreur.
- Session admin enrichie de l’entreprise avant navigation ; récupération de mot de passe et redirections des deux parcours consolidées. Les URLs privées sont conservées pendant la restauration de session, avec réévaluation des permissions.
- Récompenses individuelles, collectives et duels contrôlés côté serveur. Verrous contre les validations concurrentes et les duels doublonnés ; dates et XP du client non fiables ignorés.
- Retrait d’un membre autorisé dans son entreprise ; renommage d’une communauté propagé à son historique. Suppression d’une communauté ayant des participations/défis refusée explicitement afin de conserver cet historique.
- Les images de streak indisponibles disposent d’un visuel de repli ; abonnement Realtime ajouté pour streak et saison.
- Le service Web Publicodes était un stub qui enregistrait zéro. Il exécute maintenant le même moteur que le mobile. Les erreurs ne sont plus converties en zéro, les réponses en mémoire sont réinitialisées/restaurées à chaque questionnaire, les détails précèdent la clôture et l’enregistrement de l’objectif est attendu.
- Le formateur des réponses est partagé entre saisie et reprise ; modifier un choix multiple désactive les anciennes options au lieu de les conserver dans la simulation.

Les règles conservées sont documentées : seuil de lancement à 60 % des membres actifs non administrateurs, validation quotidienne des duels, pause volontaire distincte de la révocation. Une journée SQL est actuellement calculée selon le fuseau de la base (UTC en local).

## 7. Préparation à la production

**Sécurité et DB.** RLS activée sur toutes les tables publiques ; profils privés, administration limitée au tenant, classements sans emails. Droits d’écriture limités par colonne, fonctions à privilèges isolées, valeurs de rôle/XP imposées en base. L’anonymisation masque Auth et le profil, supprime les sessions et bloque les JWT existants via RLS. Les buckets publics ne contiennent que des illustrations distribuables ; les uploads restent serveur. Contraintes, index de jointure et filtres usuels ajoutés.

**Configuration.** Fichiers d’exemple publics ; config locale générée et ignorée. Les clés serveur ne vont pas dans Flutter. Android release refuse HTTP et exige une signature de distribution séparée. Les comptes de seed sont fictifs, mot de passe local connu. Les anciens seeds contenaient des données Auth sensibles : ils sont remplacés dans l’état courant, mais leur historique Git n’est pas purgé. Faire invalider les identifiants/sessions concernés s’ils étaient encore utilisés dans un environnement réel.

**Robustesse et performance.** Concurrence des récompenses testée, accès aux données extraits, index ajoutés, erreurs principales remontées. Pas de file offline durable, retry global, benchmark de charge ni preuve de performance à grande volumétrie. Certaines listes admin chargent encore tous les membres de l’entreprise.

**Observabilité.** Logs de développement conservés sans sortie release ; aucune télémétrie de crash/alerte externe configurée. Un suivi de crash, erreurs backend, backups et alertes doit être défini avant exploitation.

**Déploiement hébergé — travail préalable obligatoire.** Les migrations historiques de master contenaient des dépendances hors ordre et une table de participations incohérente ; elles ont été corrigées pour permettre un replay vierge. Ne pas faire un `db push` aveugle sur une base existante :

1. Sauvegarder schéma et données de l’environnement concerné ; comparer `supabase_migrations.schema_migrations`, les deux schémas historiques et le schéma local final.
2. Préparer des migrations additives de réconciliation sur une copie de staging ; examiner doublons de pseudos/domaines, codes de communautés orphelins et conflits de contraintes avant activation.
3. Valider les tests d’accès avec plusieurs tenants et le vrai flux SMTP (confirmation/récupération), les URLs de redirection et les liens profonds.
4. Rejouer une restauration de sauvegarde, configurer HTTPS, politique CORS de l’hébergeur, signature Android/iOS et surveillance. Obtenir la validation du déploiement réel.

La base est consolidée et vérifiable localement ; elle n’est pas déclarée immédiatement déployable sur un environnement hébergé inconnu.

## 8. Vérifications exécutées

Les appels Dart ci-dessous sont exécutés par le serveur MCP Dart (équivalents CLI indiqués).

| Commande | Résultat |
| --- | --- |
| `flutter pub get` | Réussi |
| `dart run build_runner build --delete-conflicting-outputs` | Réussi, modèles générés actualisés |
| `dart format lib test` | 474 fichiers formatés |
| `flutter analyze` | Aucun diagnostic après correction |
| `flutter test` | 19 tests réussis : filtres, rôles/redirections/session et restauration des URLs, exclusions, thème, calcul/persistance du bilan et modification des choix multiples |
| `node scripts/build-publicodes.mjs` puis `node scripts/publicodes.test.mjs` | 4 tests réussis sur le vrai bundle : initialisation, total/catégories, effet des réponses/réinitialisation, erreurs |
| `node scripts/check-architecture.mjs` | Réussi |
| `npm audit --audit-level=high` | Aucune vulnérabilité après mise à jour du lockfile |
| `node scripts/sync_questions.js --sql` | 32 questions générées depuis le modèle embarqué |
| `pwsh -File scripts/local.ps1 -Action reset` | Replay vierge, seed et assets locaux réussis |
| `pwsh -File scripts/local.ps1 -Action test` | 11 scénarios HTTP réussis sur Auth/PostgREST, incluant le bilan |
| `supabase test db` | 4 assertions pgTAP réussies |
| `supabase db lint --local --level warning` | Aucune erreur de schéma |
| `flutter build web --release --no-pub --dart-define-from-file=config/local.json` | Premier build réussi |
| `flutter build web --release --no-pub --no-wasm-dry-run --dart-define-from-file=config/local.json` | Build final JavaScript réussi, 335 secondes ; essai exploratoire WASM désactivé |
| `flutter build apk --release --no-pub --dart-define-from-file=config/local.android.json` | Build final réussi : APK non signé de 104,9 Mo, 1330 secondes |

Recette navigateur : connexion admin, données de la vue globale, communautés et membres, utilisateurs et profil ; déconnexion ; connexion Alice en largeur 390 px, accueil, catalogue, détail, ajout et validation d’action. La seconde validation du jour est désactivée. Le passage au mode clair puis le retour au système ont été vérifiés dans le profil admin à 1280 px. Captures locales dans `build/manual-action-validation.png` et `build/manual-admin-light.png`. La base finale a été réinitialisée après les tests : 5 comptes fictifs, 2 entreprises, 3 communautés, 32 questions et 4 bilans. La CI est configurée dans `.github/workflows/quality.yml` ; aucune exécution distante n’est revendiquée.

Échecs rencontrés puis corrigés : migrations historiques non rejouables, résolution de rôle depuis le mauvais payload Auth, diagnostics Dart, politique de lecture des participations, fixture du test bilan sans score initial, moteur Web renvoyant zéro et mémoire JVM insuffisante. Les tests finaux Flutter/moteur/API/SQL ne présentent aucun échec. L’exécution Node via `node --test` a été refusée par le sandbox Windows (`spawn EPERM`) ; l’exécution directe du même fichier `node scripts/publicodes.test.mjs` passe ses quatre tests.

Le rechargement de `/admin/profil` conserve également la page après restauration de session (vérifié dans le navigateur). Pour une prévisualisation d’un nouveau build release, le service worker Flutter peut nécessiter un second rechargement après activation de sa nouvelle version ; les tests de rendu ont aussi utilisé une origine locale vierge. Le développement avec `flutter run` évite ce cache de release.

Recette du calcul : le compte nouveau membre a répondu aux questions obligatoires, ignoré les questions voiture/avion inapplicables, choisi ses catégories et un objectif. Le résultat réel affiche **5,2 tonnes CO₂e/an**, sa répartition par catégorie et un équivalent ; aucune erreur console. La lecture SQL confirme 5172,68 kg CO₂e, `complet=true` et la présence du détail. La reprise depuis le profil restaure les réponses et retrouve le même résultat. Capture : `build/manual-bilan-calculated.png`. Le défaut initial à zéro a été identifié pendant cette recette et corrigé avant livraison.

Le dernier reset confirme 5 comptes, 2 entreprises, 3 communautés, 32 questions et 4 bilans de seed. La clé publique du build Web accède encore au catalogue après reset (HTTP 200). Les logs locaux sont dans `build/web-final.log`, `build/android-final.log`, `build/publicodes-tests.log`, `build/database-tests.log` et `build/local-final.log` ; ils sont ignorés par Git.

## 9. Dette et limites restantes

- Réconciliation du schéma hébergé et invalidation des anciennes données Auth si elles étaient réelles.
- Signature release, recette caméra sur Android, build/recette iOS sur macOS, liens profonds et mails de confirmation en staging.
- Recette exhaustive des combinaisons Publicodes et de l’export PDF ; robustesse hors connexion et erreurs de services tiers.
- Monitoring/crash reporting, politique de sauvegarde et essais de charge.
- Pagination de certaines listes, simplification progressive des très grands widgets/formulaires, harmonisation des noms `use_cases`/`usecases`.
- Persistance du thème, stratégie d’assets de streak indépendante du nom d’entreprise et clarification du fuseau métier des validations quotidiennes.
- Couverture de tests ciblée sur les risques de fusion/sécurité ; elle ne remplace pas une suite end-to-end de l’ensemble du produit.

Consulter `docs/local-development.md` pour les commandes de lancement, les cinq comptes fictifs et les URLs locales.
