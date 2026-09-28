<p align="center">
  <img src="assets/logos/oikos_logo.png" alt="Logo Oikos" width="420" />
</p>

# Oikos — Réduire son empreinte carbone ensemble

Oikos est une application Flutter réalisée dans le cadre du projet de génie logiciel pour **Viveris**. Elle aide les collaborateurs d’une entreprise à comprendre leur empreinte carbone et à la réduire grâce à des actions personnelles, des communautés et des défis collectifs.

Le même projet rassemble l’application membre et le tableau de bord administrateur. La branche **`release/integration-production-readiness`** intègre les parcours de `master` et de `feature/atheme/admin`.

La base est validée localement sur Web et par compilation Android. Les étapes restant nécessaires avant une mise en production sont décrites dans [Préparer un déploiement](#préparer-un-déploiement) et dans le [rapport d’intégration](docs/integration-report.md).

## Sommaire

- [Fonctionnalités](#fonctionnalités)
- [Stack et prérequis](#stack-et-prérequis)
- [Démarrage rapide](#démarrage-rapide)
- [Supabase local et données de démonstration](#supabase-local-et-données-de-démonstration)
- [Configuration](#configuration)
- [Lancer les applications](#lancer-les-applications)
- [Architecture et organisation](#architecture-et-organisation)
- [Thème et calcul carbone](#thème-et-calcul-carbone)
- [Tests et qualité](#tests-et-qualité)
- [Builds et intégration continue](#builds-et-intégration-continue)
- [Préparer un déploiement](#préparer-un-déploiement)
- [Dépannage](#dépannage)
- [Contribuer](#contribuer)
- [Documentation et équipe](#documentation-et-équipe)

## Fonctionnalités

| Parcours | Fonctionnalités |
| --- | --- |
| Compte | Inscription, connexion, récupération de mot de passe, profil et préférences |
| Bilan carbone | Questionnaire Publicodes, reprise des réponses, résultats par catégorie, équivalents carbone et objectifs personnels |
| Actions | Catalogue, filtres, actions en cours, validation quotidienne, habitudes et restauration des actions écartées |
| Communautés | Communautés d’entreprise, actions collectives, défis, votes et classement |
| Engagement | XP, streak, notifications et progression personnelle |
| Produits | Scan de codes-barres et consultation des informations OpenFoodFacts |
| Administration | Indicateurs réels, graphiques par période/catégorie, gestion des communautés et membres, utilisateurs, profil administrateur et entreprise |

Les routes d’administration sont sous `/admin/*`. La session détermine le parcours accessible ; les autorisations effectives sont également contrôlées dans PostgreSQL.

La présence d’un parcours ne signifie pas qu’il a été testé sur toutes les plateformes : la caméra sur appareil et iOS nécessitent encore une recette dédiée.

## Stack et prérequis

| Outil | Version / usage |
| --- | --- |
| Flutter / Dart | Versions validées : **Flutter 3.38.5 / Dart 3.10.4** |
| Gestion d’état et navigation | Bloc/Cubit, GetIt, go_router |
| Backend | Supabase : PostgreSQL, Auth, Storage et Realtime |
| Calcul carbone | Publicodes et règles embarquées, sans service de calcul distant |
| Node.js | **22**, avec npm pour les scripts et leurs dépendances verrouillées |
| Supabase CLI | **2.72.7** pour reproduire l’environnement validé et la CI |
| Docker | Docker Desktop avec conteneurs Linux, démarré avant le setup |
| PowerShell | **7+** (`pwsh`), utilisé par les scripts locaux sur Windows/Linux/macOS |
| Android | Android Studio, SDK Android 36 et licences acceptées ; la CI utilise Java 17 |
| iOS | macOS, Xcode et configuration de signature ; non compilé sur Windows |
| Git | Clonage, branches et contributions |

Sous Windows, activer le **mode développeur** si Flutter demande la prise en charge des liens symboliques. Le serveur Web peut être exécuté dans Chrome ; un émulateur ou un appareil est nécessaire pour les fonctions mobiles.

Vérifier l’installation :

```powershell
flutter doctor -v
flutter --version
node --version
pwsh --version
supabase --version
docker version
```

## Démarrage rapide

Depuis un nouveau dossier de travail :

```powershell
git clone --branch release/integration-production-readiness https://github.com/MorganPhlp/oikos.git
cd oikos

npm ci --ignore-scripts
flutter pub get

# Docker doit être démarré.
pwsh -File scripts/local.ps1 -Action setup

flutter run -d chrome --web-port 3000 --dart-define-from-file=config/local.json
```

Le premier démarrage Supabase télécharge les images nécessaires, applique les migrations et charge les seeds sur une base neuve. Le script installe également les illustrations de démonstration et génère la configuration Flutter locale.

La CLI Supabase doit être installée séparément et disponible dans le `PATH` : `npm ci --ignore-scripts` ne réalise pas son installation native.

Ouvrir [l’application](http://localhost:3000), puis se connecter avec `alice@oikos.test` pour le parcours membre ou `admin@oikos.test` pour l’administration. Mot de passe local : **`OikosLocal123!`**.

## Supabase local et données de démonstration

Le projet local porte l’identifiant **`oikos-integration`** et utilise les ports suivants :

| Service | Adresse |
| --- | --- |
| Application Web | [http://localhost:3000](http://localhost:3000) |
| API Supabase | [http://127.0.0.1:41002](http://127.0.0.1:41002) |
| Supabase Studio | [http://127.0.0.1:41005](http://127.0.0.1:41005) |
| Boîte mail locale | [http://127.0.0.1:41006](http://127.0.0.1:41006) |
| PostgreSQL | `127.0.0.1:41000` |

Les comptes sont fictifs et réservés à la démonstration :

| Compte | Rôle et scénario |
| --- | --- |
| `admin@oikos.test` | Administrateur de l’entreprise Oikos Démo |
| `alice@oikos.test` | Membre, bilans existants, communauté DEMO01 |
| `bob@oikos.test` | Membre de la communauté DEMO02 |
| `nouveau@oikos.test` | Nouveau membre pour tester le premier bilan |
| `eve@autre.test` | Membre d’une seconde entreprise pour vérifier l’isolation |

**Mot de passe commun : `OikosLocal123!`.** Ne pas utiliser ces comptes ou ces seeds en production.

Après un reset, la base contient **5 comptes, 2 entreprises, 3 communautés, 32 questions et 4 bilans**, ainsi que des catégories, actions, détails de bilan, illustrations, une saison et des données communautaires. Les bilans historiques de démonstration ne constituent pas des questionnaires intégralement renseignés ; utiliser le nouveau membre pour tester la saisie complète.

### Commandes locales

À exécuter depuis la racine du dépôt :

```powershell
# Démarrer/reprendre les services, générer la configuration et charger les assets.
pwsh -File scripts/local.ps1 -Action setup

# Tester les contrats Auth/PostgREST avec plusieurs rôles et entreprises.
pwsh -File scripts/local.ps1 -Action test

# Effacer les données de démonstration de ce projet et rejouer migrations/seeds.
pwsh -File scripts/local.ps1 -Action reset

# Arrêter les services de ce projet en conservant les données locales.
supabase stop
```

`setup` conserve une base locale existante ; il ne remplace pas un reset et ne garantit pas à lui seul que de nouvelles migrations ont été appliquées. Pour retrouver exactement les fixtures après une évolution SQL, utiliser `reset` sur cette base de démonstration.

Les tests HTTP créent et modifient temporairement des données, puis nettoient leurs objets. Un reset restaure aussi les effets dérivés, notamment streak et notifications. Les scripts ciblent ce projet local et refusent une URL distante pour le chargement des assets de test.

Les règles SQL et les migrations sont expliquées dans [supabase/AGENTS.md](supabase/AGENTS.md). Le snapshot [admin_remote_schema.sql](docs/legacy/admin_remote_schema.sql) est une référence historique, pas une migration à exécuter.

## Configuration

Flutter reçoit sa configuration par `--dart-define-from-file`.

| Variable | Contenu |
| --- | --- |
| `SUPABASE_URL` | URL de l’API de l’environnement cible |
| `SUPABASE_ANON_KEY` | Clé publique anon ou publishable |
| `AUTH_REDIRECT_URL` | URL de retour après récupération/confirmation Auth |

| Fichier | Utilisation |
| --- | --- |
| [config/example.json](config/example.json) | Exemple versionné, à adapter ; sa clé est un placeholder |
| `config/local.json` | Généré par le setup pour le Web sur la machine hôte |
| `config/local.android.json` | Généré pour l’émulateur Android, avec l’hôte `10.0.2.2` |
| `config/staging.json` / `config/production.json` | À créer pour les environnements hébergés ; ignorés par Git |

Les fichiers locaux et les configurations de staging/production ne sont pas versionnés. **Aucune clé `service_role` ou `sb_secret_*` ne doit être transmise à Flutter.** Le script local ne conserve la clé serveur qu’en mémoire pendant ses opérations.

Le fichier [.env.example](.env.example) concerne les scripts serveur ; il ne remplace pas les paramètres de compilation Flutter.

## Lancer les applications

### Web, membre et administration

```powershell
flutter run -d chrome --web-port 3000 --dart-define-from-file=config/local.json
```

Se connecter avec le compte correspondant au rôle souhaité. Une tentative d’accès à une route administrateur depuis un compte membre est redirigée ; les requêtes vers les données restent protégées en base.

### Émulateur Android

Créer et démarrer un appareil dans le Device Manager d’Android Studio, puis :

```powershell
flutter doctor --android-licenses
flutter devices
flutter run -d <android-device-id> --dart-define-from-file=config/local.android.json
```

Remplacer `<android-device-id>` par l’identifiant affiché par `flutter devices`. `10.0.2.2` correspond à la machine hôte depuis l’émulateur Android ; cette adresse ne convient pas à un téléphone physique ni à un simulateur iOS. Pour ces appareils, préparer une configuration avec une API qu’ils peuvent joindre et une URL de retour Auth autorisée.

### Prévisualiser un build Web

```powershell
flutter build web --release --no-wasm-dry-run --dart-define-from-file=config/local.json
node scripts/serve-web.mjs
```

Le serveur sert `build/web` sur le port 3000 avec repli des routes vers `index.html`. Arrêter le serveur de développement avant de réutiliser ce port. `Ctrl+C` arrête le serveur dans son terminal.

## Architecture et organisation

Le code est organisé par fonctionnalité :

```text
lib/
  main.dart                 Démarrage de l’application
  app_router.dart           Routes membres, administration et récupération
  init_dependencies.dart    Composition des dépendances
  core/
    common/                 Contrats, session et composants partagés
    routing/                Règles de redirection
    theme/                  Tokens et thèmes communs
  features/
    actions/ admin/ auth/ bilanCarbone/ codeBarre/
    community/ dashboard/ home/ notifications/ profile/ streak/
assets/                     Règles Publicodes, JS, polices, images et documents
config/                     Exemple public et configurations locales ignorées
scripts/                    Setup, fixtures, vérifications et génération du moteur
supabase/
  migrations/               Historique SQL et contrats de sécurité
  tests/database/           Tests SQL pgTAP
  seed.sql                  Données fictives
  seed_questions.sql        Questions générées
test/                       Tests unitaires et widgets Flutter
docs/                       Architecture, guide local et rapport d’intégration
.github/workflows/          Intégration continue
```

Chaque feature répartit ses responsabilités entre :

- **`domain`** : entités, interfaces, règles métier et use cases, sans dépendance vers Flutter UI, Supabase ou les couches `data/presentation`.
- **`data`** : adaptation des API, sérialisation, accès Supabase/HTTP et implémentation des repositories.
- **`presentation`** : pages, widgets et Bloc/Cubit qui orchestrent les interactions et affichent les états.

`init_dependencies.dart` assemble les implémentations avec GetIt. `UserEntity`, `AppUserCubit`, `AuthRepository` et le client Supabase sont communs aux deux parcours. Certains modèles du domaine conservent des factories JSON ; cette décision est documentée dans [l’architecture](docs/architecture.md).

Les récompenses, transitions de défis et opérations privilégiées sont contrôlées côté PostgreSQL, avec transactions/verrous pour les appels concurrents. Les politiques RLS limitent les accès au propriétaire ou à son entreprise ; les classements n’exposent pas les emails des autres membres.

## Thème et calcul carbone

### Thème partagé

`lib/core/theme` est la source commune des couleurs, de la typographie, des tailles et des points de rupture. `AppTheme` produit les modes clair et sombre ; `AdminColors`, `ActionCardTheme` et `OikosButtonTheme` adaptent ces tokens aux composants.

Un sélecteur commun propose les modes système/clair/sombre dans les profils membre et administrateur. Le choix explicite est conservé pendant la session. La police Outfit et sa licence sont embarquées dans `assets/fonts`.

### Publicodes

Le Web et le mobile utilisent le même bundle JavaScript et les mêmes règles :

- Web : appels au moteur embarqué via interop JavaScript.
- Mobile : runtime JavaScript dans un isolate.
- Une erreur de calcul n’est pas remplacée par un score nul ; un résultat invalide ne clôture pas le bilan.

Après modification du moteur ou du pont JavaScript :

```powershell
node scripts/build-publicodes.mjs
node scripts/publicodes.test.mjs
```

Après modification des règles ou de la génération des questions :

```powershell
node scripts/sync_questions.js --sql
```

Versionner les fichiers générés correspondants, vérifier leur diff et tester le questionnaire. Ne pas éditer manuellement `publicodes_bundle.js` ou `seed_questions.sql`.

## Tests et qualité

### Flutter et règles d’architecture

```powershell
flutter pub get
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
node scripts/check-architecture.mjs
```

Après une modification de modèles Freezed/JSON, régénérer le code :

```powershell
dart run build_runner build --delete-conflicting-outputs
```

### Moteur et dépendances Node

```powershell
npm ci --ignore-scripts
node scripts/build-publicodes.mjs
node scripts/publicodes.test.mjs
npm audit --audit-level=high
```

### Contrats Supabase

Avec Docker et la base locale démarrés :

```powershell
pwsh -File scripts/local.ps1 -Action test
supabase test db
supabase db lint --local --level warning
```

Les vérifications couvrent notamment les rôles, l’isolation entre entreprises, les profils privés, les champs protégés, les récompenses concurrentes, les défis, les exclusions, l’anonymisation et la persistance du bilan.

**Validation locale du 28 septembre 2026 :** 19 tests Flutter, 4 tests du moteur Publicodes, 11 scénarios HTTP et 4 assertions SQL réussis ; analyse sans diagnostic, audit npm sans vulnérabilité et builds Web/Android réussis. Ce résultat décrit cette validation, pas le statut permanent de la branche ni une recette exhaustive. Les commandes et limites figurent dans le [rapport](docs/integration-report.md).

## Builds et intégration continue

### Web

```powershell
flutter build web --release --no-wasm-dry-run --dart-define-from-file=config/local.json
```

Sortie : `build/web/`. Le build validé cible JavaScript ; la compilation WASM n’est pas une cible validée. Pour un hébergement, utiliser la configuration HTTPS de l’environnement et prévoir le repli des routes vers `index.html`.

### Android

```powershell
flutter build apk --release --dart-define-from-file=config/local.android.json
```

Sortie : `build/app/outputs/flutter-apk/app-release.apk`. Sans `android/key.properties`, l’APK release est **non signé**. Il valide la compilation ; sa distribution nécessite une signature et une configuration de production.

Le build Android release refuse les connexions HTTP. Utiliser `flutter run` en debug pour la base locale HTTP, et une API HTTPS pour une application release.

Les builds release peuvent être longs. Gradle est limité à 2 Go de heap et deux workers ; sur la machine de validation de 16 Go, le build Android a pris environ 22 à 23 minutes. Lancer les builds Web et Android successivement lorsque la mémoire est limitée.

### GitHub Actions

Le workflow [Quality](.github/workflows/quality.yml) s’exécute sur les pushes et les pull requests :

- Job **Flutter** : installation, frontières architecturales, génération reproductible du bundle/questions, tests moteur, audit npm, formatage, analyse, tests Flutter, build Web release et APK debug.
- Job **Database** : démarrage Supabase, fixtures, tests HTTP, lint SQL et pgTAP, puis arrêt des services.

La CI utilise les configurations publiques d’exemple et ne déploie pas l’application ni les migrations en production. Consulter [les exécutions GitHub Actions](https://github.com/MorganPhlp/oikos/actions) pour leur statut réel.

## Préparer un déploiement

Avant une mise en production :

1. **Réconcilier le schéma existant.** L’historique SQL a divergé entre les branches et certaines migrations ont été corrigées pour être rejouables sur une base neuve. Sauvegarder l’environnement, comparer les historiques et préparer des migrations additives sur une copie de staging. Ne pas appliquer aveuglément cette chaîne avec `supabase db push` sur une base existante.
2. **Configurer l’environnement.** Fournir URL HTTPS et clé publique, configurer SMTP ainsi que les URLs Auth autorisées, puis vérifier confirmation et récupération de compte.
3. **Préparer les applications.** Utiliser [android/key.properties.example](android/key.properties.example) pour la signature Android. Configurer la signature iOS sur macOS et tester les liens profonds, la caméra et les permissions sur appareils.
4. **Valider les accès et les données.** Rejouer les scénarios multi-entreprises, ne pas charger les seeds de démonstration, examiner les anciennes données Auth présentes dans l’historique Git et invalider les identifiants concernés s’ils sont encore utilisés.
5. **Préparer l’exploitation.** Définir supervision, suivi des crashes, alertes, sauvegardes et procédure de restauration ; tester la charge et les erreurs réseau.

Les limites restantes comprennent notamment la recette exhaustive Publicodes/PDF, la pagination de certaines listes, la persistance du thème et le comportement hors connexion. Le [rapport d’intégration](docs/integration-report.md) en donne le détail.

## Dépannage

| Symptôme | Vérification / action |
| --- | --- |
| `supabase` ou `pwsh` introuvable | Installer la CLI Supabase et PowerShell 7 séparément, puis vérifier le `PATH` |
| Échec de démarrage Supabase | Démarrer Docker en mode conteneurs Linux, vérifier les ports et relancer `setup` |
| Configuration Flutter absente ou clé placeholder | Exécuter `scripts/local.ps1 -Action setup`, puis lancer Flutter avec le fichier local généré |
| Connexion impossible depuis Android | Utiliser `config/local.android.json` sur l’émulateur ; vérifier le réseau et la configuration spécifique sur téléphone physique |
| Ancienne interface après un build Web | Le service worker release peut nécessiter un second rechargement après activation ; préférer `flutter run` pendant le développement |
| Port 3000 déjà utilisé | Arrêter l’autre serveur de développement ou de prévisualisation avant de lancer le nouveau |
| Erreur de liens symboliques sous Windows | Activer le mode développeur Windows, puis relancer `flutter pub get` |
| Classes Freezed/JSON manquantes | Exécuter la génération `build_runner` |
| Données de démonstration modifiées par les tests | Réinitialiser uniquement le projet local avec `scripts/local.ps1 -Action reset` |
| Build Android long ou mémoire insuffisante | Lancer les builds successivement ; consulter la sortie Gradle avant de conclure à un blocage |
| Build iOS demandé depuis Windows | Utiliser une machine macOS avec Xcode |

## Contribuer

Lire [AGENTS.md](AGENTS.md), [l’architecture](docs/architecture.md) et, pour le SQL, [supabase/AGENTS.md](supabase/AGENTS.md).

- Préserver les parcours membres et administrateur lors des évolutions.
- Garder le domaine indépendant de l’infrastructure ; injecter les repositories et éviter les accès réseau depuis les widgets.
- Réutiliser la session et les tokens de thème communs.
- Ajouter une nouvelle migration pour une évolution SQL ; ne plus modifier une migration déjà appliquée.
- Ajouter des tests ciblés pour les règles modifiées et vérifier les cas de refus d’accès.
- Ne pas commiter de clés serveur, configurations privées, sessions, keystores ou fichiers de build.
- Documenter les décisions métier et les limites de validation dans la contribution.

Les changements de modèles doivent inclure leurs fichiers générés. Les changements SQL doivent être vérifiés sur une base locale rejouée, avec les tests d’autorisation.

## Documentation et équipe

| Document | Contenu |
| --- | --- |
| [Guide local](docs/local-development.md) | Commandes de développement, fixtures et environnements |
| [Architecture](docs/architecture.md) | Couches, session, thème, calcul et confidentialité |
| [Rapport d’intégration](docs/integration-report.md) | Fusion, corrections, validations et dette restante |
| [Instructions du dépôt](AGENTS.md) | Conventions pour les évolutions et agents |
| [Instructions Supabase](supabase/AGENTS.md) | Contrats SQL, sécurité, migrations et seeds |

**Auteurs :** Morgan PHILIPPE, Titouan BEAUVERGER, Julie KUEMKONG, Marko BABIC, Samy TCHOKOUNTE, Simon KHAN, Celena MAKOLE KANOUO.

**Parties prenantes Viveris :** Victoria Cueff, directrice adjointe Marketing, et Robin Marien, chef de projet IT.

La licence MIT de Publicodes est conservée dans [assets/js/PUBLICODES-LICENSE.txt](assets/js/PUBLICODES-LICENSE.txt). La police Outfit est distribuée avec sa licence OFL dans `assets/fonts`.
